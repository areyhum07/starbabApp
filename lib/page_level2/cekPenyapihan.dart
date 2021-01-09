import 'dart:convert';
import 'package:appstarbab/home.dart';
import 'package:appstarbab/mysql_database/BaseUrl.dart';
import 'package:appstarbab/mysql_database/MenyusuiModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CekPenyapihan extends StatefulWidget {
  static const String routeName = '/cekPenyapihan';
  CekPenyapihan({this.id});
  final String id;

  @override
  _CekPenyapihanState createState() => _CekPenyapihanState();
}

class _CekPenyapihanState extends State<CekPenyapihan> {
  final dataSapih = new List<MenyusuiModel>();
  String indukan = '';
  String pejantan = '';
  String textAwal = '';
  String textAkhir = '';
  String status = '';
  DateTime awal;
  DateTime akhir;

  @override
  void initState() {
    _detailPenyapihan();
    super.initState();
  }

  _detailPenyapihan() async {
    dataSapih.clear();
    final sapih = await http.post(BaseUrl.getOnePenyapihan, body: {
      'idSapih': "${widget.id}",
    });
    if (sapih.contentLength != null) {
      final data = jsonDecode(sapih.body);
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
        dataSapih.add(data);
      });
      setState(() {
        indukan = dataSapih[0].kdInduk;
        pejantan = dataSapih[0].kdJantan;
        awal = dataSapih[0].awal;
        akhir = dataSapih[0].akhir;
        status = dataSapih[0].status;
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
      });
    }
  }

  updateStatusToSiapProduksi() async {
    final response = await http.post(BaseUrl.updateStatusInduk, body: {
      'idBabi': "$indukan",
      'status': 'S1',
    });
    final data = jsonDecode(response.body);
    String message = data['message'];
    print(message);
  }

  updateStatusToBerhasil() async {
    final response3 = await http.post(BaseUrl.updateStatusProses, body: {
      'idBabi': "$indukan",
      'cekStatus': "Penyapihan",
      'status': 'Berhasil',
    });
    final data = jsonDecode(response3.body);
    String message = data['message'];
    print(message);
  }

  updatePersentaseToDone() async {
    final response3 = await http.post(BaseUrl.updatePersentase, body: {
      'indukan': "$indukan",
      'getIDSapih': "${widget.id}",
      'getStatus': 'Selesai',
    });
    final data = jsonDecode(response3.body);
    String message = data['message'];
    print(message);
  }

  Future<Null> finishDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Konfirmasi',
                style: TextStyle(fontSize: 18.0, color: Colors.black87)),
            content: Text('Apakah babi ini sudah disapih?',
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
                  updateStatusToSiapProduksi();
                  updatePersentaseToDone();
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
        title: Text('Detail Penyapihan'),
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
                    'Mulai disapih',
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
                    'Selesai disapih',
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
                  "Siap Produksi",
                  style: TextStyle(fontSize: 16, color: Colors.blue[600]),
                ),
                onPressed: () {
                  finishDialog(context);
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
