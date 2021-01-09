import 'dart:convert';
import 'package:appstarbab/NotificationPluggin.dart';
import 'package:appstarbab/home.dart';
import 'package:appstarbab/mysql_database/BaseUrl.dart';
import 'package:appstarbab/mysql_database/BetinaModel.dart';
import 'package:appstarbab/mysql_database/GetIdModel.dart';
import 'package:appstarbab/mysql_database/MenyusuiModel.dart';
import 'package:appstarbab/page_level2/detail.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class CekMenyusui extends StatefulWidget {
  static const String routeName = '/cekMenyusui';
  CekMenyusui({this.id});
  final String id;

  @override
  _CekMenyusuiState createState() => _CekMenyusuiState();
}

class _CekMenyusuiState extends State<CekMenyusui> {
  final dataMenyusui = new List<MenyusuiModel>();
  final daftarAnak = new List<BetinaModel>();
  final getIdSapih = new List<GetIdModel>();
  var loading = false;
  String indukan = '';
  String pejantan = '';
  String textAwal = '';
  String textAkhir = '';
  String status = '';
  int anakLahir;
  int anakMati;
  int anakHidupSapih;
  DateTime awal;
  DateTime akhir;
  DateTime start;
  DateTime finalPenyapihan;
  int getId;

  @override
  void initState() {
    _detailMenyusui();
    getIdForNotifie();
    super.initState();
  }

  _detailMenyusui() async {
    dataMenyusui.clear();
    final menyusui = await http.post(BaseUrl.getOneMenyusui, body: {
      'idMenyusui': "${widget.id}",
    });
    if (menyusui.contentLength != null) {
      final data = jsonDecode(menyusui.body);
      data.forEach((dt) {
        final data = new MenyusuiModel(
          dt['id'],
          dt['kdInduk'],
          dt['kdJantan'],
          DateFormat("yyyy-MM-dd").parse(dt['awal']),
          DateFormat("yyyy-MM-dd").parse(dt['akhir']),
          dt['status'],
          dt['anakLahir'],
          dt['anakMati'],
        );
        dataMenyusui.add(data);
      });
      setState(() {
        indukan = dataMenyusui[0].kdInduk;
        pejantan = dataMenyusui[0].kdJantan;
        awal = dataMenyusui[0].awal;
        akhir = dataMenyusui[0].akhir;
        status = dataMenyusui[0].status;
        anakLahir = int.parse(dataMenyusui[0].anakLahir);
        anakMati = int.parse(dataMenyusui[0].anakMati);
        anakHidupSapih = anakLahir - anakMati;
        textAwal = awal.day.toString() +
            "/" +
            awal.month.toString() +
            "/" +
            awal.year.toString();
        textAkhir = akhir.day.toString() +
            "/" +
            akhir.month.toString() +
            "/" +
            akhir.year.toString();
        start = akhir;
        finalPenyapihan = start.add(new Duration(days: 30));
        _ambilDataAnak();
      });
    }
  }

  getIdForNotifie() async {
    final data = await http.post(BaseUrl.getidMax, body: {
      'proses': "Penyapihan",
    });
    if (data.contentLength != null) {
      final getData = jsonDecode(data.body);
      getData.forEach((dt) {
        final getData = new GetIdModel(
          dt['id'],
        );
        getIdSapih.add(getData);
      });
      setState(() {
        var cekNull = getIdSapih[0].id;
        if (cekNull == null) {
          getId = 1;
        } else {
          getId = int.parse(cekNull) + 1;
        }
      });
    }
    print(getId);
  }

  _ambilDataAnak() async {
    daftarAnak.clear();
    setState(() {
      loading = true;
    });
    final anak = await http.post(BaseUrl.getAnak, body: {
      'indukan': "$indukan",
      'pejantan': "$pejantan",
    });
    if (anak.contentLength != null) {
      final data = jsonDecode(anak.body);
      data.forEach((dt) {
        final data = new BetinaModel(
          dt['idBabi'],
          DateFormat("yyyy-MM-dd").parse(dt['tglLahir']),
          dt['pejantan'],
          dt['indukan'],
          dt['jmlKawin'],
          dt['jmlBunting'],
          dt['jmlAnak'],
          dt['status'],
        );
        daftarAnak.add(data);
      });
      setState(() {
        loading = false;
      });
    }
  }

  updateStatusToSapih() async {
    final response = await http.post(BaseUrl.updateStatusInduk, body: {
      'idBabi': "$indukan",
      'status': 'S8',
    });
    final data = jsonDecode(response.body);
    String message = data['message'];
    print(message);
  }

