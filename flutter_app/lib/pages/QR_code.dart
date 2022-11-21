import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';

class QRcodePage extends StatefulWidget {
  const QRcodePage({super.key});

  @override
  State<QRcodePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<QRcodePage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Expanded(
            flex: 5,
            child: QRView(key: qrKey, onQRViewCreated: _onQrViewCreated)),
        Expanded(
            flex: 1,
            child: Center(
                child: (result != null)
                    ? Text(
                        "Data: ${result!.code}")
                    : const Text("Scan a code")))
      ],
    ));
  }

  void _onQrViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
