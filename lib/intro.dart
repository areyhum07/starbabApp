import 'package:appstarbab/login.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Intro extends StatefulWidget {
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  List<Slide> slides = new List();

  prefOnStarted() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setBool("isStarted", true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return LoginPage();
        }),
      );
    });
  }

  Future onStarted() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getBool("isStarted") == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return LoginPage();
        }),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    onStarted();
    slides.add(
      new Slide(
        title: "Selamat Datang di STARBAB",
        marginTitle: EdgeInsets.only(
          top: 150.0,
          bottom: 50.0,
          right: 35.0,
          left: 35.0,
        ),
        maxLineTitle: 2,
        styleTitle: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description:
            "Buat catatan proses reproduksi ternak babi anda dengan mudah dan cepat",
        maxLineTextDescription: 2,
        marginDescription: EdgeInsets.only(
          right: 30.0,
          left: 30.0,
          top: 50.0,
        ),
        styleDescription: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
        pathImage: "assets/images/appIcon.png",
        backgroundColor: Color(0xff5364e8),
      ),
    );
    slides.add(
      new Slide(
        title: "Pencatatan",
        marginTitle: EdgeInsets.only(
          top: 150.0,
          bottom: 50.0,
          right: 35.0,
          left: 35.0,
        ),
        styleTitle: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description:
            "Tersedia form untuk membantu anda mencatat setiap proses produksi",
        maxLineTextDescription: 3,
        marginDescription: EdgeInsets.only(
          right: 30.0,
          left: 30.0,
          top: 50.0,
        ),
        styleDescription: TextStyle(
            color: Colors.white,
            fontSize: 17.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
        pathImage: "assets/images/form.png",
        backgroundColor: Color(0xff5364e8),
      ),
    );
    slides.add(
      new Slide(
        title: "Notifikasi",
        marginTitle: EdgeInsets.only(
          top: 150.0,
          bottom: 50.0,
          right: 35.0,
          left: 35.0,
        ),
        styleTitle: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description: "Membantu mengingatkan waktu pengecekan proses produksi",
        maxLineTextDescription: 2,
        marginDescription: EdgeInsets.only(
          right: 30.0,
          left: 30.0,
          top: 50.0,
        ),
        styleDescription: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
        pathImage: "assets/images/bell.png",
        backgroundColor: Color(0xff5364e8),
      ),
    );
  }

  void onDonePress() {
    prefOnStarted();
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      slides: this.slides,
      onDonePress: this.onDonePress,
    );
  }
}
