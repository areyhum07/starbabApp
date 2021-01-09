import 'dart:convert';
import 'package:appstarbab/home.dart';
import 'package:appstarbab/mysql_database/BaseUrl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddDataBabi extends StatefulWidget {
  static const String routeName = '/addData';
  AddDataBabi({this.indukan, this.pejantan});
  final String indukan;
  final String pejantan;
  @override
  _AddDataBabiState createState() => _AddDataBabiState();
}

class _AddDataBabiState extends State<AddDataBabi> {
  String indukan = '';
  String pejantan = '';
  String status = '';
  DateTime lahir = DateTime.now();
  String _dateText = '';
  String _kelamin;
  int _kelaminGroup = -1;
  String idBabi;
  bool enabledTextField = true;

  final List<RadioGroup> pilihKelamin = [
    RadioGroup(index: 1, text: "Betina"),
    RadioGroup(index: 2, text: "Jantan"),
  ];

  final conIdBabi = TextEditingController();
  final conIndukan = TextEditingController();
  final conPejantan = TextEditingController();

  void initState() {
    indukan = "${widget.indukan}";
    pejantan = "${widget.pejantan}";
    conIndukan.text = indukan;
    conPejantan.text = pejantan;
    _dateText = '${lahir.day}/${lahir.month}/${lahir.year}';
    status = 'S1';
    _cekParams();
    print(enabledTextField);
    super.initState();
  }

