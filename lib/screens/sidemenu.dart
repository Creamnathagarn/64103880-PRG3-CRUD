// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_12/screens/home.dart';
import 'package:flutter_application_12/screens/login.dart';
import '../models/config.dart';
import '../models/users.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    String accountName = "...";
    String accountEmail = "...";
    String accountUrl = "https://scontent-sin6-4.xx.fbcdn.net/v/t1.6435-9/68409455_2540080682680583_5364437899578179584_n.jpg?_nc_cat=101&ccb=1-7&_nc_sid=8bfeb9&_nc_eui2=AeE7SgVJuPoDuI9kB3-RjndhQSDaXgUvOYFBINpeBS85gS6r3b5xSHYZ2Dbd_BUGhy_VpLqZSTW_VRDMggEnDo90&_nc_ohc=IabMCZ-j8kIAX8VAFDb&_nc_ht=scontent-sin6-4.xx&oh=00_AfAMyXEcRLgyf-AvCZ8jF2myKsIQiSvrls9GyunvaSmZrA&oe=65168C60"; //ไปหารูปมาใส่
    
    Users user = Configure.login;
    //print(user.tiJson().toString());
    if (user.id != null) {
      accountName = user.fullname!;
      accountEmail = user.email!;
    }
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(accountName), 
            accountEmail: Text(accountEmail),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(accountUrl),
              backgroundColor: Colors.white,
            ) ,
            ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              Navigator.pushNamed(context, Home.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.login),
            title: Text("Login"),
            onTap: () {
              Navigator.pushNamed(context, Login.routeName);
            },
          )
        ],
      ),
    );
  }
}