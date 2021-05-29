library qr_scanner;

import 'package:flutter/material.dart';
import 'package:qr_scanner/screens/qr_scanner_screen.dart';

Future<String?> showQrScanner(BuildContext context) => Navigator.push<String>(
    context, MaterialPageRoute(builder: (context) => QrScannerScreen()));
