import 'dart:convert';
import 'package:appstarbab/home.dart';
import 'package:appstarbab/mysql_database/BaseUrl.dart';
import 'package:appstarbab/mysql_database/GetIdModel.dart';
import 'package:appstarbab/mysql_database/KawinModel.dart';
import 'package:appstarbab/mysql_database/PejantanModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:appstarbab/NotificationPluggin.dart';

class CekEstrus extends StatefulWidget {
  static const String routeName = '/cekEstrus';
  CekEstrus({this.id});
  final String id;
  @override
  _CekEstrusState createState() => _CekEstrusState();
}

class _CekEstrusState extends State<CekEstrus> {
  PejantanModel selectedPejantan;
  final daftarPejantan = new List<PejantanModel>();
  final dataKawin = new List<KawinModel>();
  final getIdBunting = new List<GetIdModel>();
  String indukan = '';
  String pejantan = '';
  String counter = '';
  String status = '';
  String textAwal = '';
  String textAkhir = '';
  DateTime now = DateTime.now();
  DateTime awal;
  DateTime akhir;
  DateTime start;
  DateTime finish;
  DateTime finalBunting;
  String textStart = '';
  String textFinish = '';
  int plusOne;
  String newCounter;
  int getId;

  @override
  void initState() {
    _ambilDataKawin();
    _ambilDataPejantan();
    getIdForNotifie();
    super.initState();
  }

  _ambilDataPejantan() async {
    daftarPejantan.clear();
    final betina = await http.get(BaseUrl.getPejantan);
    if (betina.contentLength != null) {
      final data = jsonDecode(betina.body);
      data.forEach((dt) {
        final data = new PejantanModel(
          dt['idBabi'],
        );
        daftarPejantan.add(data);
      });
    }
  }

  _ambilDataKawin() async {
    dataKawin.clear();
    final kawin = await http.post(BaseUrl.getOneKawin, body: {
      'idKawin': "${widget.id}",
    });
    if (kawin.contentLength != null) {
      final data = jsonDecode(kawin.body);
      data.forEach((dt) {
        final data = new KawinModel(
          dt['id'],
          dt['kdInduk'],
          dt['kdJantan'],
          DateFormat("yyyy-MM-dd").parse(dt['awal']),
          DateFormat("yyyy-MM-dd").parse(dt['akhir']),
          dt['counter'],
          dt['status'],
        );
        dataKawin.add(data);
      });
      setState(() {
        indukan = dataKawin[0].kdInduk;
        pejantan = dataKawin[0].kdJantan;
        awal = dataKawin[0].awal;
        akhir = dataKawin[0].akhir;
        counter = dataKawin[0].counter;
        plusOne = int.parse(counter);
        plusOne = plusOne + 1;
        newCounter = plusOne.toString();
        status = dataKawin[0].status;
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
        textStart = "${start.day}/${start.month}/${start.year}";
        finish = start.add(new Duration(days: 21));
        textFinish = "${finish.day}/${finish.month}/${finish.year}";
        finalBunting = start.add(new Duration(days: 94));
      });
    }
  }

  updateStatusToMandul() async {
    final response2 = await http.post(BaseUrl.updateStatusInduk, body: {
      'idBabi': "$indukan",
      'status': 'S5',
    });
    final data = jsonDecode(response2.body);
    String message = data['message'];
    print(message);
  }

  updateStatusToGagal() async {
    final response3 = await http.post(BaseUrl.updateStatusProses, body: {
      'idBabi': "$indukan",
      'cekStatus': "Kawin",
      'status': 'Gagal',
    });
    final data = jsonDecode(response3.body);
    String message = data['message'];
    print(message);
  }

  updateKawin() async {
    final response = await http.post(BaseUrl.updateKawin, body: {
      'idKawin': "${widget.id}",
      'pejantan': "$pejantan",
      'start': "$start",
      'finish': "$finish",
      'newCounter': "$newCounter",
    });
    final data = jsonDecode(response.body);
    String message = data['message'];
    print(message);
    NotificationModel.scheduleNotfication(
      id: int.parse(widget.id),
      title: 'Perkawinan',
      body: 'Apakah babi $indukan sudah bunting?',
      destination: finish,
    );
  }

