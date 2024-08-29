import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:tamil_admin_panel/ViewModel/text_edit_controller.dart';
import 'package:tamil_admin_panel/views/home_screen.dart';
import 'package:video_player/video_player.dart';

import '../constant/color.dart';
import '../constant/common_button.dart';
import '../constant/common_text.dart';
import '../controller/network_checker_controller.dart';

class UpdateScreen extends StatefulWidget {
  UpdateScreen({
    Key? key,
    required this.id,
    required this.videoLink,
  }) : super(key: key);

  final String id;
  final dynamic videoLink;

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  // final titleController = TextEditingController();
  // final subTitleController = TextEditingController();

  TextEditControllerFind textEditControllerFind =
      Get.put(TextEditControllerFind());
  final key = GlobalKey<FormState>();
  ConnectivityProvider _connectivityProvider = Get.put(ConnectivityProvider());

  @override
  void initState() {
    getVideo();

    _connectivityProvider.startMonitoring();

    super.initState();
  }

  late VideoPlayerController _controller;
  bool _isPlay = true;
  Future<void> getVideo({String? videoUrl}) async {
    _controller = VideoPlayerController.network(
      '${widget.videoLink}',
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((value) {
      _controller.play();
    });

    // _controller.setLooping(true);
  }

  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
            size: 20.h,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 22.w),
            child: SvgPicture.asset(
              'assets/images/svg/notification.svg',
              height: 28.h,
              width: 28.w,
            ),
          ),
        ],
      ),
      body: GetBuilder<ConnectivityProvider>(
        builder: (controller) {
          if (controller.isOnline!) {
            return Form(
              key: key,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 35.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 27.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: Container(
                          height: 201.h,
                          width: Get.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              VideoPlayer(_controller),
                              _isPlay == false
                                  ? Positioned(
                                      top: 80.h,
                                      left: 160.w,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            _isPlay = true;
                                          });
                                          _controller.play();
                                        },
                                        child: SvgPicture.asset(
                                          'assets/images/svg/video.svg',
                                          height: 56.h,
                                          width: 56.w,
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        setState(() {
                                          _isPlay = false;
                                        });
                                        _controller.pause();
                                      },
                                      child: SizedBox(
                                        height: double.infinity,
                                        width: double.infinity,
                                      ),
                                    )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32.h),
                    SizedBox(height: 29.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: CommonText(
                        text: 'Title',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff5F5F5F),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: TextFormField(
                        controller: textEditControllerFind.titleController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter The Title';
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.text,
                        cursorColor: PickColor.buttonColor,
                        decoration: InputDecoration(
                          hintText: 'Conversation',
                          hintStyle: TextStyle(
                            color: PickColor.secondaryTextColor,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide:
                                BorderSide(color: PickColor.buttonColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide:
                                BorderSide(color: PickColor.buttonColor),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 26.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: CommonText(
                        text: 'Description',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff5F5F5F),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: TextFormField(
                        controller:
                            textEditControllerFind.desCrIpTionController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter The Subtitle';
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.text,
                        maxLines: 5,
                        cursorColor: PickColor.buttonColor,
                        decoration: InputDecoration(
                          hintText: 'Conversation',
                          hintStyle: TextStyle(
                            color: PickColor.secondaryTextColor,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide:
                                BorderSide(color: PickColor.buttonColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide:
                                BorderSide(color: PickColor.buttonColor),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 150.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: isLoaded == true
                          ? Center(
                              child: LoadingAnimationWidget.inkDrop(
                                  color: PickColor.buttonColor, size: 50.h),
                            )
                          : CommonButton(
                              onPressed: () {
                                if (key.currentState!.validate()) {
                                  setState(() {
                                    isLoaded = true;
                                  });
                                  FirebaseFirestore.instance
                                      .collection('VideoData')
                                      .doc(widget.id)
                                      .update({
                                        'title': textEditControllerFind
                                            .titleController.text,
                                        'Description': textEditControllerFind
                                            .desCrIpTionController.text,
                                        'time': DateTime.now(),
                                      })
                                      .then((value) => Get.snackbar(
                                          duration: Duration(seconds: 2),
                                          colorText: Colors.white,
                                          backgroundColor:
                                              PickColor.buttonColor,
                                          'Update',
                                          'SuccessFully'))
                                      .whenComplete(() {
                                        setState(() {
                                          isLoaded = false;
                                        });
                                      });
                                  Get.offAll(HomeScreen());
                                } else {
                                  setState(() {
                                    isLoaded = false;
                                  });
                                  return null;
                                }
                              },
                              text: 'Update'),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Column(
              children: [
                Center(
                    child: Lottie.asset('assets/images/png/no_internet2.json')),
                SizedBox(height: 30.h),
                Text('Please Check Your Internet Connection',
                    style: TextStyle(
                        fontSize: 20.sp, color: PickColor.buttonColor)),
              ],
            );
          }
        },
      ),
    );
  }
}
