import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tamil_admin_panel/signIn_screen.dart';
import 'package:tamil_admin_panel/signup_screen.dart';
import 'package:tamil_admin_panel/views/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      Get.to(
        () =>
            GetStorage().read('emails') == null ? SignUpScreen() : HomeScreen(),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(
          'assets/images/svg/splash.svg',
          height: 238.h,
          width: 238.w,
        ),
      ),
    );
  }
}
