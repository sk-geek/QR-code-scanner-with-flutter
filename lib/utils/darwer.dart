// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:my_app/main.dart';

class myDrawer extends StatelessWidget {
  const myDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: [ListTile(title: Text("Helooo"))],
    ));
  }
}