  updateJumlahKawin() async {
    final dataJumlah = await http.post(BaseUrl.jumlahKawin, body: {
      'idBabi': "$indukan",
      'jantan': "$pejantan",
    });
    final data = jsonDecode(dataJumlah.body);
    String message = data['message'];
    print(message);
  }

  updateStatusToBerhasil() async {
    final response3 = await http.post(BaseUrl.updateStatusProses, body: {
      'idBabi': "$indukan",
      'cekStatus': "Kawin",
      'status': 'Berhasil',
    });
    final data = jsonDecode(response3.body);
    String message = data['message'];
    print(message);
  }

  getIdForNotifie() async {
    final data = await http.post(BaseUrl.getidMax, body: {
      'proses': "Bunting",
    });
    if (data.contentLength != null) {
      final getData = jsonDecode(data.body);
      getData.forEach((dt) {
        final getData = new GetIdModel(
          dt['id'],
        );
        getIdBunting.add(getData);
      });
      setState(() {
        var cekNull = getIdBunting[0].id;
        if (cekNull == null) {
          getId = 1;
        } else {
          getId = int.parse(cekNull) + 1;
        }
      });
    }
    print(getId);
  }

  addBunting() async {
    final response = await http.post(BaseUrl.addBunting, body: {
      'indukan': "$indukan",
      'pejantan': "$pejantan",
      'start': "$start",
      'finish': "$finalBunting",
      'idKawin': "${widget.id}",
    });
    final data = jsonDecode(response.body);
    String message = data['message'];
    print(message);
    NotificationModel.scheduleNotfication(
      id: getId,
      title: 'Bunting',
      body: 'Apakah babi $indukan sudah melahirkan?',
      destination: finalBunting,
    );
    NotificationModel.removeNotification("${widget.id}");
  }

  updateStatusToBunting() async {
    final response2 = await http.post(BaseUrl.updateStatusInduk, body: {
      'idBabi': "$indukan",
      'status': 'S3',
    });
    final data = jsonDecode(response2.body);
    String message = data['message'];
    print(message);
  }

  updateJumlahBunting() async {
    final dataJumlah = await http.post(BaseUrl.jumlahBunting, body: {
      'idBabi': "$indukan",
      'jantan': "$pejantan",
    });
    final data = jsonDecode(dataJumlah.body);
    String message = data['message'];
    print(message);
  }

