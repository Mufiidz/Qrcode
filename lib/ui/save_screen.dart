import 'package:ai_barcode/ai_barcode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrcode_app/data/database.dart';
import 'package:qrcode_app/entity/qrcode.dart';
import 'package:qrcode_app/utils/app_route.dart';

class SaveScreen extends StatefulWidget {
  final Qrcode qrcode;

  const SaveScreen({Key? key, required this.qrcode}) : super(key: key);

  @override
  _SaveScreenState createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  final _creatorController = CreatorController();
  late AppDatabase db;

  @override
  void initState() {
    super.initState();
    $FloorAppDatabase.databaseBuilder('qrcode.db').build().then((value) async {
      db = value;
      await addQrcode(db);
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Saved")));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    String code = widget.qrcode.code;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () => AppRoute.back(),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: PlatformAiBarcodeCreatorWidget(
                  creatorController: _creatorController, initialValue: code),
            ),
            TextButton(
                onPressed: () => ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text("Coming Soon"))),
                child: const Text("Download"))
          ],
        ),
      ),
    );
  }

  Future<void> addQrcode(AppDatabase db) async {
    return db.qrcodeDao.insertQrcode(widget.qrcode);
  }
}
