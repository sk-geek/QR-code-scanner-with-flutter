import 'package:flutter/material.dart';

class QeDrawer extends StatelessWidget {
  const QeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Placeholder()),
          
        ],
      ),
    );
  }
}
