import 'dart:convert';
import 'package:appstarbab/login.dart';
import 'package:appstarbab/mysql_database/BaseUrl.dart';
import 'package:appstarbab/mysql_database/BetinaModel.dart';
import 'package:appstarbab/page_level2/addData.dart';
import 'package:flutter/material.dart';
import 'package:appstarbab/page_level2/detail.dart';
import 'package:appstarbab/drawer.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Search extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  String selectedResult;
  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Center(
        child: Text(selectedResult),
      ),
    );
  }

  final List<BetinaModel> listData;
  Search(this.listData);

  List<BetinaModel> recentList = [];

  @override
  Widget buildSuggestions(BuildContext context) {
    List<BetinaModel> tampungList = [];
    query.isEmpty
        ? tampungList = recentList
        : tampungList.addAll(listData.where(
            (element) => element.idBabi.contains(query),
          ));
    return ListView.builder(
      itemCount: tampungList.length,
      itemBuilder: (context, i) {
        final x = tampungList[i];
        return new Container(
          child: new GestureDetector(
            onTap: () => Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) =>
                      DetailDataPage(idBabi: x.idBabi)),
            ),
            child: new Card(
              child: ListTile(
                leading: Icon(
                  Icons.circle_notifications,
                  color: Colors.blueAccent,
                ),
                title: Text(x.idBabi),
                subtitle: Text(
                  x.status,
                  style: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic),
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
    );
  }
}

class BerandaPage extends StatefulWidget {
  static const String routeName = '/beranda';
  @override
  _BerandaPageState createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  String nomorUser = '';
  String namaUser;
  var loading = false;
  final daftarBetina = new List<BetinaModel>();

  @override
  void initState() {
    super.initState();
    cekLogin();
    cekUser();
    _ambilDataBetina();
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


  _ambilDataBetina() async {
    daftarBetina.clear();
    setState(() {
      loading = true;
    });
    final betina = await http.get(BaseUrl.getBetina);
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
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerPage(namaUser),
      appBar: AppBar(
        title: Text("Daftar Babi Betina"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white60,
              size: 28,
            ),
            onPressed: () {
              showSearch(context: context, delegate: Search(daftarBetina));
            },
          ),
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
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: daftarBetina.length,
              itemBuilder: (context, i) {
                final x = daftarBetina[i];
                return new Container(
                  child: new GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              DetailDataPage(idBabi: x.idBabi)),
                    ),
                    child: new Card(
                      child: ListTile(
                        leading: Icon(
                          Icons.circle_notifications,
                          color: Colors.blueAccent,
                        ),
                        title: Text(x.idBabi),
                        subtitle: Text(
                          x.status,
                          style: TextStyle(
                              fontSize: 14.0, fontStyle: FontStyle.italic),
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
      floatingActionButton: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new FloatingActionButton(
              heroTag: 'buttonAdd',
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) {
                    return AddDataBabi();
                  }),
                );
              },
              child: Icon(
                Icons.add,
                size: 30.0,
              ),
              backgroundColor: Color(0xff0096ff),
            ),
            new Container(
              height: 5.0,
            ),
            new FloatingActionButton(
              heroTag: 'buttonRefresh',
              onPressed: () {
                setState(() {
                  cekLogin();
                  cekUser();
                  _ambilDataBetina();
                });
              },
              child: Icon(
                Icons.refresh_sharp,
                size: 30.0,
              ),
              backgroundColor: Color(0xff6610f2),
            ),
          ],
        ),
      ),
    );
  }
}
