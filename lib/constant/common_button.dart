import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'color.dart';

class CommonButton extends StatelessWidget {
  CommonButton({Key? key, required this.onPressed, required this.text})
      : super(key: key);

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      height: 62.h,
      minWidth: Get.width,
      child: Text(
        text,
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20.sp),
      ),
      color: PickColor.buttonColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
    );
  }
}