  Future<Null> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: start,
        firstDate: DateTime(2010),
        lastDate: DateTime(2050));
    if (picked != null) {
      setState(() {
        start = picked;
        // textStart = "${picked.day}/${picked.month}/${picked.year}";
        textStart = DateFormat.yMd().format(start);
        finish = start.add(new Duration(days: 21));
        textFinish = DateFormat.yMd().format(finish);
        Navigator.of(context).pop();
        kawinDialog(context);
      });
    }
  }

  Future<Null> mandulDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Konfirmasi',
                style: TextStyle(fontSize: 18.0, color: Colors.black87)),
            content: Text('Apakah anda yakin babi ini mandul?',
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
                  updateStatusToMandul();
                  updateStatusToGagal();
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return HomePage();
                    }),
                  );
                },
              ),
            ],
          );
        });
  }

  Future<bool> kawinDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey[100],
            title: Text(
              'Kawinkan Ulang',
              style: new TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            content: Column(
              children: <Widget>[
                new Divider(
                  color: Colors.black,
                  height: 0,
                ),
                new Padding(
                  padding: const EdgeInsets.only(
                      right: 0, left: 0, top: 15, bottom: 10),
                  child: new Row(
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: Text(
                            'Betina',
                          )),
                      Container(
                        width: 10.0,
                        child: Text(':'),
                      ),
                      Expanded(
                        flex: 1,
                        child: new Text(
                          "$indukan",
                        ),
                      ),
                    ],
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(flex: 1, child: Text('Pejantan:')),
                      Container(
                        width: 10.0,
                        child: Text(':'),
                      ),
                      Expanded(
                        flex: 1,
                        child: DropdownButton<PejantanModel>(
                          hint: Text("Pilih"),
                          value: selectedPejantan,
                          items: daftarPejantan.map((PejantanModel kode) {
                            return DropdownMenuItem<PejantanModel>(
                              value: kode,
                              child: Text(
                                kode.idBabi,
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                          onChanged: (PejantanModel value) {
                            setState(() {
                              selectedPejantan = value;
                              pejantan = value.idBabi;
                              Navigator.of(context).pop();
                              kawinDialog(context);
                              setState(() {});
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(flex: 1, child: Text('Tanggal Awal')),
                      Container(
                        width: 10.0,
                        child: Text(':'),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.grey[200],
                          child: new FlatButton(
                            onPressed: () => _selectDate(context),
                            child: Text(
                              textStart,
                              style: new TextStyle(
                                  fontSize: 15.0, color: Colors.blue[600]),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(flex: 1, child: Text('Tanggal Akhir')),
                      Container(
                        width: 10.0,
                        child: Text(':'),
                      ),
                      Expanded(
                        flex: 1,
                        child: new Text(
                          textFinish,
                          style: new TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                child: Text('Kembali'),
                textColor: Colors.black,
                color: Colors.grey[400],
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                color: Colors.blue,
                child: Text('Mulai'),
                textColor: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop();
                  updateKawin();
                  updateJumlahKawin();
                  dialogTrigger(context);
                },
              )
            ],
          );
        });
  }

  Future<Null> dialogTrigger(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Konfirmasi',
                style: TextStyle(fontSize: 18.0, color: Colors.green[400])),
            content: Text(
                'Perkawinan telah dimulai dan waktu mulai terhitung dari tanggal \n' +
                    textStart,
                style: TextStyle(fontSize: 18.0, color: Colors.black)),
            actions: <Widget>[
              FlatButton(
                child: Text('Oke'),
                textColor: Colors.white,
                color: Colors.blue[700],
                onPressed: () {
                  _ambilDataKawin();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future<Null> buntingDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Konfirmasi',
                style: TextStyle(fontSize: 18.0, color: Colors.black87)),
            content: Text('Apakah anda yakin babi ini sudah bunting?',
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
                  addBunting();
                  updateStatusToBunting();
                  updateJumlahBunting();
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new HomePage()));
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
        title: Text('Detail Perkawinan'),
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
            margin: EdgeInsets.only(
              right: 10.0,
              left: 10.0,
            ),
            padding: EdgeInsets.all(5.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          right: 10.0,
                          left: 10.0,
                        ),
                        color: Colors.amber,
                        height: 50.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
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
                              child: Text(
                                indukan,
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
                        padding: EdgeInsets.only(
                          right: 10.0,
                          left: 10.0,
                        ),
                        color: Colors.grey[200],
                        height: 50.0,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
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
                              child: Text(
                                pejantan,
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
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(left: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[400],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.0),
                          color: Colors.amber,
                          height: 50.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Kawin',
                                style: GoogleFonts.roboto(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          height: 50.0,
                          child: Text(
                            "$counter x",
                            style: GoogleFonts.roboto(
                              fontSize: 22.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                    'Mulai Kawin',
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
            color: Colors.grey[200],
            height: 60.0,
            margin: EdgeInsets.only(
              right: 15.0,
              left: 15.0,
              top: 10.0,
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
                    'Cek Kebuntingan',
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
            margin: EdgeInsets.only(
              right: 15.0,
              left: 15.0,
              top: 15.0,
            ),
            child: _buttonCheck(),
          ),
        ],
      ),
    );
  }

  Widget _buttonCheck() {
    if (status == 'Menunggu') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: 40.0,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                color: Colors.redAccent,
                splashColor: Colors.cyan,
                highlightColor: Colors.white,
                textColor: Colors.white,
                padding: EdgeInsets.all(0),
                child: Text(
                  "Mandul",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                onPressed: () {
                  mandulDialog(context);
                },
              ),
            ),
          ),
          Container(
            width: 10.0,
          ),
          Expanded(
            flex: 2,
            child: Container(
              height: 40.0,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                color: Colors.amber[700],
                splashColor: Colors.cyan,
                highlightColor: Colors.white,
                textColor: Colors.white,
                padding: EdgeInsets.all(0),
                child: Text(
                  "Kawinkan Ulang",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                onPressed: () {
                  kawinDialog(context);
                },
              ),
            ),
          ),
          Container(
            width: 10.0,
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: 40.0,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                color: Colors.green[600],
                splashColor: Colors.cyan,
                highlightColor: Colors.white,
                textColor: Colors.white,
                padding: EdgeInsets.all(0),
                child: Text(
                  "Bunting",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                onPressed: () {
                  buntingDialog(context);
                },
              ),
            ),
          ),
        ],
      );
    } else {
      return Text('');
    }
  }
}
