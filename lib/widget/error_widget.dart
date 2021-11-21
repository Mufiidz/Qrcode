import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String errorMsg;

  const ErrorScreen({Key? key, required this.errorMsg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: height,
      color: Colors.white,
      child: Center(
        child: Text(
          'Error: $errorMsg',
          style: const TextStyle(color: Colors.red, fontSize: 16),
        ),
      ),
    );
  }
}