  updateStatusToBerhasil() async {
    final response3 = await http.post(BaseUrl.updateStatusProses, body: {
      'idBabi': "$indukan",
      'cekStatus': "Menyusui",
      'status': 'Berhasil',
    });
    final data = jsonDecode(response3.body);
    String message = data['message'];
    print(message);
  }

  addSapih() async {
    final sapih = await http.post(BaseUrl.addPenyapihan, body: {
      'indukan': "$indukan",
      'pejantan': "$pejantan",
      'start': "$start",
      'finish': "$finalPenyapihan",
      'anakHidup': "$anakHidupSapih",
      'idMenyusui': "${widget.id}"
    });
    final data = jsonDecode(sapih.body);
    String message = data['message'];
    print(message);
    NotificationModel.scheduleNotfication(
      id: getId,
      title: 'Penyapihan',
      body: 'Apakah babi $indukan sudah siap produksi lagi?',
      destination: finalPenyapihan,
    );
    NotificationModel.removeNotification("${widget.id}");
  }

  Future<Null> sapihDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Konfirmasi',
                style: TextStyle(fontSize: 18.0, color: Colors.black87)),
            content: Text('Apakah babi $indukan sudah selesai menyusui?',
                style: TextStyle(fontSize: 18.0, color: Colors.black)),
            actions: <Widget>[
              FlatButton(
                child: Text('Tidak'),
                textColor: Colors.black87,
                color: Colors.grey[400],
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Ya'),
                textColor: Colors.white,
                color: Colors.blue[700],
                onPressed: () {
                  updateStatusToBerhasil();
                  updateStatusToSapih();
                  addSapih();
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) {
                      return HomePage();
                    }),
                  );
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Menyusui'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xff0096ff), Color(0xff6610f2)],
                begin: FractionalOffset.topLeft,
                end: FractionalOffset.bottomRight),
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.grey[300],
            height: 60.0,
            margin: EdgeInsets.only(right: 15.0, left: 15.0, top: 5.0),
            padding: EdgeInsets.only(right: 10.0, left: 10.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'KD Indukan',
                    style: GoogleFonts.roboto(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    indukan,
                    style: GoogleFonts.roboto(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.right,
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Colors.blue[100],
            height: 60.0,
            margin: EdgeInsets.only(right: 15.0, left: 15.0, top: 5.0),
            padding: EdgeInsets.only(right: 10.0, left: 10.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'KD Pejantan',
                    style: GoogleFonts.roboto(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    pejantan,
                    style: GoogleFonts.roboto(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.right,
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Colors.grey[200],
            height: 60.0,
            margin: EdgeInsets.only(
              right: 15.0,
              left: 15.0,
              top: 5.0,
            ),
            padding: EdgeInsets.only(
              right: 10.0,
              left: 10.0,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Selesai Menyusui',
                    style: GoogleFonts.roboto(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    textAkhir,
                    style: GoogleFonts.roboto(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.amber,
            height: 50.0,
            margin: EdgeInsets.only(right: 15.0, left: 15.0, top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'DAFTAR ANAK',
                  style: GoogleFonts.roboto(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 15.0, left: 15.0, top: 10.0),
            color: Colors.grey[200],
            height: 450.0,
            child: ListView.builder(
              itemCount: daftarAnak.length,
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, int i) {
                final x = daftarAnak[i];
                final count = i + 1;
                return new Container(
                  child: new GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              DetailDataPage(idBabi: x.idBabi)),
                    ),
                    child: new Card(
                      color: Colors.white,
                      child: ListTile(
                        leading: Icon(Icons.rounded_corner),
                        title: Text(x.idBabi),
                        subtitle: Text('Anak Ke- $count'),
                        trailing: Icon(Icons.arrow_right),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          _buttonCheck(),
        ],
      ),
    );
  }

  Widget _buttonCheck() {
    if (status == 'Menunggu') {
      return Container(
        height: 60.0,
        margin: EdgeInsets.only(right: 15.0, left: 15.0, top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150.0,
              height: 45.0,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(color: Colors.blue[600], width: 2),
                ),
                color: Colors.grey[100],
                splashColor: Colors.cyan,
                highlightColor: Colors.blueAccent,
                textColor: Colors.blue[600],
                padding: EdgeInsets.all(0),
                child: Text(
                  "Selesai",
                  style: TextStyle(fontSize: 17, color: Colors.blue[600]),
                ),
                onPressed: () {
                  sapihDialog(context);
                },
              ),
            ),
          ],
        ),
      );
    } else {
      return Text('');
    }
  }
}
