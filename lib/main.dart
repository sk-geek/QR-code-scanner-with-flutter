// ignore_for_file: prefer_const_constructors, unused_import, unused_local_variable, unused_field, no_leading_underscores_for_local_identifiers, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_app/pages/Home_App_Page.dart';
import 'package:my_app/pages/sign_up.dart';
import 'package:my_app/utils/widgets.dart';
import 'firebase_options.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      debugShowCheckedModeBanner: false,
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void initState() {
    initttt();
    super.initState();
    
  }

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
            ]),
            Expanded(
              child: Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Having issues?"),
                TextButton(
                    child: Text("Contact us"),
                    onPressed: () {
                      // TODO add contact us page
                    })
              ],
            )
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
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final UidFA = _auth.currentUser?.uid;

        final credintial = await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then(
          (value) {
            Map creds = {
              "email": email,
              "password": password,
              "uid": UidFA,
            };
            prefs.setString("email", creds["email"]);
            prefs.setString("password", creds["password"]);
            prefs.setString("uid", creds["uid"]);
            prefs.setString("isLogged", creds["isLogged"]);
            Navigator.popAndPushNamed(context, "/home");
          },
        );
      } catch (e) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  icon: Icon(Icons.error_outline),
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
  void initttt() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("email")) {
      email = await prefs.getString("email")!;
      password = await prefs.getString("password")!;
      _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => Navigator.popAndPushNamed(context, "/home"));
    }
}
}


final FirebaseAuth _auth = FirebaseAuth.instance;
String email = "";
String password = "";