import 'dart:convert';
import 'package:appstarbab/home.dart';
import 'package:appstarbab/mysql_database/BaseUrl.dart';
import 'package:appstarbab/mysql_database/BetinaModel.dart';
import 'package:appstarbab/mysql_database/GetIdModel.dart';
import 'package:appstarbab/mysql_database/PejantanModel.dart';
import 'package:appstarbab/page_level2/cekBunting.dart';
import 'package:appstarbab/page_level2/cekEstrus.dart';
import 'package:appstarbab/page_level2/cekMenyusui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:appstarbab/NotificationPluggin.dart';

class DetailDataPage extends StatefulWidget {
  static const String routeName = '/detail';
  DetailDataPage({this.idBabi});
  final String idBabi;
  @override
  _DetailDataPageState createState() => _DetailDataPageState();
}

class _DetailDataPageState extends State<DetailDataPage> {
  String ibuBabi = '';
  String ayahBabi = '';
  String jmlKawin = '';
  String jmlBunting = '';
  String jmlAnak = '';
  String statusCek = '';
  String statusReset = '';
  String ketMati = '';
  PejantanModel selectedPejantan;
  final daftarBetina = new List<BetinaModel>();
  final daftarPejantan = new List<PejantanModel>();
  final getIdKawin = new List<GetIdModel>();
  final getIdParams = new List<GetIdModel>();
  DateTime now = DateTime.now();
  DateTime tglLahir;
  DateTime start;
  DateTime finish;
  DateTime tglReset;
  String indukan;
  String pejantan;
  String textStart;
  String textFinish;
  String textDateReset;
  String dateChoice;
  int age;
  int getId;
  String getIdasParams;

  final conKetMati = TextEditingController();

  void initState() {
    super.initState();
    indukan = '${widget.idBabi}';
    _ambilDataBabi();
    _ambilDataPejantan();
    getIdForNotifie();
    start = now;
    textStart = "${now.day}/${now.month}/${now.year}";
    textDateReset = "${now.day}/${now.month}/${now.year}";
    finish = now.add(new Duration(days: 21));
    textFinish = "${finish.day}/${finish.month}/${finish.year}";
  }

