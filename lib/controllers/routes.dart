import 'package:flutter/material.dart';

import '../views/pages.dart';

class RouteController {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>?;

    switch (settings.name) {
      case Pages.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());

      case Pages.home:
        return MaterialPageRoute(builder: (_) => const HomePage());

      case Pages.editBill:
        return MaterialPageRoute(
          builder: (_) => EditBillPage(
            bill: args?['bill'],
          ),
        );

      case Pages.previewBill:
        return MaterialPageRoute(
          builder: (_) => PreviewBillPage(
            bill: args?['bill'],
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
