import 'package:ai_barcode/ai_barcode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linkwell/linkwell.dart';
import 'package:qrcode_app/data/database.dart';
import 'package:qrcode_app/entity/qrcode.dart';
import 'package:qrcode_app/utils/app_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultScreen extends StatefulWidget {
  final Qrcode qrcode;

  const ResultScreen({Key? key, required this.qrcode}) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final _creatorController = CreatorController();
  late AppDatabase db;
  late bool _isAutosave;

  @override
  void initState() {
    super.initState();
    $FloorAppDatabase.databaseBuilder('qrcode.db').build().then((value) async {
      db = value;
      final _prefs = await SharedPreferences.getInstance();
      _isAutosave = _prefs.getBool("autosave") ?? true;
      setState(() {});
      if (_isAutosave) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Saved")));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    String code = widget.qrcode.code;
    if (_isAutosave) addQrcode(widget.qrcode);
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
                onPressed: () => AppRoute.clearTopTo(AppRoute.scan),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.lightBlue,
                )),
            elevation: 0,
          ),
          body: Container(
            height: height,
            width: width,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Result Scan",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: PlatformAiBarcodeCreatorWidget(
                        creatorController: _creatorController,
                        initialValue: code),
                  ),
                  LinkWell(code),
                  TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                      onPressed: () =>
                          Clipboard.setData(ClipboardData(text: code)).then(
                              (value) => ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                      const SnackBar(content: Text("Copied")))),
                      child: const Text(
                        "Salin",
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
            ),
          ),
        ),
        onWillPop: _onWillPop);
  }

  Future<void> addQrcode(Qrcode qrcode) async {
    return db.qrcodeDao.insertQrcode(qrcode);
  }

  Future<bool> _onWillPop() async {
    AppRoute.clearTopTo(AppRoute.scan);
    return false;
  }
}
