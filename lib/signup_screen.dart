import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tamil_admin_panel/constant/common_button.dart';
import 'package:tamil_admin_panel/signIn_screen.dart';
import 'package:tamil_admin_panel/views/home_screen.dart';
import 'constant/color.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final passWordController = TextEditingController();
  final nameController = TextEditingController();

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
                    controller: nameController,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'This field is required';
                      } else if (!RegExp('[a-zA-Z]').hasMatch(value)) {
                        return 'please enter valid name';
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
                        hintText: 'First & last name',
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
                  SizedBox(height: 80.h),
                  loading == false
                      ? CommonButton(
                          // onPressed: () async {
                          //   if (_key.currentState!.validate()) {
                          //     setState(() {
                          //       loading = true;
                          //     });
                          //
                          //     logIn(emailController.text,
                          //             passWordController.text)
                          //         .then((value) {
                          //       if (value != null) {
                          //         setState(() {
                          //           loading = false;
                          //         });
                          //         Get.snackbar(
                          //           'Success',
                          //           'SuccessFul SignIn',
                          //           duration: Duration(seconds: 2),
                          //           colorText: Colors.white,
                          //           backgroundColor: PickColor.buttonColor,
                          //         );
                          //
                          //         Get.offAll(HomeScreen());
                          //       } else {
                          //         setState(() {
                          //           loading = false;
                          //         });
                          //         Get.snackbar(
                          //           'Oops!',
                          //           'Invalid Email or Password',
                          //           duration: Duration(seconds: 2),
                          //           colorText: Colors.white,
                          //           backgroundColor: PickColor.buttonColor,
                          //         );
                          //       }
                          //     });
                          //   }
                          // },
                          onPressed: () async {
                            if (_key.currentState!.validate()) {
                              try {
                                setState(() {
                                  loading = true;
                                });
                                final credential = await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passWordController.text,
                                );
                                FirebaseFirestore.instance
                                    .collection('publisherUser')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .set({
                                  'email': emailController.text,
                                  'password': passWordController.text,
                                  'name': nameController.text,
                                }).then((value) {
                                  GetStorage()
                                      .write('emails', emailController.text);
                                  print(
                                      '++++++++++++++++++++++++${GetStorage().read('emails')}+++++++++++++++++');
                                  Get.snackbar(
                                    'Success',
                                    'SuccessFul SignUp',
                                    duration: Duration(seconds: 2),
                                    colorText: Colors.white,
                                    backgroundColor: PickColor.buttonColor,
                                  );
                                }).whenComplete(
                                        () => Get.offAll(() => HomeScreen()));
                              } on FirebaseAuthException catch (e) {
                                setState(() {
                                  loading = false;
                                });
                                if (e.code == 'weak-password') {
                                  print('The password provided is too weak.');
                                  Get.snackbar(
                                    'Oops!',
                                    'The password provided is too weak.',
                                    duration: Duration(seconds: 2),
                                    colorText: Colors.white,
                                    backgroundColor: PickColor.buttonColor,
                                  );
                                } else if (e.code == 'email-already-in-use') {
                                  print(
                                      'The account already exists for that email.');
                                  Get.snackbar(
                                    'Oops!',
                                    'The account already exists for that email.',
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
                          text: 'SignUp')
                      : CircularProgressIndicator(
                          color: PickColor.buttonColor,
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an Account?',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.to(() => SignInScreen());
                        },
                        child: Text(
                          'SignIn',
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
