// ignore_for_file: prefer_const_constructors, avoid_print, non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_application_12/models/config.dart';
import 'package:flutter_application_12/models/users.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_application_12/screens/home.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  static const routeName = "/login";

  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();
  Users user = Users();
  
  Future<void> login(Users user) async {
    var params = {"email": user.email, "password": user.password};
    var url = Uri.http(Configure.server, "users", params);
    var resp = await http.get(url);
    print(resp.body);
    List<Users> login_result = usersFromJson(resp.body);
    print(login_result.length);
    if (login_result.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("username or password invalid")));
    } else {
      Configure.login = login_result[0];
      Navigator.pushNamed(context, Home.routeName);
    }
    return;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formkey, //// อย่าลืมใส่
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textHearder(),  //ยังไม่ใส่ข้อมูล
              emailInputField(),
              passwordInputField(),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  submitButton(),
                  SizedBox(
                    width: 10.0,
                  ),
                  backButton(),
                  SizedBox(
                    width: 10.0,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget emailInputField() {
    return TextFormField(
      initialValue: "a@test.com",
      decoration: InputDecoration(labelText: "Email:"),
      validator: (value) {
        if (value!.isEmpty) {
          return "This field is required";
        }
        if(!EmailValidator.validate(value)) {
          return "It is not email format";
        }
        return null;
      },
      onSaved: (newValue) => user.email = newValue,
    );
  }
  Widget passwordInputField() {
    return TextFormField(
      initialValue: "1q2w3e4r",
      obscureText: true,
      decoration: 
        InputDecoration(labelText: "Password:"),
      validator: (value) {
        if (value!.isEmpty) {
          return "This field is required";
        }
        return null;
      },
      onSaved: (newValue) => user.password = newValue,
    );
  }
  Widget submitButton() {
    return ElevatedButton(onPressed: () {
      if(_formkey.currentState!.validate()){
        _formkey.currentState!.save();
        print(user.toJson().toString());
        login(user);
      }
    }, child: Text("Login"));
  }
  Widget backButton() {
    return ElevatedButton(
      onPressed: () {}, 
      child: Text("Back"));
  }
  Widget registerLink() {
    return InkWell(
      child: const Text("Sign Up"),
      onTap: () {},
    );
  }
  Widget textHearder() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        'Login',
        style: TextStyle(
          fontSize: 28,
        ),
      ),
    );
  }
}


