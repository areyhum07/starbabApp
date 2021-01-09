import 'dart:convert';
import 'package:appstarbab/mysql_database/BaseUrl.dart';
import 'package:appstarbab/registration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appstarbab/home.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flushbar/flushbar.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String username, password;
  final _key = new GlobalKey<FormState>();
  bool _obsecureText = true;
  String msg = '';

  @override
  void initState() {
    super.initState();
    cekLogin();
  }

  unHide() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    }
  }

  login() async {
    final response = await http.post(BaseUrl.login, body: {
      'username': username,
      'password': password,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String user = data['username'];
    String nama = data['nama'];

    if (value == 1) {
      savePref(user, nama);
    } else {
      setState(() {
        msg = data['message'];
        cekInputan(context, msg);
      });
      print(msg);
    }
  }

  cekInputan(BuildContext context, String text) {
    Flushbar(
      titleText: Text(
        "Login Gagal",
        style: TextStyle(color: Colors.redAccent),
      ),
      message: text,
      icon: Icon(
        Icons.info_outline,
        size: 20.0,
        color: Colors.redAccent,
      ),
      duration: Duration(seconds: 3),
    )..show(context);
  }

  savePref(String user, String nama) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setBool("isLogin", true);
      preferences.setString("user", user);
      preferences.setString("nama", nama);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return LoginPage();
        }),
      );
    });
  }

  Future cekLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getBool("isLogin") == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return HomePage();
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Color(0xff5364e8),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(20.0),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: 80.0,
              ),
            ),
            _iconApp(),
            _titleDescription(),
            _textField(_obsecureText),
            _buildButton(context),
          ],
        ),
      ),
    );
  }

  Widget _iconApp() {
    return Image(
      height: 150.0,
      image: AssetImage(
        "assets/images/appIcon.png",
      ),
      fit: BoxFit.fitHeight,
    );
  }

  Widget _titleDescription() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: 20.0,
          ),
        ),
        Text(
          "STARBAB",
          style: GoogleFonts.passionOne(
            fontSize: 45,
            color: Colors.amber,
          ),
        ),
      ],
    );
  }

  Widget _textField(bool obsecureText) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: 35.0,
          ),
        ),
        TextFormField(
          onSaved: (e) => username = e,
          // ignore: missing_return
          validator: (e) {
            if (e.isEmpty) {
              return "Silahkan masukkan nomor telfon anda";
            }
          },
          keyboardType: TextInputType.phone,
          style: TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Nomor Hp ",
            filled: true,
            prefixIcon: Icon(
              Icons.phone,
              color: Colors.lightBlue,
            ),
            hintStyle: TextStyle(color: Colors.white54),
            border: UnderlineInputBorder(),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
                width: 1.5,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 25.0,
          ),
        ),
        TextFormField(
          onSaved: (e) => password = e,
          // ignore: missing_return
          validator: (e) {
            if (e.isEmpty) {
              return "Silahkan masukkan password anda";
            }
          },
          cursorColor: Colors.lightBlue,
          obscureText: _obsecureText,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: Colors.lightBlue,
            ),
            hintText: "Password",
            filled: true,
            suffixIcon: IconButton(
              icon:
                  Icon(_obsecureText ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                unHide();
              },
            ),
            hintStyle: TextStyle(color: Colors.white54),
            border: UnderlineInputBorder(),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: 12.0,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 45,
          margin: EdgeInsets.only(top: 30),
          child: RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            color: Colors.cyanAccent[400],
            splashColor: Colors.cyan,
            highlightColor: Colors.white,
            textColor: Colors.white,
            padding: EdgeInsets.all(0),
            child: Text(
              "Masuk",
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            onPressed: () {
              check();
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 5.0,
          ),
        ),
        Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text('Belum punya akun? ',
                    style: TextStyle(fontSize: 15, color: Colors.white)),
                FlatButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return RegistrationPage();
                        }),
                      );
                    },
                    child: Text(
                      'DAFTAR DI SINI',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    )),
              ],
            )),
      ],
    );
  }
}

void _portraitModeOnly() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}
