import 'dart:async';
import 'dart:convert';
import 'package:appstarbab/login.dart';
import 'package:appstarbab/mysql_database/BaseUrl.dart';
import 'package:appstarbab/mysql_database/KawinModel.dart';
import 'package:flutter/material.dart';
import 'package:appstarbab/drawer.dart';
import 'package:appstarbab/page_level2/cekEstrus.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EstrusPage extends StatefulWidget {
  static const String routeName = '/estrus';

  @override
  _EstrusPageState createState() => _EstrusPageState();
}

class _EstrusPageState extends State<EstrusPage> {
  String nomorUser = '';
  String namaUser;
  final daftarKawin = new List<KawinModel>();
  var loading = false;
  DateTime now;

  @override
  void initState() {
    super.initState();
    cekLogin();
    cekUser();
    now = DateTime.now();
    _ambilDataKawin();
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

  _ambilDataKawin() async {
    daftarKawin.clear();
    setState(() {
      loading = true;
    });
    final kawin = await http.get(BaseUrl.getKawin);
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
        daftarKawin.add(data);
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
        title: Text("Daftar Perkawinan"),
        // actions: [
        //   IconButton(
        //       icon: Icon(
        //         Icons.notifications,
        //         color: Colors.white60,
        //         size: 30,
        //       ),
        //       onPressed: () async {
        //         // thisNotificationPluggin.nowNotification(id: 3, body: "Kode1");
        //       }),
        // ],
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
        itemCount: daftarKawin.length,
        padding: EdgeInsets.all(10.0),
        itemBuilder: (context, int i) {
          final x = daftarKawin[i];
          String akhir = "${x.akhir.day}/${x.akhir.month}/${x.akhir.year}";
          return new Container(
            child: new GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => CekEstrus(id: x.id)),
                );
              },
              child: new Card(
                child: ListTile(
                  leading: Icon(
                    Icons.circle_notifications,
                    color: Colors.blueAccent,
                  ),
                  title: Text(x.kdInduk),
                  subtitle: Text(
                    akhir,
                    style:
                        TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic),
                  ),
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
