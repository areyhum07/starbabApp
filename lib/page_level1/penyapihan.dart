import 'dart:convert';
import 'package:appstarbab/login.dart';
import 'package:appstarbab/mysql_database/BaseUrl.dart';
import 'package:appstarbab/mysql_database/MenyusuiModel.dart';
import 'package:appstarbab/page_level2/cekPenyapihan.dart';
import 'package:flutter/material.dart';
import 'package:appstarbab/drawer.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PenyapihanPage extends StatefulWidget {
  static const String routeName = '/penyapihan';

  @override
  _PenyapihanPageState createState() => _PenyapihanPageState();
}

class _PenyapihanPageState extends State<PenyapihanPage> {
  String nomorUser = '';
  String namaUser;
  final daftarBabiSapih = new List<MenyusuiModel>();
  var loading = false;
  @override
  void initState() {
    super.initState();
    cekLogin();
    cekUser();
    _daftarBabiPenyapihan();
    username();
  }

  Future cekLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getBool("isLogin") == false) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return LoginPage();
        }),
      );
    }
  }

  Future cekUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString("user") != null) {
      setState(() {
        nomorUser = preferences.getString("user");
      });
    }
  }

  username() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      namaUser = preferences.getString("nama");
    });
  }

  _daftarBabiPenyapihan() async {
    daftarBabiSapih.clear();
    setState(() {
      loading = true;
    });
    final sapih = await http.get(BaseUrl.getPenyapihan);
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
        daftarBabiSapih.add(data);
      });
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerPage(namaUser),
      appBar: AppBar(
        title: Text("Penyapihan"),
        actions: [
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white60,
                size: 30,
              ),
              onPressed: null)
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xff0096ff), Color(0xff6610f2)],
                begin: FractionalOffset.topLeft,
                end: FractionalOffset.bottomRight),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: daftarBabiSapih.length,
        padding: EdgeInsets.all(10.0),
        itemBuilder: (context, int i) {
          final x = daftarBabiSapih[i];
          String akhir = "${x.akhir.day}/${x.akhir.month}/${x.akhir.year}";
          return new Container(
            child: new GestureDetector(
              onTap: () => Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) => CekPenyapihan(id: x.id)),
              ),
              child: new Card(
                child: ListTile(
                  leading: Icon(
                    Icons.circle_notifications,
                    color: Colors.blueAccent,
                  ),
                  title: Text(x.kdInduk),
                  subtitle: Text(akhir),
                  trailing: Icon(
                    Icons.arrow_right,
                    size: 40.0,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
