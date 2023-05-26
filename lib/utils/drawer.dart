// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class QeDrawer extends StatefulWidget {
  QeDrawer({super.key});

  @override
  State<QeDrawer> createState() => _QeDrawerState();
}

class _QeDrawerState extends State<QeDrawer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _selectedDestination = 0;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        // padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome, ${_auth.currentUser?.displayName == null ? _auth.currentUser?.email : _auth.currentUser?.displayName}",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                // Expanded(child: Container()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "${_auth.currentUser?.displayName == null ? "No name is set for your profile,\nplease set a name in the profile menu" : _auth.currentUser?.email}",
                    ),
                  ],
                )
              ],
            ),
          ),
          ListTile(
            title: Text("Home"),
            selected: _selectedDestination == 0,
            leading: Icon(Icons.home_outlined),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
            selectedTileColor: Theme.of(context).colorScheme.secondaryContainer,
            onTap: () => selectTab(0),
          ),
          ListTile(
            title: Text("Create"),
            selected: _selectedDestination == 1,
            selectedTileColor: Theme.of(context).colorScheme.secondaryContainer,
            leading: Icon(Icons.create_outlined),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
            onTap: () => selectTab(1),
          ),
          ListTile(
            title: Text("About app"),
            selected: _selectedDestination == 5,
            selectedTileColor: Theme.of(context).colorScheme.secondaryContainer,
            leading: Icon(Icons.info_outline),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationIcon: Icon(Icons.qr_code),
                applicationName: "Qr scanner",
                applicationVersion: "1.0",
                children: [
                  Text(
                      "This app was made by Ahmed Abbas using flutter\nIt is licensed under MIT license"),
                  Row(
                    children: [
                      Text("Source code:"),
                      TextButton(
                          onPressed: () => launchUrlString(
                              "https://github.com/sk-geek/QR-code-scanner-with-flutter",
                              mode: LaunchMode.externalApplication),
                          child: Text(
                            "GitHub link",
                            style: TextStyle(
                              decoration: TextDecoration.underline
                            ),
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Telegram:"),
                      TextButton(
                          onPressed: () => launchUrlString(
                              "https://t.me/myflutterjourney",
                              mode: LaunchMode.externalApplication),
                          child: Text(
                            "Telegram link",
                            style: TextStyle(
                              decoration: TextDecoration.underline
                            ),
                          )),
                    ],
                  )
                ],
              );
            },
          ),
          Expanded(
            child: Container(),
            flex: 1,
          ),
          ListTile(
            title: Text("Profile"),
            trailing: Icon(Icons.arrow_forward_outlined),
            selected: _selectedDestination == 3,
            selectedTileColor: Theme.of(context).colorScheme.secondaryContainer,
            leading: Icon(Icons.person_outlined),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute<ProfileScreen>(
                      builder: (context) => const ProfileScreen()));
            },
          ),
        ],
      ),
    );
  }

  void selectTab(int index) {
    setState(() {
      _selectedDestination = index;
    });
  }

  void showSignOutConfirm() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Log out'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            SizedBox(
              child: FilledButton(
                  onPressed: () => signOutAction(),
                  child: Text("Yes, log out from account")),
              width: double.infinity,
            ),
            Container(
              padding: EdgeInsets.only(top: 5),
              child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("No, cancel")),
              width: double.infinity,
            )
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      },
    );
  }

  void signOutAction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await _auth
        .signOut()
        .then((value) => Navigator.popAndPushNamed(context, "/login"));
  }
}
