import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/colors.dart';
import '../pages.dart';

class SplashPage extends StatefulWidget {
  static const String route = '/';

  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, Pages.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double length = width > height ? height * 0.5 : width;

    return Scaffold(
      backgroundColor: ColorConstants.bg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'assets/kiaan.svg',
              height: length * 0.75,
              width: length * 0.75,
            ),
            const Text(
              'KIAAN',
              textScaler: TextScaler.linear(5),
              style: TextStyle(
                letterSpacing: 3,
                wordSpacing: 1.2,
                fontWeight: FontWeight.bold,
                color: Color(0xFF231f20),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 14,
                  height: 3,
                  color: const Color(0xFF231f20),
                ),
                const SizedBox(width: 5),
                const Text(
                  'AYURVEDA',
                  textScaler: TextScaler.linear(2),
                  style: TextStyle(
                    letterSpacing: 3,
                    wordSpacing: 1.2,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF231f20),
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  width: 14,
                  height: 3,
                  color: const Color(0xFF231f20),
                ),
              ],
            ),
            const SizedBox(height: 60),
            const Text(
              'BILLING APP',
              style: TextStyle(
                fontSize: 20,
                color: ColorConstants.grey,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
