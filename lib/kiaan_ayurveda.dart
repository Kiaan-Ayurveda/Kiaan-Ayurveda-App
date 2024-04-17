import 'package:flutter/material.dart';

import 'constants/colors.dart';
import 'controllers/routes.dart';
import 'views/pages.dart';

class KiaanAyurveda extends StatelessWidget {
  const KiaanAyurveda({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kiaan Ayurveda',
      initialRoute: Pages.splash,
      onGenerateRoute: RouteController.generateRoute,
      debugShowCheckedModeBanner: false,
      theme: ColorConstants.themeData,
    );
  }
}
