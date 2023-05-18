import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../utils/widgets.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
              EmailInput(),
              PasswordInput(),
              PasswordConfirmInput(),
              signUpButton(context),
              Text('OR'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: () => Navigator.popAndPushNamed(context, "/login"), child: Text("Login to an existing account"))
                ],
              )
            ])));
  }

  Container signUpButton(BuildContext context) {
    return Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              child: FilledButton.icon(
                  icon: Icon(Icons.add),
                  label: Text("Create account"),
                  onPressed: () async{
                    if (email == '' ||
                        password == '' ||
                        confirmedPassword == '') {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please fill all fields")));
                    } else if (password != confirmedPassword) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Passwords do not match")));
                    } else {
                      await _auth.createUserWithEmailAndPassword(
                        email: email, 
                        password: password)
                        .then(
                          (value) async{
                            ScaffoldMessenger
                          .of(context).showSnackBar(
                            SnackBar(
                              content: Text("Account created")
                                )
                              );
                              await _auth.signInWithEmailAndPassword(email: email, password: password).then((value) => Navigator.popAndPushNamed(context, '/home')).onError((error, stackTrace) => showSignupError(error));
                          }
                            ).onError((error, stackTrace) => showSignupError(error));
                    }
                  }),
            );
  }
  
  showSignupError(Object? error) {
    showDialog(context: context, 
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Error'),
        content: Text(error.toString()),
        actions: [
          FilledButton(onPressed: () => Navigator.pop(context), child: Text("OK"))
        ],
      );
    });
  }
}
final FirebaseAuth _auth = FirebaseAuth.instance;
