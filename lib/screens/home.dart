// ignore_for_file: sort_child_properties_last, prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_application_12/models/config.dart';
import 'package:flutter_application_12/models/users.dart';
import 'package:flutter_application_12/screens/sidemenu.dart';
import 'package:flutter_application_12/screens/uidesign.dart';
import 'package:flutter_application_12/screens/userinfo.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  static const routeName = "/";
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget mainBody = Container();
  //หน้า220
  List<Users> _userList = [];
  Future<void> getUsers() async {
    var url = Uri.http(Configure.server, "users");
    var resp = await http.get(url);
    setState(() {
      _userList = usersFromJson(resp.body);
      mainBody = showUsers();
    });
    return;
  }

  Future<void> removeUsers(user) async {
    var url = Uri.http(Configure.server, "users/${user.id}");
    var resp = await http.delete(url);
    print(resp.body);
    return;
  }

  @override
  void initState() {
    super.initState();
    Users user = Configure.login;
    if (user.id != null) {
      getUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
        ),
        drawer: const SideMenu(),
        body: mainBody,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            String result = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => UserFormState()));
            if (result == "refresh") {
              getUsers();
            }
          },
          child: const Icon(Icons.person_add_alt_1),
        ));
  }

  Widget showUsers() {
    return ListView.builder(
      itemCount: _userList.length,
      itemBuilder: (context, index) {
        Users user = _userList[index];
        return Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          child: Card(
            child: ListTile(
              title: Text("${user.fullname}"),
              subtitle: Text("${user.email}"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserInfo(),
                        settings: RouteSettings(arguments: user)));
              }, //to show info
              trailing: IconButton(
                onPressed: () async {
                  String result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserFormState(),
                          settings: RouteSettings(arguments: user)));
                  if (result == "refresh") {
                    getUsers();
                  }
                }, //to edit
                icon: Icon(Icons.edit),
              ),
            ),
          ),
          onDismissed: (direction) {
            removeUsers(user);
          }, //to delete
          background: Container(
            color: Colors.red,
            margin: EdgeInsets.symmetric(horizontal: 15),
            alignment: Alignment.centerRight,
            child: Icon(Icons.delete, color: Colors.white),
          ),
        );
      },
    );
  }
}