  _ambilDataBabi() async {
    daftarBetina.clear();
    final betina = await http.post(BaseUrl.getOneBetina, body: {
      'idBabi': "$indukan",
    });
    if (betina.contentLength != null) {
      final data = jsonDecode(betina.body);
      data.forEach((dt) {
        final data = new BetinaModel(
          dt['idBabi'],
          DateFormat("yyyy-MM-dd").parse(dt['tglLahir']),
          dt['pejantan'],
          dt['indukan'],
          dt['jmlKawin'],
          dt['jmlBunting'],
          dt['jmlAnak'],
          dt['status'],
        );
        daftarBetina.add(data);
      });
      setState(() {
        ibuBabi = daftarBetina[0].indukan;
        ayahBabi = daftarBetina[0].pejantan;
        jmlKawin = daftarBetina[0].jmlKawin;
        jmlBunting = daftarBetina[0].jmlBunting;
        jmlAnak = daftarBetina[0].jmlAnak;
        statusCek = daftarBetina[0].status;
        tglLahir = daftarBetina[0].tglLahir;
        Duration range = now.difference(tglLahir);
        age = (range.inDays / 30).floor();
        getIdForParams(statusCek);
      });
    }
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

  addKawin() async {
    final response = await http.post(BaseUrl.addKawin, body: {
      'indukan': "$indukan",
      'pejantan': "$pejantan",
      'start': "$start",
      'finish': "$finish"
    });
    final data = jsonDecode(response.body);
    String message = data['message'];
    print(message);
    NotificationModel.scheduleNotfication(
      id: getId,
      title: 'Perkawinan',
      body: 'Apakah babi $indukan sudah bunting?',
      destination: finish,
    );
  }

  updateStatusToKawin() async {
    final response2 = await http.post(BaseUrl.updateStatusInduk, body: {
      'idBabi': "$indukan",
      'status': 'S2',
    });
    final data = jsonDecode(response2.body);
    String message = data['message'];
    print(message);
  }

  getIdForNotifie() async {
    final data = await http.post(BaseUrl.getidMax, body: {
      'proses': "Kawin",
    });
    if (data.contentLength != null) {
      final getData = jsonDecode(data.body);
      getData.forEach((dt) {
        final getData = new GetIdModel(
          dt['id'],
        );
        getIdKawin.add(getData);
      });
      setState(() {
        var cekNull = getIdKawin[0].id;
        if (cekNull == null) {
          getId = 1;
        } else {
          getId = int.parse(cekNull) + 1;
        }
      });
    }
    print(getId);
  }

  getIdForParams(String statusCek) async {
    final data = await http.post(BaseUrl.getidProses, body: {
      'idBabi': "$indukan",
      'proses': statusCek,
    });
    if (data.contentLength != null) {
      final getData = jsonDecode(data.body);

      if (statusCek == 'Kawin') {
        getData.forEach((dt) {
          final getIDKawin = new GetIdModel(
            dt['id_kawin'],
          );
          getIdParams.add(getIDKawin);
        });
      } else if (statusCek == 'Bunting') {
        getData.forEach((dt) {
          final getIDBunting = new GetIdModel(
            dt['id_bunting'],
          );
          getIdParams.add(getIDBunting);
        });
      } else if (statusCek == 'Menyusui') {
        getData.forEach((dt) {
          final getIDMenyusui = new GetIdModel(
            dt['id_menyusui'],
          );
          getIdParams.add(getIDMenyusui);
        });
      } else if (statusCek == 'Disapih') {
        getData.forEach((dt) {
          final getIDSapih = new GetIdModel(
            dt['id_sapih'],
          );
          getIdParams.add(getIDSapih);
        });
      } else {
        getData.forEach((dt) {
          final getID = new GetIdModel(
            dt['id'],
          );
          getIdParams.add(getID);
        });
      }
      setState(() {
        getIdasParams = getIdParams[0].id;
      });
    }
  }

  addToReset(String statusReset) async {
    final response2 = await http.post(BaseUrl.addReset, body: {
      'idBabi': "$indukan",
      'indukan': "$ibuBabi",
      'tgl': "$tglReset",
      'status': statusReset,
      'keterangan': '$ketMati',
    });
    final data = jsonDecode(response2.body);
    String message = data['message'];
    print(message);
  }

  deleteFromDataBabi() async {
    final delete = await http.post(BaseUrl.deleteDataBabi, body: {
      'idBabi': "$indukan",
    });
    print(indukan);
    final data = jsonDecode(delete.body);
    String message = data['message'];
    print(message);
  }

  updateStatusToGagal() async {
    final response3 = await http.post(BaseUrl.updateStatusProses, body: {
      'idBabi': "$indukan",
      'cekStatus': "$statusCek",
      'status': 'Gagal',
    });
    final data = jsonDecode(response3.body);
    String message = data['message'];
    print(message);
  }

  updateStatusToTerjual() async {
    final response3 = await http.post(BaseUrl.updateStatusInduk, body: {
      'idBabi': "$indukan",
      'status': 'S6',
    });
    final data = jsonDecode(response3.body);
    String message = data['message'];
    print(message);
  }

  updateJumlahKawin() async {
    final response3 = await http.post(BaseUrl.jumlahKawin, body: {
      'idBabi': "$indukan",
      'jantan': "$pejantan",
    });
    final data = jsonDecode(response3.body);
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

  Future<Null> _selectDateDead(BuildContext context) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(2010),
        lastDate: DateTime(2050));
    if (picked != null) {
      setState(() {
        tglReset = picked;
        textDateReset = DateFormat.yMd().format(tglReset);
        Navigator.of(context).pop();
        deadDialog(context);
      });
    }
  }

