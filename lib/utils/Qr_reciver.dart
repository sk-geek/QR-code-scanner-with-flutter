import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:share_plus/share_plus.dart';

void onQrGotCaptured(
    Barcode? scanData, BuildContext context, QRViewController? controller) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("code scanned!"),
        content: SelectableText(
          "The contents of the ${describeEnum(scanData!.format)} were: \n${scanData.code}",
        ),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                    onPressed: () async {
                      await Clipboard.setData(
                          ClipboardData(text: scanData.toString()));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Text copied!"),
                      ));
                      await controller
                          ?.resumeCamera()
                          .then((value) => Navigator.of(context).pop());
                    },
                    child: Text("Copy contents")),
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () async {
                    Share.share("${scanData.toString()}");
                    await controller
                        ?.resumeCamera()
                        .then((value) => Navigator.of(context).pop());
                  },
                  label: Text("Share"),
                  icon: Icon(Icons.share_outlined),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () async {
                      await controller
                          ?.resumeCamera()
                          .then((value) => Navigator.pop(context));
                    },
                    child: Text("close")),
              )
            ],
          )
        ],
      );
    },
  );
}
