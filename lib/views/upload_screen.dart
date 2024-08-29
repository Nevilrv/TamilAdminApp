import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:tamil_admin_panel/ViewModel/text_edit_controller.dart';
import 'package:tamil_admin_panel/constant/color.dart';
import 'package:tamil_admin_panel/notification/notification_service.dart';
import 'package:tamil_admin_panel/notification/utils.dart';
import 'package:tamil_admin_panel/views/home_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../Api_services/upload_video.dart';
import '../ViewModel/get_all_video_view_model.dart';
import '../constant/common_button.dart';
import '../constant/common_text.dart';
import '../controller/network_checker_controller.dart';
import '../model/req_model/upload_video_model.dart';

class UploadScreen extends StatefulWidget {
  UploadScreen({
    Key? key,
    required this.videoFile,
    this.videoString,
  }) : super(
          key: key,
        );
  final videoFile;
  final videoString;
  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  // final titleController = TextEditingController();
  // final subTitleController = TextEditingController();

  TextEditControllerFind _editControllerFind =
      Get.put(TextEditControllerFind());

  final _key = GlobalKey<FormState>();
  late VideoPlayerController _controller;
  bool _isPlay = true;
  Future<void> getVideo({String? videoUrl}) async {
    _controller = VideoPlayerController.network(
      '${widget.videoString}',
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: true,


      ),
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

  GetAllVideoViewModel getAllVideoViewModel = Get.put(GetAllVideoViewModel());
  Future<void> getAllVideo() async {
    await getAllVideoViewModel.getAllVideoViewModel();
  }

  bool isLoading = false;
  ConnectivityProvider _connectivityProvider = Get.put(ConnectivityProvider());

  int sound = 10;

  /// upload video in Firebase///
  Future<String?> uploadFile({File? file, int? filename}) async {
    print("File path:$file");
    try {
      var response = await FirebaseStorage.instance
          .ref("user_image/$filename")
          .putFile(file!);
      var result =
          await response.storage.ref("user_image/$filename").getDownloadURL();
      return result;
    } catch (e) {
      print("ERROR===>>$e");
    }
    return null;
  }

  @override
  void initState() {
    _connectivityProvider.startMonitoring();
    getVideo();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List allData = [];
  Future<void> getData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('email').get();

    // Get data from docs and convert map to List
    // final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    // for a specific field
    allData = querySnapshot.docs.map((doc) => doc.get('fcmToken')).toList();
    // allData.remove(storage.read('fcm'));
  }

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
      ),
      body: GetBuilder<ConnectivityProvider>(
        builder: (controller) {
          if (controller.isOnline!) {
            return Form(
              key: _key,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 35.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 27.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: Container(
                          height: 300.h,
                          width: Get.width,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Stack(
                            children: [
                              // VideoPlayer(_controller),

                              VideoPlayer(_controller),

                              _isPlay == false
                                  ? Positioned(
                                      top: 100.h,
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.white,
                          thumbShape: RoundSliderThumbShape(
                              enabledThumbRadius: 9.r, pressedElevation: 0),
                          overlayShape:
                              RoundSliderOverlayShape(overlayRadius: 10.r),
                        ),
                        child: Slider(
                          value: sound.toDouble(),
                          activeColor: PickColor.buttonColor,
                          inactiveColor: PickColor.dullColor,
                          thumbColor: Colors.grey.shade100,
                          onChanged: (value) {
                            setState(() {
                              sound = value.toInt();
                            });
                          },
                          min: 5,
                          max: 100,
                        ),
                      ),
                    ),
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
                        controller: _editControllerFind.titleController,
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
                        controller: _editControllerFind.desCrIpTionController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter The Subtitle';
                          } else {
                            return null;
                          }
                        },
                        maxLines: 5,
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
                    SizedBox(height: 100.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: isLoading == true
                          ? Center(
                              child: LoadingAnimationWidget.inkDrop(
                                  color: PickColor.buttonColor, size: 50.h))
                          : CommonButton(
                              onPressed: () async {
                                if (_key.currentState!.validate()) {
                                  // uploadToStorage();
                                  setState(() {
                                    isLoading = true;
                                  });
                                  var videoUrl = await uploadFile(
                                      file: widget.videoFile,
                                      filename: Random().nextInt(1000000));

                                  UploadVideoRequestModel model =
                                      UploadVideoRequestModel();
                                  // List<Map<String, dynamic>> bodys = [
                                  //   {
                                  //     "input": [
                                  //       {
                                  //         "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
                                  //       }
                                  //     ],
                                  //     "playback_policy": ["public"]
                                  //   }
                                  // ];
                                  // Map<String, dynamic> body = {
                                  //   "input": [
                                  //     {"url": "https://muxed.s3.amazonaws.com/leds.mp4"}
                                  //   ],
                                  //   "playback_policy": ["public"]
                                  // };

                                  // model.input?[0].url =
                                  //     "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
                                  // model.playbackPolicy = ['public'];
                                  await UploadVideoServices.uploadVideoServices(
                                          url: '${videoUrl}')
                                      .then((value) => Get.snackbar(
                                          duration: Duration(seconds: 2),
                                          colorText: Colors.white,
                                          backgroundColor:
                                              PickColor.buttonColor,
                                          'Video Upload',
                                          'SuccessFully'))
                                      .whenComplete(() {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    getAllVideo();
                                    print(
                                        '-------path------${widget.videoFile}');
                                  });

                                  Get.offAll(HomeScreen());

                                  await getData();
                                  for (int i = 0; i < allData.length; i++) {
                                    AppNotificationHandler.sendMessage(
                                        msg: 'New Video Added ',
                                        receiverFcmToken: allData[i]);
                                  }
                                } else {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  return null;
                                }
                              },
                              text: 'Upload'),
                    ),
                    SizedBox(height: 10.h),
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
