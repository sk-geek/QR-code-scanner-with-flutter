// import 'package:firebase_auth/firebase_auth.dart';

// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_app/utils/drawer.dart';
import 'dart:io';

import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../utils/Qr_reciver.dart';

class HomeAppPage extends StatefulWidget {
  const HomeAppPage({super.key});
  

  @override
  State<HomeAppPage> createState() => _HomeAppPageState();
}

class _HomeAppPageState extends State<HomeAppPage> {
  bool isFront = true;
  bool isFlash = false;
  void initstate() {
    super.initState();
  }

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ?final FirebaseAuth _auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            onPressed: !isFront
                ? null
                : () async {
                    await controller?.toggleFlash();
                    setState(() {
                      isFlash = !isFlash;
                    });
                  },
            icon: Icon(
                isFlash ? Icons.flash_on_outlined : Icons.flash_off_outlined),
          ),
          IconButton(
              onPressed: () async {
                await controller?.flipCamera();
                setState(() {
                  isFront = !isFront;
                });
              },
              icon: Icon(Icons.flip_camera_ios_outlined)),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Center(child: Image.asset("assets/frame.png")),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: QeDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("QR generator is coming soon...")));
        },
        label: Text("Create"),
        icon: Icon(Icons.add_outlined),
      ),
    );
  }

  void flipQrCam() async {
    await controller?.flipCamera();
    setState(() {
      isFront = !isFront;
    });
    return null;
  }

  void _onQRViewCreated(QRViewController? controller) {
    this.controller = controller;
    controller?.scannedDataStream.listen((scanData) {
      setState(() async {
        result = scanData;
        await controller
            .pauseCamera()
            .then((value) => onQrGotCaptured(result, context, controller));
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
