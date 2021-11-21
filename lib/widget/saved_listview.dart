import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrcode_app/data/database.dart';
import 'package:qrcode_app/entity/qrcode.dart';
import 'package:qrcode_app/widget/error_widget.dart';
import 'package:qrcode_app/widget/item_code.dart';
import 'package:qrcode_app/widget/loading_widget.dart';

class SavedListView extends StatefulWidget {
  const SavedListView({Key? key}) : super(key: key);

  @override
  _SavedListViewState createState() => _SavedListViewState();
}

class _SavedListViewState extends State<SavedListView> {
  late AppDatabase db;

  @override
  void initState() {
    super.initState();
    $FloorAppDatabase.databaseBuilder('qrcode.db').build().then((value) async {
      db = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: getAllSavedQrcode(),
      builder: (BuildContext context, AsyncSnapshot<List<Qrcode>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else {
          if (snapshot.hasError) {
            return ErrorScreen(
              errorMsg: '${snapshot.error}',
            );
          } else {
            return RefreshIndicator(
                child: Container(
                  width: width,
                  height: height,
                  color: Colors.white,
                  child: (snapshot.data!.isEmpty)
                      ? Center(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                getAllSavedQrcode();
                              });
                            },
                            child: const Text("Empty Data"),
                          ),
                        )
                      : ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            var qrcode = snapshot.data![index];
                            return ItemCode(
                              qrcode: Qrcode(
                                  id: qrcode.id,
                                  code: qrcode.code,
                                  from: qrcode.from),
                              dao: db.qrcodeDao,
                              index: index,
                              confirmDismiss: (direction) async {
                                deleteCode(qrcode.id!);
                                setState(() {
                                  getAllSavedQrcode();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Berhasil dihapus")));
                                });
                              },
                            );
                          }),
                ),
                onRefresh: () => Future.delayed(const Duration(seconds: 2), () {
                      setState(() {
                        getAllSavedQrcode();
                      });
                    }));
          }
        }
      },
    );
  }

  Future<List<Qrcode>> getAllSavedQrcode() async {
    return await db.qrcodeDao.getAllQrcode();
  }

  Future<void> deleteCode(int id) async {
    return await db.qrcodeDao.deleteQrcodeById(id);
  }
}
