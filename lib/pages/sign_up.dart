import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/utils/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../utils/widgets.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String email = "";
  String password = "";
  TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign Up'),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.person_outline),
                    labelText: "Name",
                    hintText: "Enter your name",
                  ),
                ),
              ),
              EmailInput(),
              PasswordInput(),
              PasswordConfirmInput(),
              signUpButton(context),
              Text('OR'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () =>
                          Navigator.popAndPushNamed(context, "/login"),
                      child: Text("Login to an existing account"))
                ],
              )
            ])),
            drawer: QeDrawer(),
            );
  }

  Container signUpButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: FilledButton.icon(
          icon: Icon(Icons.add),
          label: Text("Create account"),
          onPressed: () async {
            if (email == '' ||
                password == '' ||
                confirmedPassword == '' ||
                nameController.text == '') {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please fill all fields")));
            } else if (password != confirmedPassword) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Passwords do not match")));
            } else {
              await _auth
                  .createUserWithEmailAndPassword(
                      email: email, password: password)
                  .then((value) async {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Account created")));
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString("email", email);
                await prefs.setString("password", password);
                await prefs.setString("uid", _auth.currentUser!.uid).then(
                  (value) async {
                    await _auth
                        .signInWithEmailAndPassword(
                            email: email, password: password)
                        .then((value) =>
                            Navigator.popAndPushNamed(context, '/home'))
                        .onError((error, stackTrace) => showSignupError(error));
                  },
                );
              }).onError((error, stackTrace) => showSignupError(error));
            }
          }),
    );
  }

  showSignupError(Object? error) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(error.toString()),
            actions: [
              FilledButton(
                  onPressed: () => Navigator.pop(context), child: Text("OK"))
            ],
          );
        });
  }
}

final FirebaseAuth _auth = FirebaseAuth.instance;
