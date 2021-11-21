import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrcode_app/ui/main_section.dart';
import 'package:qrcode_app/ui/splash_screen.dart';
import 'package:qrcode_app/utils/app_route.dart';
import 'package:qrcode_app/utils/custom_scrollbar_behavior.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Qrcode App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: AppRoute.navigatorKey,
      home: const SplashScreen(),
      scrollBehavior: CustomScrollBehavior(),
      routes: AppRoute.routes,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              const CupertinoSliverNavigationBar(
                largeTitle: Text("My QrCode"),
              ),
            ];
          },
          body: const MainSection()),
    );
  }
}
