import 'dart:convert';
import 'package:appstarbab/login.dart';
import 'package:appstarbab/mysql_database/BaseUrl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flushbar/flushbar.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  String hp, nama, password, verifiePass;
  final _key = new GlobalKey<FormState>();
  String msg = '';

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      registerasi();
    }
  }

  registerasi() async {
    final response = await http.post(BaseUrl.register, body: {
      'hp': "$hp",
      'nama': "$nama",
      'password': "$password",
      'verifie': "$verifiePass",
    });
    print(hp);
    print(nama);
    print(password);
    print(verifiePass);
    final data = jsonDecode(response.body);
    int value = data['value'];
    if (value == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return LoginPage();
        }),
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xff5364e8), // primaryColor
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _key,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: 50.0,
                ),
              ),
              _iconRegister(),
              _titleDescription(),
              _textField(),
              _buildButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconRegister() {
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
          "Registrasi",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ],
    );
  }

  Widget _textField() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: 25.0,
          ),
        ),
        TextFormField(
          onSaved: (e) => hp = e,
          // ignore: missing_return
          validator: (e) {
            if (e.isEmpty) {
              return "Nomor Hp tidak boleh kosong!";
            }
          },
          keyboardType: TextInputType.phone,
          style: TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            prefixIcon: Icon(
              Icons.phone,
              color: Colors.lightBlue,
            ),
            hintText: "Nomor Hp",
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
            top: 12.0,
          ),
        ),
        TextFormField(
          onSaved: (e) => nama = e,
          // ignore: missing_return
          validator: (e) {
            if (e.isEmpty) {
              return "Nama tidak boleh kosong!";
            }
          },
          style: TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            prefixIcon: Icon(
              Icons.person,
              color: Colors.lightBlue,
            ),
            hintText: "Nama",
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
            top: 12.0,
          ),
        ),
        TextFormField(
          onSaved: (e) => password = e,
          // ignore: missing_return
          validator: (e) {
            if (e.isEmpty) {
              return "Password tidak boleh kosong!";
            }
          },
          style: TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: Colors.lightBlue,
            ),
            hintText: "Password",
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
            top: 12.0,
          ),
        ),
        TextFormField(
          onSaved: (e) => verifiePass = e,
          // ignore: missing_return
          validator: (e) {
            if (e.isEmpty) {
              return "Password konfirmasi tidak boleh kosong!";
            }
          },
          style: TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            prefixIcon: Icon(
              Icons.check_box,
              color: Colors.lightBlue,
            ),
            hintText: "Konfirmasi Password",
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
              "Daftar",
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
                Text('Sudah punya akun? ',
                    style: TextStyle(fontSize: 15, color: Colors.white)),
                FlatButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return LoginPage();
                        }),
                      );
                    },
                    child: Text(
                      'MASUK',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    )),
              ],
            )),
      ],
    );
  }
}
