import 'package:flutter/material.dart';
import 'package:qrcode_app/main.dart';
import 'package:qrcode_app/ui/generate_screen.dart';
import 'package:qrcode_app/ui/scan_screen.dart';

class AppRoute {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static NavigatorState get navigator => navigatorKey.currentState!;

  static const String home = '/home';
  static const String generate = '/generate';
  static const String scan = '/scan';

  static final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
    home: (BuildContext context) {
      return const MyHomePage();
    },
    generate: (BuildContext context) {
      return const GenerateScreen();
    },
    scan: (BuildContext context) {
      return const ScanScreen();
    },
  };

  static Future<T?> to<T extends Object?>(
    Widget route,
  ) {
    return navigator
        .push<T>(MaterialPageRoute(builder: (context) => route));
  }

  static Future<T?> withNameTo<T extends Object?>(
    String route, {
    Object? arguments,
  }) {
    return navigator.pushNamed<T>(
      route,
      arguments: arguments,
    );
  }

  static Future<T?> clearTopTo<T extends Object?, TO extends Object?>(
    String route, {
    TO? result,
    Object? arguments,
  }) {
    return navigator.pushReplacementNamed<T, TO>(
      route,
      result: result,
      arguments: arguments,
    );
  }

  static Future<T?> clearAllTo<T extends Object?>(
      String route, {
        bool removeAll = true,
        RoutePredicate? predicate,
        Object? arguments,
      }) {
    predicate ??= (Route<dynamic> otherRoute) {
      return !removeAll;
    };
    return navigator.pushNamedAndRemoveUntil(
      route,
      predicate,
      arguments: arguments,
    );
  }

  static void back<T extends Object?>([
    T? result,
  ]) {
    return navigator.pop(result);
  }
}