  Future<Null> _selectDateSell(BuildContext context) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(2010),
        lastDate: DateTime(2050));
    if (picked != null) {
      setState(() {
        tglReset = picked;
        textDateReset = DateFormat.yMd().format(tglReset);
        Navigator.of(context).pop();
        buyingDialog(context);
      });
    }
  }

  Future<bool> kawinDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey[100],
            title: Text(
              'Data Pengawinan Babi',
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
                  addKawin();
                  updateStatusToKawin();
                  updateJumlahKawin();
                  Navigator.of(context).pop();
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
                    textStart +
                    '\n\nStatus Kawin',
                style: TextStyle(fontSize: 18.0, color: Colors.black)),
            actions: <Widget>[
              FlatButton(
                child: Text('Oke'),
                textColor: Colors.white,
                color: Colors.blue[700],
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new HomePage()));
                },
              )
            ],
          );
        });
  }

  Future<Null> deadDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey[100],
            title: Text(
              'Keterangan babi mati',
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
                Padding(
                  padding: const EdgeInsets.only(
                      right: 0, left: 0, top: 15, bottom: 10),
                  child: new Row(
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: Text(
                            'Kode Babi',
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
                Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(flex: 1, child: Text('Tanggal Mati')),
                      Container(
                        width: 10.0,
                        child: Text(':'),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.grey[200],
                          child: new FlatButton(
                            onPressed: () => _selectDateDead(context),
                            child: Text(
                              textDateReset,
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
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    autofocus: true,
                    controller: conKetMati,
                    onChanged: (value) {
                      setState(() {
                        ketMati = conKetMati.text;
                      });
                    },
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16.0,
                    ),
                    decoration: InputDecoration(
                      labelText: "Keterangan mati",
                      labelStyle: TextStyle(
                        color: Colors.blue,
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
                child: Text('Simpan'),
                textColor: Colors.white,
                onPressed: () {
                  statusReset = 'Mati';
                  addToReset(statusReset);
                  updateStatusToGagal();
                  deleteFromDataBabi();
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new HomePage()));
                },
              )
            ],
          );
        });
  }

  Future<Null> buyingDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey[100],
            title: Text(
              'Keterangan babi terjual',
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
                Padding(
                  padding: const EdgeInsets.only(
                      right: 0, left: 0, top: 15, bottom: 10),
                  child: new Row(
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: Text(
                            'Kode Babi',
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
                Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(flex: 1, child: Text('Tanggal Mati')),
                      Container(
                        width: 10.0,
                        child: Text(':'),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.grey[200],
                          child: new FlatButton(
                            onPressed: () => _selectDateSell(context),
                            child: Text(
                              textDateReset,
                              style: new TextStyle(
                                  fontSize: 15.0, color: Colors.blue[600]),
                            ),
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
                child: Text('Simpan'),
                textColor: Colors.white,
                onPressed: () {
                  statusReset = 'Terjual';
                  addToReset(statusReset);
                  updateStatusToGagal();
                  deleteFromDataBabi();
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new HomePage()));
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff5364e8),
        title: Text('Detail'),
        elevation: 0.0,
      ),
      body: ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
            color: Color(0xff5364e8),
            child: Column(
              children: [
                Container(
                  height: 50.0,
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(
                        '${widget.idBabi}',
                        style: _textH2(),
                      ),
                      Text(
                        statusCek,
                        style: _textH4(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$jmlKawin',
                                style: _textH3(),
                              ),
                              Container(
                                height: 5.0,
                              ),
                              Text(
                                'Kawin',
                                style: _textH4(),
                              ),
                            ],
                          )),
                      Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$jmlBunting',
                                style: _textH3(),
                              ),
                              Container(
                                height: 5.0,
                              ),
                              Text(
                                'Bunting',
                                style: _textH4(),
                              )
                            ],
                          )),
                      Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$jmlAnak',
                                style: _textH3(),
                              ),
                              Container(
                                height: 5.0,
                              ),
                              Text(
                                'Anak',
                                style: _textH4(),
                              )
                            ],
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.album_outlined),
              title: Text(
                '$age Bulan',
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text('Umur'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.album_outlined),
              title: Text(
                '$ibuBabi',
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text('Indukan'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.album_rounded),
              title: Text(
                '$ayahBabi',
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                'Pejantan',
              ),
            ),
          ),
          Card(
            color: Colors.transparent,
            elevation: 0.0,
            child: Container(
              padding: EdgeInsets.only(
                right: 10.0,
                left: 10.0,
                top: 10.0,
              ),
              child: _btnKawinkan(statusCek),
            ),
          ),
        ],
      ),
    );
  }

  _btnKawinkan(String cekStatus) {
    if (cekStatus == 'Siap Produksi') {
      return Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: 40.0,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                color: Colors.red,
                splashColor: Colors.cyan,
                highlightColor: Colors.white,
                textColor: Colors.white,
                padding: EdgeInsets.all(0),
                child: Text(
                  "Mati",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                onPressed: () {
                  deadDialog(context);
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
                color: Colors.amber[700],
                splashColor: Colors.cyan,
                highlightColor: Colors.white,
                textColor: Colors.white,
                padding: EdgeInsets.all(0),
                child: Text(
                  "Terjual",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                onPressed: () {
                  buyingDialog(context);
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
                  "Kawinkan",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                onPressed: () {
                  kawinDialog(context);
                },
              ),
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: 40.0,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                color: Colors.red,
                splashColor: Colors.cyan,
                highlightColor: Colors.white,
                textColor: Colors.white,
                padding: EdgeInsets.all(0),
                child: Text(
                  "Mati",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                onPressed: () {
                  deadDialog(context);
                },
              ),
            ),
          ),
          Container(
            width: 10.0,
          ),
          widgetButton(cekStatus),
        ],
      );
    }
  }

  widgetButton(String cekStatus) {
    if (cekStatus == 'Kawin') {
      return Expanded(
        flex: 1,
        child: Container(
          height: 40.0,
          child: RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            color: Colors.green,
            splashColor: Colors.cyan,
            highlightColor: Colors.white,
            textColor: Colors.white,
            padding: EdgeInsets.all(0),
            child: Text(
              "Detail Perkawinan",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        CekEstrus(id: getIdasParams)),
              );
            },
          ),
        ),
      );
    } else if (cekStatus == 'Bunting') {
      return Expanded(
        flex: 1,
        child: Container(
          height: 40.0,
          child: RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            color: Colors.green,
            splashColor: Colors.cyan,
            highlightColor: Colors.white,
            textColor: Colors.white,
            padding: EdgeInsets.all(0),
            child: Text(
              "Detail Bunting",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        CekBunting(id: getIdasParams)),
              );
            },
          ),
        ),
      );
    } else if (cekStatus == 'Menyusui') {
      return Expanded(
        flex: 1,
        child: Container(
          height: 40.0,
          child: RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            color: Colors.green,
            splashColor: Colors.cyan,
            highlightColor: Colors.white,
            textColor: Colors.white,
            padding: EdgeInsets.all(0),
            child: Text(
              "Detail Menyusui",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        CekMenyusui(id: getIdasParams)),
              );
            },
          ),
        ),
      );
    } else if (cekStatus == 'Penyapihan') {
      return Expanded(
        flex: 1,
        child: Container(
          height: 40.0,
          child: RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            color: Colors.green,
            splashColor: Colors.cyan,
            highlightColor: Colors.white,
            textColor: Colors.white,
            padding: EdgeInsets.all(0),
            child: Text(
              "Detail Penyapihan",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            onPressed: () {},
          ),
        ),
      );
    } else {
      return new Text('');
    }
  }
}

_textH2() {
  return GoogleFonts.roboto(
    fontSize: 30,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );
}

_textH3() {
  return GoogleFonts.roboto(
    fontSize: 22,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );
}

_textH4() {
  return GoogleFonts.roboto(
    fontSize: 15,
    color: Colors.white70,
  );
}