  void dispose() {
    conIdBabi.dispose();
    conIndukan.dispose();
    conPejantan.dispose();
    super.dispose();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: lahir,
        firstDate: DateTime(2010),
        lastDate: DateTime(2050));
    if (picked != null) {
      setState(() {
        lahir = picked;
        _dateText = "${picked.day}/${picked.month}/${picked.year}";
        AddDataBabi();
      });
    }
  }

  _cekParams() {
    if (indukan == 'null' && pejantan == 'null') {
      conIndukan.text = '';
      conPejantan.text = '';
      enabledTextField = true;
    } else if (indukan != 'null' && pejantan != 'null') {
      enabledTextField = false;
    }
  }

  _addDataAnak() async {
    // print("$idBabi");
    // print("$lahir");
    // print("$_kelamin");
    // print("$indukan");
    // print("$pejantan");
    final response = await http.post(BaseUrl.addAnak, body: {
      'idBabi': "$idBabi",
      'lahir': "$lahir",
      'kelamin': "$_kelamin",
      'pejantan': "$pejantan",
      'indukan': "$indukan"
    });
    final data = jsonDecode(response.body);
    String message = data['message'];
    print(message);
  }

  updateJumlahAnak() async {
    final dataJumlah = await http.post(BaseUrl.jumlahAnak, body: {
      'idBabi': "$indukan",
      'jantan': "$pejantan",
    });
    final data = jsonDecode(dataJumlah.body);
    String message = data['message'];
    print(message);
  }

  Future<bool> dialogTrigger(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Berhasil!',
                style: TextStyle(fontSize: 18.0, color: Colors.green[400])),
            content: Text(
                'Data babi baru telah ditambahkan, ingin tambah lagi?',
                style: TextStyle(fontSize: 18.0, color: Colors.black)),
            actions: <Widget>[
              FlatButton(
                child: Text('Tidak'),
                textColor: Colors.black87,
                color: Colors.grey[400],
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new HomePage()));
                },
              ),
              FlatButton(
                child: Text('Ya'),
                textColor: Colors.white,
                color: Colors.blue[700],
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) {
                      return AddDataBabi(
                        indukan: indukan,
                        pejantan: pejantan,
                      );
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
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Tambah Data Babi'),
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
            margin: EdgeInsets.only(right: 5.0, left: 5.0, top: 10.0),
            height: 70.0,
            padding: EdgeInsets.only(
              right: 5.0,
              left: 5.0,
            ),
            child: Card(
              elevation: 0.0,
              child: TextField(
                autofocus: true,
                controller: conIdBabi,
                onChanged: (value) {
                  setState(() {
                    idBabi = conIdBabi.text;
                  });
                },
                style: TextStyle(
                  color: Colors.blue[600],
                  fontSize: 20.0,
                ),
                decoration: InputDecoration(
                  labelText: "Kode Babi Baru",
                  labelStyle: TextStyle(
                    color: Colors.black87,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.amber,
                        width: 10.0,
                      )),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              right: 5.0,
              left: 5.0,
            ),
            height: 70.0,
            padding: EdgeInsets.only(
              right: 5.0,
              left: 5.0,
            ),
            child: Card(
              elevation: 0.0,
              margin: EdgeInsets.all(5.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    indukan = conIndukan.text;
                  });
                },
                enabled: enabledTextField,
                controller: conIndukan,
                style: TextStyle(
                  color: Colors.blue[600],
                  fontSize: 20.0,
                ),
                decoration: InputDecoration(
                  labelText: "Kode Ibu Babi",
                  labelStyle: TextStyle(
                    color: Colors.black87,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.amber,
                        width: 10.0,
                      )),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              right: 5.0,
              left: 5.0,
            ),
            height: 70.0,
            padding: EdgeInsets.only(
              right: 5.0,
              left: 5.0,
            ),
            child: Card(
              elevation: 0.0,
              margin: EdgeInsets.all(5.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    pejantan = conPejantan.text;
                  });
                },
                enabled: enabledTextField,
                controller: conPejantan,
                style: TextStyle(
                  color: Colors.blue[600],
                  fontSize: 20.0,
                ),
                decoration: InputDecoration(
                  labelText: "Kode Ayah Babi",
                  labelStyle: TextStyle(
                    color: Colors.black87,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.amber,
                        width: 10.0,
                      )),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              right: 5.0,
              left: 5.0,
            ),
            height: 70.0,
            child: Card(
              elevation: 0.0,
              margin: EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: Text(
                      'Tanggal Lahir :',
                      style: new TextStyle(
                        fontSize: 18.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    color: Colors.grey[200],
                    child: new FlatButton(
                      onPressed: () => _selectDate(context),
                      child: Text(
                        _dateText,
                        style: new TextStyle(
                            fontSize: 15.0, color: Colors.blue[600]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              right: 5.0,
              left: 5.0,
            ),
            height: 70.0,
            child: Card(
              elevation: 0.0,
              margin: EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: Text(
                      'Jenis Kelamin :',
                      style: new TextStyle(
                        fontSize: 18.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    color: Colors.grey[200],
                    child: _radioButtonKelamin(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20.0),
            alignment: Alignment.topCenter,
            child: Container(
              width: 120.0,
              height: 40.0,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(color: Colors.blue, width: 1.5),
                ),
                color: Colors.grey[100],
                splashColor: Colors.cyan,
                highlightColor: Colors.blueAccent,
                textColor: Colors.white,
                padding: EdgeInsets.all(0),
                child: Text(
                  "Tambah",
                  style: TextStyle(fontSize: 15, color: Colors.blue[600]),
                ),
                onPressed: () {
                  _addDataAnak();
                  updateJumlahAnak();
                  Navigator.of(context).pop();
                  dialogTrigger(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _radioButtonKelamin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: pilihKelamin
          .map(
            (kelamin) => Row(
              children: [
                Radio(
                  value: kelamin.index,
                  groupValue: _kelaminGroup,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  onChanged: (value) {
                    setState(() {
                      _kelaminGroup = value;
                      _kelamin = kelamin.text;
                      AddDataBabi();
                    });
                  },
                ),
                Text(kelamin.text),
              ],
            ),
          )
          .toList(),
    );
  }
}

class RadioGroup {
  final int index;
  final String text;
  RadioGroup({this.index, this.text});
}
