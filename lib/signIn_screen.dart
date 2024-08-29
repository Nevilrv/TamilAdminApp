import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tamil_admin_panel/constant/common_button.dart';
import 'package:tamil_admin_panel/signup_screen.dart';
import 'package:tamil_admin_panel/views/forget_password_screen.dart';
import 'package:tamil_admin_panel/views/home_screen.dart';
import 'constant/color.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();

  final passWordController = TextEditingController();

  final _key = GlobalKey<FormState>();

  bool isPassword = false;
  bool loading = false;
  static Future<User?> logIn(String email, String password) async {
    try {
      User? user = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password))
          .user;

      if (user != null) {
        GetStorage().write('emails', email);

        print('DATA: ===${GetStorage().read('emails')}');
        print('logIn Successful');

        return user;
      } else {
        print('LogIn Failed');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  ///reset Password ///

  ///
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
                  SizedBox(height: 20.h),
                  TextFormField(
                    onTap: () {},
                    controller: passWordController,
                    textInputAction: TextInputAction.next,
                    validator: (password) {
                      RegExp regex = RegExp(
                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                      if (password!.isEmpty) {
                        return 'Your password must be at least 8 characters long\n contain at least one number and have a mixture\n of uppercase and lowercase letters.';
                      } else if (!regex.hasMatch(password)) {
                        return 'Your password must be at least 8 characters long\n contain at least one number and have a mixture\n of uppercase and lowercase letters.';
                      }
                      return null;
                    },
                    obscureText: !isPassword,
                    decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                            child: isPassword
                                ? Icon(Icons.visibility,
                                    color: PickColor.buttonColor)
                                : Icon(Icons.visibility_off,
                                    color: PickColor.buttonColor),
                            onTap: () {
                              setState(() {
                                isPassword = !isPassword;
                                print(isPassword);
                              });
                            }),
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        hintText: 'Password',
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
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        Get.to(() => ForgetPasswordScreen());
                      },
                      child: Text(
                        'Reset Password?',
                        style: TextStyle(
                          color: PickColor.buttonColor,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
                                final credential = await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passWordController.text,
                                );
                                Get.snackbar(
                                  'Success',
                                  'SuccessFul SignIn',
                                  duration: Duration(seconds: 2),
                                  colorText: Colors.white,
                                  backgroundColor: PickColor.buttonColor,
                                );
                                Get.offAll(() => HomeScreen());

                                GetStorage()
                                    .write('emails', emailController.text);
                                print(
                                    '++++++++++++++++++++++++${GetStorage().read('emails')}+++++++++++++++++');
                              } on FirebaseAuthException catch (e) {
                                setState(() {
                                  loading = false;
                                });
                                if (e.code == 'user-not-found') {
                                  print('No user found for that email.');
                                  Get.snackbar(
                                    'Oops!',
                                    'No user found for that email.',
                                    duration: Duration(seconds: 2),
                                    colorText: Colors.white,
                                    backgroundColor: PickColor.buttonColor,
                                  );
                                } else if (e.code == 'wrong-password') {
                                  print(
                                      'Wrong password provided for that user.');
                                  Get.snackbar(
                                    'Oops!',
                                    'Wrong password provided for that user.',
                                    duration: Duration(seconds: 2),
                                    colorText: Colors.white,
                                    backgroundColor: PickColor.buttonColor,
                                  );
                                }
                              } catch (e) {
                                print(e);
                              }
                            }
                          },
                          text: 'SignIn')
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

  /// email=admin@gmail.com          password=Admin@#123
}
