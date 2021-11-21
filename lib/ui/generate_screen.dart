import 'package:ai_barcode/ai_barcode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrcode_app/entity/qrcode.dart';
import 'package:qrcode_app/ui/save_screen.dart';
import 'package:qrcode_app/utils/app_route.dart';

class GenerateScreen extends StatefulWidget {
  const GenerateScreen({Key? key}) : super(key: key);

  @override
  _GenerateScreenState createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {
  final _txtController = TextEditingController();
  final _creatorController = CreatorController();
  String? _txt = "";

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: height,
      color: Colors.white,
      child: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            automaticallyImplyLeading: false,
            leading: CupertinoNavigationBarBackButton(
              onPressed: () => AppRoute.back(),
            ),
            middle: const Text("Generate QrCode"),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (_txt!.isNotEmpty)
                  Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 150,
                            height: 150,
                            child: PlatformAiBarcodeCreatorWidget(
                              initialValue: _txt!,
                              creatorController: _creatorController,
                            ),
                          ),
                          CupertinoButton(
                              child: const Text("Save"),
                              onPressed: () {
                                _txtController.clear();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SaveScreen(
                                            qrcode: Qrcode(
                                                code: _txt ?? "-x-",
                                                from: "Generate"))));
                              })
                        ],
                      )),
                Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CupertinoTextField(
                          textInputAction: TextInputAction.done,
                          onSubmitted: (String value) {
                            setState(() {
                              _txt = value;
                            });
                          },
                          suffix: CupertinoButton(
                            child: const Icon(CupertinoIcons.clear),
                            onPressed: () => _txtController.clear(),
                          ),
                          controller: _txtController,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CupertinoButton.filled(
                            child: const Text("Create"),
                            onPressed: () {
                              setState(() {
                                _txt = _txtController.text;
                              });
                            }),
                      ],
                    ))
              ],
            ),
          )),
    );
  }

  @override
  void dispose() {
    _txtController.dispose();
    super.dispose();
  }
}
