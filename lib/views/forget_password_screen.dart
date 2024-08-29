import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tamil_admin_panel/signIn_screen.dart';

import '../constant/color.dart';
import '../constant/common_button.dart';
import '../signup_screen.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _key = GlobalKey<FormState>();
  final emailController = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _key,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 180.h),
                  SvgPicture.asset(
                    'assets/images/svg/splash.svg',
                    height: 150.h,
                    width: 150.w,
                  ),
                  SizedBox(height: 40.h),
                  TextFormField(
                    onTap: () {},
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      RegExp regex1 = RegExp(
                          r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                      if (value!.trim().isEmpty) {
                        return 'This field is required';
                      } else if (!regex1.hasMatch(value)) {
                        return 'please enter valid Email';
                      }
                      return null;
                    },
                    obscureText: false,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        hintText: 'Email',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.r),
                          borderSide: BorderSide(color: PickColor.buttonColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.r),
                          borderSide: BorderSide(color: PickColor.buttonColor),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.r),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.r),
                          borderSide: BorderSide(color: Colors.red),
                        )),
                  ),
                  SizedBox(height: 80.h),
                  loading == false
                      ? CommonButton(
                          onPressed: () async {
                            if (_key.currentState!.validate()) {
                              try {
                                setState(() {
                                  loading = true;
                                });
                                await FirebaseAuth.instance
                                    .sendPasswordResetEmail(
                                        email: emailController.text);
                                Get.snackbar(
                                  'Password Reset Email has been sent !',
                                  'SuccessFul',
                                  duration: Duration(seconds: 2),
                                  colorText: Colors.white,
                                  backgroundColor: PickColor.buttonColor,
                                );
                                Get.offAll(() => SignInScreen());
                              } on FirebaseAuthException catch (e) {
                                setState(() {
                                  loading = false;
                                });
                                if (e.code == 'user-not-found') {
                                  print('$e ==> No user found for that email.');

                                  Get.snackbar(
                                    'oops!',
                                    'No user found for that email.',
                                    duration: Duration(seconds: 2),
                                    colorText: Colors.white,
                                    backgroundColor: PickColor.buttonColor,
                                  );
                                }
                              }
                            }
                          },
                          text: 'Reset Password')
                      : CircularProgressIndicator(
                          color: PickColor.buttonColor,
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an Account",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.to(() => SignUpScreen());
                        },
                        child: Text(
                          'SignUp',
                          style: TextStyle(
                              color: PickColor.buttonColor, fontSize: 18.sp),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
