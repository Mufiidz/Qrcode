import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:linkwell/linkwell.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qrcode_app/data/database.dart';
import 'package:qrcode_app/entity/qrcode.dart';
import 'package:qrcode_app/ui/result_screen.dart';
import 'package:qrcode_app/utils/app_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool _isGranted = false;
  GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? _controller;
  late AppDatabase db;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<bool> _isSwitched;

  @override
  void initState() {
    super.initState();
    $FloorAppDatabase.databaseBuilder('qrcode.db').build().then((value) async {
      db = value;
    });
    _isSwitched = _prefs.then((value) {
      return (value.getBool("autosave") ?? true);
    });
  }

  @override
  Widget build(BuildContext context) {
    TargetPlatform platform = Theme.of(context).platform;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 400.0;
    _requestPermission(platform);
    return _isGranted
        ? _grantedWidget(height, width, scanArea)
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => AppRoute.clearAllTo(AppRoute.home),
              ),
              title: const Text("Qrcode Scanner"),
            ),
            body: Container(
              height: height,
              width: width,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Please enable camera permission"),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                      onPressed: () => _requestPermission(platform),
                      child: const Text(
                        "Request",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            ),
          );
  }

  Widget _grantedWidget(double height, double width, double scanArea) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => AppRoute.clearAllTo(AppRoute.home),
            ),
          ),
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.red,
                  borderRadius: 6,
                  borderLength: 20,
                  borderWidth: 5,
                  cutOutSize: scanArea,
                ),
              ),
              SizedBox(
                width: width,
                height: height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LinkWell("Autosave Scanned",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                    FutureBuilder<bool>(
                        future: _isSwitched,
                        builder: (context, snapshot) {
                          return Switch(
                              value: snapshot.data ?? true,
                              onChanged: (value) {
                                setState(() {
                                  _autoSaveScan(value);
                                });
                              });
                        })
                  ],
                ),
              )
            ],
          ),
        ),
        onWillPop: _onWillPop);
  }

  Future<void> _autoSaveScan(bool isAutosave) async {
    final SharedPreferences prefs = await _prefs;
    _isSwitched =
        prefs.setBool("autosave", isAutosave).then((value) => isAutosave);
  }

  void _requestPermission(TargetPlatform platform) {
    if (!kIsWeb) {
      if (platform == TargetPlatform.android ||
          platform == TargetPlatform.iOS) {
        _requestMobilePermission();
      } else {
        setState(() {
          _isGranted = true;
        });
      }
    } else {
      setState(() {
        _isGranted = true;
      });
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
    });
    _controller!.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        var code = scanData.code;
        if (code!.isNotEmpty) {
          _controller!.dispose();
          _controller = controller;
          setState(() {
            AppRoute.to(ResultScreen(qrcode: Qrcode(code: code, from: "Scan")));
          });
        }
      });
    });
  }

  void _requestMobilePermission() async {
    Permission.camera.request();
    if (await Permission.camera.request().isGranted) {
      setState(() {
        _isGranted = true;
      });
    }
  }

  Future<void> addQrcode(qrcode) async {
    return db.qrcodeDao.insertQrcode(qrcode);
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _controller!.pauseCamera();
    } else if (Platform.isIOS) {
      _controller!.resumeCamera();
    }
  }

  Future<bool> _onWillPop() async {
    AppRoute.clearAllTo(AppRoute.home);
    return false;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
