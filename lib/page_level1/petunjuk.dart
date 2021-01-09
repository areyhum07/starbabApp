import 'package:appstarbab/drawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PetunjukPage extends StatefulWidget {
  static const String routeName = '/petunjuk';
  @override
  _PetunjukPageState createState() => _PetunjukPageState();
}

class _PetunjukPageState extends State<PetunjukPage> {
  String namaUser = '';
  bool show1 = false;
  bool show2 = false;
  bool show3 = false;
  bool show4 = false;
  bool show5 = false;

  @override
  void initState() {
    super.initState();
    username();
  }

  username() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      namaUser = preferences.getString("nama");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerPage(namaUser),
      appBar: AppBar(
        title: Text("Petunjuk"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xff0096ff), Color(0xff6610f2)],
                begin: FractionalOffset.topLeft,
                end: FractionalOffset.bottomRight),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              child: new GestureDetector(
                onTap: () {
                  setState(() {
                    show1 = !show1;
                  });
                },
                child: new Card(
                  color: Colors.grey[200],
                  child: ListTile(
                    leading: Icon(
                      show1 ? Icons.help_outline : Icons.help,
                      color: Colors.blue,
                    ),
                    title: Text(
                      'Apa itu STARBAB?',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: show1 ? Colors.black87 : Colors.blue,
                      ),
                    ),
                    trailing: Icon(
                      show1 ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      size: 40.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            show1 ? _desc1() : Container(),
            Container(
              child: new GestureDetector(
                onTap: () {
                  setState(() {
                    show2 = !show2;
                  });
                },
                child: new Card(
                  color: Colors.grey[200],
                  child: ListTile(
                    leading: Icon(
                      show2 ? Icons.help_outline : Icons.help,
                      color: Colors.blue,
                    ),
                    title: Text(
                      'Bagaimana menambah data babi?',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: show2 ? Colors.black87 : Colors.blue,
                      ),
                    ),
                    trailing: Icon(
                      show2 ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      size: 40.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            show2 ? _desc2() : Container(),
            Container(
              child: new GestureDetector(
                onTap: () {
                  setState(() {
                    show3 = !show3;
                  });
                },
                child: new Card(
                  color: Colors.grey[200],
                  child: ListTile(
                    leading: Icon(
                      show3 ? Icons.help_outline : Icons.help,
                      color: Colors.blue,
                    ),
                    title: Text(
                      'Bagaimana mencatat perkawinan babi?',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: show3 ? Colors.black87 : Colors.blue,
                      ),
                    ),
                    trailing: Icon(
                      show3 ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      size: 40.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            show3 ? _desc3() : Container(),
            Container(
              child: new GestureDetector(
                onTap: () {
                  setState(() {
                    show4 = !show4;
                  });
                },
                child: new Card(
                  color: Colors.grey[200],
                  child: ListTile(
                    leading: Icon(
                      show4 ? Icons.help_outline : Icons.help,
                      color: Colors.blue,
                    ),
                    title: Text(
                      'Bagaimana menghapus data babi yang mati?',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: show4 ? Colors.black87 : Colors.blue,
                      ),
                    ),
                    trailing: Icon(
                      show4 ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      size: 40.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            show4 ? _desc4() : Container(),
            Container(
              child: new GestureDetector(
                onTap: () {
                  setState(() {
                    show5 = !show5;
                  });
                },
                child: new Card(
                  color: Colors.grey[200],
                  child: ListTile(
                    leading: Icon(
                      show5 ? Icons.help_outline : Icons.help,
                      color: Colors.blue,
                    ),
                    title: Text(
                      'Bagaimana menghapus data babi yang terjual?',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: show5 ? Colors.black87 : Colors.blue,
                      ),
                    ),
                    trailing: Icon(
                      show5 ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      size: 40.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            show5 ? _desc5() : Container(),
          ],
        ),
      ),
    );
  }

  Widget _desc1() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200.0,
      padding: EdgeInsets.all(20.0),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
            style: TextStyle(fontSize: 15.0, color: Colors.black),
            children: <TextSpan>[
              TextSpan(
                  text: '       STARBAB',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0)),
              TextSpan(
                text:
                    ' adalah aplikasi yang membantu anda khususnya peternak babi dalam proses mengembangbiakkan ternak babi anda. Aplikasi ini harus digunakan secara online. Setiap proses produksi babi (perkawinan, bunting, menyusui, penyapihan) akan memunculkan notifikasi sebagai pengingat untuk anda (pengguna) untuk mengecek ternaknya, apakah diantara proses tersebut berhasil atau tidak.',
                style: TextStyle(fontSize: 15.0),
              ),
            ]),
      ),
    );
  }

  Widget _desc2() {
    return Column(
      children: [
        SizedBox(
          height: 10.0,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 50.0,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
            '1. Pada tampilan daftar babi, klik (+).',
            style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
            textAlign: TextAlign.justify,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 65.0,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
            '2. Masukkan data babi baru. ayah babi dan ibu babi sifatnya optional(tidak harus terisi).',
            style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
            textAlign: TextAlign.justify,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 40.0,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
            '3. Setelah terisi, klik "tambah"',
            style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }

  Widget _desc3() {
    return Column(
      children: [
        SizedBox(
          height: 10.0,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 60.0,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
            '1. Pada tampilan daftar babi, klik induk babi yang akan dikawinkan.',
            style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
            textAlign: TextAlign.justify,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 60.0,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
            '2. Setelah itu, muncul tampilan detail data babi, klik "kawinkan" jika babi berstatus siap produksi.',
            style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
            textAlign: TextAlign.justify,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 60.0,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
            '3. Isi data perkawinan dengan lengkap. pilih pejantan, klik tanggal mulai pengawinan untuk mengubah tanggal.',
            style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
            textAlign: TextAlign.justify,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 75.0,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
            '4. Klik "Mulai" jika sudah selesai, notifikasi untuk pengecekan bunting akan muncul sesuai tanggal akhir perkawinan.',
            style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
            textAlign: TextAlign.justify,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 85.0,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
            '5. Jika pada saat pengecekan bunting dan hasilnya belum bunting, klik "Kawinkan ulang" pada tampilan detail proses perkawinan induk babi. Proses ini sama dengan proses nomor 3 sampai nomor 4.',
            style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
            textAlign: TextAlign.justify,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 100.0,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
            '6. Jika pada saat pengecekan bunting dan hasilnya belum bunting-bunting juga, pengguna (peternak babi) dapat menyatakan babi ini mandul dalam aplikasi dengan mengklik "Mandul" pada tampilan detail proses perkawinan babi.',
            style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
            textAlign: TextAlign.justify,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 100.0,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
            '7. Jika pada saat pengecekan bunting dan hasilnya bunting, klik "Bunting" pada tampilan proses perkawinan induk babi, pada tampilan dialog bunting, klik "Ya", maka proses perkawinan induk babi berpindah ke bunting. cek di daftar bunting untuk detailnya.',
            style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
            textAlign: TextAlign.justify,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 60.0,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
            '8. Tunggu notifikasi hingga masa bunting atau hari dimana induk babi akan melahirkan.',
            style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
            textAlign: TextAlign.justify,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 100.0,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
            '9. Jika induk babi tersebut sudah melahirkan, pilih daftar bunting, pilih induk babi yang sudah melahirkan, klik "Selesai" pada tampilan detail bunting babi. atau bisa juga klik notifikasi yang masuk sesuai dengan kodenya klik "Selesai".',
            style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
            textAlign: TextAlign.justify,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 85.0,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
            '10. Setelah itu muncul tampilan tambah data babi baru(anak babi). silahkan diisi data anaknya. lihat cara menambahkan datababi pada petunjuk "Bagaimana menambah data babi?".',
            style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
            textAlign: TextAlign.justify,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 65.0,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
            '11. Proses induk babi sekarang berpindah ke menyusui, lihat daftar babi yang menyusui pada menu menyusui. tunggu notifikasi untuk akhir masa menyusui.',
            style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
            textAlign: TextAlign.justify,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 85.0,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
            '12. Jika anak babi mati, masuk ke detail menyusui si induk, pilih kode anak yang mati, lalu muncul tampilan detail anak babi, klik "Mati" seperti pada petunjuk "Bagaimana menghapus data babi yang mati?"."',
            style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
            textAlign: TextAlign.justify,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 85.0,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
            '13. Jika sudah tiba masa penyapihan maka notifikasi akan muncul untuk menyelesaikan proses menyusui, klik notifikasi yang masuk maka akan diarahkan ke tampilan detail menyusui si induk. klik "Selesai".',
            style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
            textAlign: TextAlign.justify,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 85.0,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
            '14. Tunggu sampai akhir penyapihan babi, dan notifikasi akan muncul untuk menyelesaikan proses penyapihan. klik notifikasi yang masuk dan akan diarahkan ke tampilan detail penyapihan si induk. klik "Selesai".',
            style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
            textAlign: TextAlign.justify,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 65.0,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
            '15. Setelah semua proses selesai, status induk kembali ke Siap Produksi.',
            style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }

  Widget _desc4() {
    return Column(
      children: [
        SizedBox(
          height: 10.0,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 65.0,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
            '1. Pada tampilan daftar babi, klik data babi yang mati.',
            style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
            textAlign: TextAlign.justify,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 65.0,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
            '2. Setelah itu muncul detail data babi, klik "Mati".',
            style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
            textAlign: TextAlign.justify,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 65.0,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
            '4. Masukkan keterangan babi yang mati (babi mati karena apa?), keterangan bersifat Optional.',
            style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
            textAlign: TextAlign.justify,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 70.0,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
            '5. Klik "Simpan", datababi tersebut terhapus dan kode yang digunakan babi tadi bisa digunakan kembali untuk data babi baru.',
            style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }

  Widget _desc5() {
    return Column(
      children: [
        SizedBox(
          height: 10.0,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 50.0,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
            '1. Pada tampilan daftar babi, klik data babi yang terjual.',
            style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
            textAlign: TextAlign.justify,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 50.0,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
            '2. Setelah itu muncul detail data babi, klik "Terjual".',
            style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
            textAlign: TextAlign.justify,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 65.0,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
            '3. Klik "Simpan", datababi tersebut terhapus dan kode yang digunakan babi tadi bisa digunakan kembali untuk data babi baru.',
            style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }
}
