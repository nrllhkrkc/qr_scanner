import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScannerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<_QrScannerBodyState>();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.flash_on_outlined),
              onPressed: () {
                key.currentState?._toggleFlash();
              }),
          IconButton(
              icon: Icon(Icons.flip_camera_ios),
              onPressed: () {
                key.currentState?._flipCamera();
              })
        ],
      ),
      body: QrScannerBody(key: key),
    );
  }
}

class QrScannerBody extends StatefulWidget {
  QrScannerBody({Key? key}) : super(key: key);

  @override
  _QrScannerBodyState createState() => _QrScannerBodyState();
}

class _QrScannerBodyState extends State<QrScannerBody> {
  late QRViewController _controller;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _controller.pauseCamera();
    } else if (Platform.isIOS) {
      _controller.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;

    return QRView(
      key: _qrKey,
      cameraFacing: CameraFacing.front,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  _onQRViewCreated(QRViewController controller) {
    this._controller = controller;
    _controller.flipCamera();
    controller.scannedDataStream.listen((scanData) {
      if (result == null) {
        result = scanData;
        Navigator.pop(context, scanData.code);
      }
    });
  }

  _toggleFlash() {
    _controller.toggleFlash();
  }

  _flipCamera() {
    _controller.flipCamera();
  }
}
