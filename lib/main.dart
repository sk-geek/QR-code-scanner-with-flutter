// ignore_for_file: prefer_const_constructors, unused_import, unused_local_variable, unused_field, no_leading_underscores_for_local_identifiers, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterfire_ui/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
bool isEmpty = false;
String confirmedPassword = '';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorSchemeSeed: Color.fromARGB(170, 0, 4, 248),
      ),
      routes: {
        '/login': (_) => MyHomePage(
              title: "Login",
            ),
        '/home': (_) => HomeAppPage(),
        '/signup': (_) => SignUpPage()
      },
      initialRoute: '/login',
    );
  }
}

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

class PasswordConfirmInput extends StatefulWidget {
  const PasswordConfirmInput({
    super.key,
  });

  @override
  State<PasswordConfirmInput> createState() => _PasswordConfirmInputState();
}

class _PasswordConfirmInputState extends State<PasswordConfirmInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        decoration: InputDecoration(
          labelText: "Confirm Password",
          hintText: "Enter Password Again",
          icon: Icon(Icons.lock_outline),
          errorText: isEmpty ? "This field is required" : null,
        ),
        obscureText: true,
        onChanged: (value) {
          if (value == '') {
            setState(() {
              isEmpty = true;
            });
          } else {
            setState(() {
              isEmpty = false;
            });
            confirmedPassword = value;
          }
        },
      ),
    );
  }
}

class HomeAppPage extends StatelessWidget {
  const HomeAppPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: FilledButton(
            child: Text('Sign out'),
            onPressed: () async {
              _auth.signOut().then((value) => Navigator.popAndPushNamed(context,'/login'));
            }),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            EmailInput(),
            PasswordInput(),
            loginButton(),
            Text("OR"),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              TextButton(
                child: Text("Reset password"),
                onPressed: () => showPasswordResetDialog(),
              ),
              TextButton(
                child: Text("Create Account"),
                onPressed: () {
                  Navigator.popAndPushNamed(context, '/signup');
                },
              )
            ])
          ],
        ),
      ),
    );
  }

  Container loginButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: FilledButton.icon(
        icon: Icon(Icons.login_outlined),
        label: Text("Login"),
        onPressed: loginButtonOnpressed,
      ),
    );
  }

  void loginButtonOnpressed() async {
    if (email == "" || password == "") {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Please fill all boxes"),
              actions: <Widget>[
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      onLongPress: () {
                        try {
                          _auth.signOut();
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Signed out"),
                          ));
                        } catch (e) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    title: Text("Error"),
                                    content: Text(e.toString()),
                                    actions: <Widget>[
                                      SizedBox(
                                          width: double.infinity,
                                          child: FilledButton(
                                            child: Text("OK"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ))
                                    ]);
                              });
                        }
                      }),
                )
              ],
            );
          });
    } else {
      try {
        final credintial = await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) => Navigator.popAndPushNamed(context, "/home"));
      } catch (e) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  icon: Icon(Icons.error),
                  title: Text("Error"),
                  content: Text(e.toString()),
                  actions: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  ]);
            });
      }
    }
  }

  showPasswordResetDialog() {
    bool _validate = false;
    String email = "";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Reset your password'),
              content: Text('Enter your email address to reset your password.'),
              actions: <Widget>[
                Column(children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Enter your email",
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      _validate = false;
                      email = value;
                    },
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: FilledButton(
                      child: Text("Send password reset email"),
                      onPressed: () async {
                        if (email == '') {
                          setState(() {
                            _validate = true;
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Email can't be empty")));
                          });
                        } else {
                          await _auth
                              .sendPasswordResetEmail(email: email)
                              .then((value) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "Password reset email sent to $email")));
                          }).onError((error, stackTrace) => showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Error'),
                                      content: Text(error.toString()),
                                      actions: <Widget>[
                                        FilledButton(
                                          child: Text("OK"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  }));
                          email = '';
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("cancel")),
                  )
                ])
              ]);
        });
  }
}

class PasswordInput extends StatefulWidget {
  const PasswordInput({
    super.key,
  });

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
          decoration: InputDecoration(
            hintText: 'Enter your password',
            labelText: 'Password',
            icon: Icon(Icons.lock_open),
            errorText: isEmpty ? "This field is required" : null,
          ),
          obscureText: true,
          onChanged: (String value) {
            if (value == '') {
              setState(() {
                isEmpty = true;
              });
            } else {
              setState(() {
                isEmpty = false;
              });
            }
            password = value;
          }),
    );
  }
}

class EmailInput extends StatefulWidget {
  const EmailInput({
    super.key,
  });

  @override
  State<EmailInput> createState() => _EmailInputState();
}

class _EmailInputState extends State<EmailInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        decoration: InputDecoration(
          icon: Icon(Icons.email_outlined),
          hintText: "email@provider.domain",
          label: Text('Email'),
          errorText: isEmpty ? "This field is required" : null,
        ),
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) {
          if (value == '') {
            setState(() {
              isEmpty = true;
            });
          } else {
            setState(() {
              isEmpty = false;
            });
          }
          email = value;
        },
      ),
    );
  }
}

final FirebaseAuth _auth = FirebaseAuth.instance;
String email = "";
String password = "";
