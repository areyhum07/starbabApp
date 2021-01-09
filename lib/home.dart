import 'package:appstarbab/login.dart';
import 'package:appstarbab/page_level1/penyapihan.dart';
import 'package:appstarbab/page_level1/petunjuk.dart';
import 'package:appstarbab/page_level2/addData.dart';
import 'package:appstarbab/page_level2/cekBunting.dart';
import 'package:appstarbab/page_level2/cekEstrus.dart';
import 'package:appstarbab/page_level2/cekMenyusui.dart';
import 'package:appstarbab/page_level2/cekPenyapihan.dart';
import 'package:appstarbab/page_level2/detail.dart';
import 'package:flutter/material.dart';
import 'package:appstarbab/routes.dart';
import 'package:appstarbab/page_level1/beranda.dart';
import 'package:appstarbab/page_level1/estrus.dart';
import 'package:appstarbab/page_level1/bunting.dart';
import 'package:appstarbab/page_level1/menyusui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'NotificationPluggin.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    cekLogin();
    initializeNotification(context);
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'STARBAB APP',
      home: BerandaPage(),
      routes: {
        Routes.beranda: (context) => BerandaPage(),
        Routes.estrus: (context) => EstrusPage(),
        Routes.bunting: (context) => BuntingPage(),
        Routes.menyusui: (context) => MenyusuiPage(),
        Routes.penyapihan: (context) => PenyapihanPage(),
        Routes.petunjuk: (context) => PetunjukPage(),
        Routes.addData: (context) => AddDataBabi(),
        Routes.detail: (context) => DetailDataPage(),
        Routes.cekEstrus: (context) => CekEstrus(),
        Routes.cekBunting: (context) => CekBunting(),
        Routes.cekMenyusui: (context) => CekMenyusui(),
        Routes.cekPenyapihan: (context) => CekPenyapihan(),
      },
    );
  }
}
