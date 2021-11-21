import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrcode_app/data/qrcode_dao.dart';
import 'package:qrcode_app/entity/qrcode.dart';
import 'package:qrcode_app/ui/save_screen.dart';
import 'package:qrcode_app/utils/app_route.dart';

class ItemCode extends StatefulWidget {
  final ConfirmDismissCallback? confirmDismiss;
  final QrcodeDao dao;
  final Qrcode qrcode;
  final int? index;

  const ItemCode(
      {Key? key,
      required this.dao,
      required this.qrcode,
      this.confirmDismiss,
      this.index})
      : super(key: key);

  @override
  _ItemCodeState createState() => _ItemCodeState();
}

class _ItemCodeState extends State<ItemCode> {
  @override
  Widget build(BuildContext context) {
    var qrcode = widget.qrcode;
    var index = (widget.index ?? 0) + 1;
    var title = qrcode.from == null || qrcode.from!.isEmpty
        ? "$index. Saved of ${qrcode.id}"
        : "$index. ${qrcode.from} (${qrcode.id})";
    return SizedBox(
      height: 100,
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.startToEnd,
        confirmDismiss: widget.confirmDismiss,
        child: InkWell(
          onTap: () => AppRoute.to(
              SaveScreen(qrcode: Qrcode(id: qrcode.id, code: qrcode.code))),
          child: Card(
            elevation: 6,
            child: ListTile(
              contentPadding: const EdgeInsets.all(8),
              title: Text(title),
              subtitle: Text(qrcode.code),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> deleteCode(int id) async {
    return await widget.dao.deleteQrcodeById(id);
  }
}
