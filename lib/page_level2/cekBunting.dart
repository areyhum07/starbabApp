import 'dart:convert';
import 'package:appstarbab/NotificationPluggin.dart';
import 'package:appstarbab/mysql_database/BaseUrl.dart';
import 'package:appstarbab/mysql_database/BuntingModel.dart';
import 'package:appstarbab/mysql_database/GetIdModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appstarbab/page_level2/addData.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CekBunting extends StatefulWidget {
  static const String routeName = '/cekBunting';
  CekBunting({this.id});
  final String id;

  @override
  _CekBuntingState createState() => _CekBuntingState();
}

class _CekBuntingState extends State<CekBunting> {
  final dataBunting = new List<BuntingModel>();
  final getIdMenyusui = new List<GetIdModel>();
  String indukan = '';
  String pejantan = '';
  String textAwal = '';
  String textAkhir = '';
  String status = '';
  DateTime awal;
  DateTime akhir;
  DateTime start;
  DateTime finalMenyusui;
  int getId;

  @override
  void initState() {
    _detailBunting();
    getIdForNotifie();
    super.initState();
  }

  _detailBunting() async {
    dataBunting.clear();
    final bunting = await http.post(BaseUrl.getOneBunting, body: {
      'idBunting': "${widget.id}",
    });
    if (bunting.contentLength != null) {
      final data = jsonDecode(bunting.body);
      data.forEach((dt) {
        final data = new BuntingModel(
          dt['id'],
          dt['kdInduk'],
          dt['kdJantan'],
          DateFormat("yyyy-MM-dd").parse(dt['awal']),
          DateFormat("yyyy-MM-dd").parse(dt['akhir']),
          dt['status'],
        );
        dataBunting.add(data);
      });
      setState(() {
        indukan = dataBunting[0].kdInduk;
        pejantan = dataBunting[0].kdJantan;
        awal = dataBunting[0].awal;
        akhir = dataBunting[0].akhir;
        status = dataBunting[0].status;
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
        finalMenyusui = start.add(new Duration(days: 30));
      });
    }
  }

  updateStatusToMenyusui() async {
    final response = await http.post(BaseUrl.updateStatusInduk, body: {
      'idBabi': "$indukan",
      'status': 'S4',
    });
    final data = jsonDecode(response.body);
    String message = data['message'];
    print(message);
  }

  updateStatusToBerhasil() async {
    final response3 = await http.post(BaseUrl.updateStatusProses, body: {
      'idBabi': "$indukan",
      'cekStatus': "Bunting",
      'status': 'Berhasil',
    });
    final data = jsonDecode(response3.body);
    String message = data['message'];
    print(message);
  }

  getIdForNotifie() async {
    final data = await http.post(BaseUrl.getidMax, body: {
      'proses': "Menyusui",
    });
    if (data.contentLength != null) {
      final getData = jsonDecode(data.body);
      getData.forEach((dt) {
        final getData = new GetIdModel(
          dt['id'],
        );
        getIdMenyusui.add(getData);
      });
      setState(() {
        var cekNull = getIdMenyusui[0].id;
        if (cekNull == null) {
          getId = 1;
        } else {
          getId = int.parse(cekNull) + 1;
        }
      });
    }
    print(getId);
  }

  addMenyusui() async {
    final response = await http.post(BaseUrl.addMenyusui, body: {
      'indukan': "$indukan",
      'pejantan': "$pejantan",
      'start': "$start",
      'finish': "$finalMenyusui"
    });
    final data = jsonDecode(response.body);
    String message = data['message'];
    print(message);
    NotificationModel.scheduleNotfication(
      id: getId,
      title: 'Menyusui',
      body: 'Apakah babi $indukan sudah selesai menyusui?',
      destination: finalMenyusui,
    );
    NotificationModel.removeNotification("${widget.id}");
  }

  Future<Null> buntingDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Konfirmasi',
                style: TextStyle(fontSize: 18.0, color: Colors.black87)),
            content: Text('Apakah babi ini telah melahirkan?',
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
                  updateStatusToMenyusui();
                  addMenyusui();
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) {
                      return AddDataBabi(indukan: indukan, pejantan: pejantan);
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
        title: Text('Detail Bunting'),
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
                    'KD Betina',
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
                    'KD Penjantan',
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
                    'Mulai Bunting',
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
                    textAwal,
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
            color: Colors.blue[100],
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
                    'Selesai Bunting',
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
              width: 130.0,
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
                  style: TextStyle(fontSize: 18, color: Colors.blue[600]),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  buntingDialog(context);
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
