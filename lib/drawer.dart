import 'package:flutter/material.dart';
import 'package:appstarbab/login.dart';
import 'package:appstarbab/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerPage extends StatelessWidget {
  DrawerPage(this.namaUser);
  final String namaUser;

  @override
  Widget build(BuildContext context) {
    Future logout() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setBool("isLogin", false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return LoginPage();
        }),
      );
    }

    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        _drawHeader(namaUser),
        // Divider(
        //   thickness: 2.0,
        //   height: 5.0,
        //   indent: 15.0,
        //   endIndent: 15.0,
        //   color: Colors.black,
        // ),
        Padding(
          padding: EdgeInsets.only(top: 5.0),
        ),
        _drawItem(
            icon: ImageIcon(
              AssetImage("assets/images/pigs.png"),
              size: 20,
              color: Colors.blue[900],
            ),
            text: 'Daftar Babi',
            onTap: () =>
                Navigator.pushReplacementNamed(context, Routes.beranda)),
        Padding(
          padding: EdgeInsets.only(top: 5.0),
        ),

        _drawItem(
            icon: ImageIcon(
              AssetImage("assets/images/kawin.png"),
              size: 20,
              color: Colors.blue[900],
            ),
            text: 'Perkawinan',
            onTap: () =>
                Navigator.pushReplacementNamed(context, Routes.estrus)),
        Padding(
          padding: EdgeInsets.only(top: 5.0),
        ),
        _drawItem(
            icon: ImageIcon(
              AssetImage("assets/images/pig.png"),
              size: 20,
              color: Colors.blue[900],
            ),
            text: 'Bunting',
            onTap: () =>
                Navigator.pushReplacementNamed(context, Routes.bunting)),
        Padding(
          padding: EdgeInsets.only(top: 5.0),
        ),
        _drawItem(
            icon: ImageIcon(
              AssetImage("assets/images/pigy.png"),
              size: 20,
              color: Colors.blue[900],
            ),
            text: 'Menyusui',
            onTap: () =>
                Navigator.pushReplacementNamed(context, Routes.menyusui)),
        Padding(
          padding: EdgeInsets.only(top: 5.0),
        ),
        _drawItem(
            icon: ImageIcon(
              AssetImage("assets/images/sapih.png"),
              size: 20,
              color: Colors.blue[900],
            ),
            text: 'Penyapihan',
            onTap: () =>
                Navigator.pushReplacementNamed(context, Routes.penyapihan)),
        Padding(
          padding: EdgeInsets.only(top: 5.0),
        ),
        Divider(
          thickness: 1.0,
          height: 5.0,
          indent: 5.0,
          endIndent: 5.0,
          color: Colors.grey,
        ),
        Padding(
          padding: EdgeInsets.only(top: 5.0),
        ),
        _drawItem(
          icon: ImageIcon(
            AssetImage("assets/images/help.png"),
            size: 20,
            color: Color(0xFF3A5A98),
          ),
          text: 'Petunjuk',
          onTap: () => Navigator.pushReplacementNamed(context, Routes.petunjuk),
        ),
        Padding(
          padding: EdgeInsets.only(top: 5.0),
        ),
        _drawItem(
            icon: ImageIcon(
              AssetImage("assets/images/logout.png"),
              size: 20,
              color: Colors.redAccent,
            ),
            text: 'Keluar',
            onTap: () {
              logout();
            }),
      ],
    ));
  }
}

Widget _drawHeader(String namaUser) {
  return DrawerHeader(
    margin: EdgeInsets.zero,
    padding: EdgeInsets.zero,
    decoration: BoxDecoration(
      gradient: LinearGradient(
          colors: [Color(0xff0096ff), Color(0xff6610f2)],
          begin: FractionalOffset.topLeft,
          end: FractionalOffset.bottomRight),
      // image: DecorationImage(
      //   fit: BoxFit.fitHeight,
      //   image: AssetImage('assets/images/appIcon.png'),
      // ),
    ),
    child: Stack(
      children: <Widget>[
        Positioned(
          bottom: 15.0,
          left: 16.0,
          child: Text(
            '$namaUser',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _drawItem({ImageIcon icon, String text, GestureTapCallback onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        icon,
        Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: Text(text),
        ),
      ],
    ),
    onTap: onTap,
  );
}

// Widget _userItem({String text}) {
//   return ListTile(
//     selectedTileColor: Colors.blueAccent,
//     title: Row(
//       children: <Widget>[
//         Padding(
//           padding: EdgeInsets.only(left: 10.0, bottom: 0.0),
//           child: Text(
//             text,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 20.0,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
