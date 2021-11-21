import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrcode_app/utils/app_route.dart';
import 'package:qrcode_app/widget/item_home.dart';
import 'package:qrcode_app/widget/saved_listview.dart';

class MainSection extends StatefulWidget {
  const MainSection({Key? key}) : super(key: key);

  @override
  _MainSectionState createState() => _MainSectionState();
}

class _MainSectionState extends State<MainSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 130,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ItemHome(
                      title: "Create",
                      color: Colors.red,
                      onPressed: () => AppRoute.withNameTo(AppRoute.generate)),
                  const SizedBox(
                    width: 10,
                  ),
                  ItemHome(
                    title: "Scan",
                    color: Colors.lightBlue,
                    onPressed: () => AppRoute.clearTopTo(AppRoute.scan),
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Saved Qrcode",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
            const Expanded(child: SavedListView())
          ],
        ));
  }
}
