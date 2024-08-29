import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:tamil_admin_panel/Api_services/delete_video.dart';
import 'package:tamil_admin_panel/ViewModel/text_edit_controller.dart';
import 'package:tamil_admin_panel/constant/common_button.dart';
import 'package:tamil_admin_panel/constant/common_text.dart';
import 'package:tamil_admin_panel/model/res_model/get_video_model.dart';
import 'package:tamil_admin_panel/signIn_screen.dart';
import 'package:tamil_admin_panel/views/update_screen.dart';
import 'package:tamil_admin_panel/views/upload_screen.dart';
import 'package:tamil_admin_panel/views/video_view_screen.dart';
import '../ViewModel/get_all_video_view_model.dart';
import '../apiModel/api_services/api_response.dart';
import '../constant/color.dart';
import '../controller/network_checker_controller.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final picker = ImagePicker();
  File? image;
  Future getCameraImage() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.camera);

    if (pickedFile != null) {
      image = File(pickedFile.path);

      print("=========${image}");
    }
  }

  Future getGalleryImage() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      image = File(pickedFile.path);

      print("=========>>>${image}");
    }
  }

  GetAllVideoViewModel getAllVideoViewModel = Get.put(GetAllVideoViewModel());
  ConnectivityProvider _connectivityProvider = Get.put(ConnectivityProvider());

  @override
  void initState() {
    _connectivityProvider.startMonitoring();
    getAllVideoViewModel.getAllVideoViewModel();

    super.initState();
  }

  TextEditControllerFind textEditControllerFind =
      Get.put(TextEditControllerFind());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: PickColor.buttonColor,
        onPressed: () {
          print('++++++++++++${textEditControllerFind.titleController}');
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (BuildContext context) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
                child: Container(
                  height: 214.h,
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            getCameraImage().whenComplete(
                              () => Get.to(
                                () => UploadScreen(
                                  videoFile: image,
                                  videoString: image?.path,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(368.w, 62.h),
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: PickColor.buttonColor,
                              ),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          child: CommonText(
                            text: 'Camera',
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: PickColor.buttonColor,
                          )),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: CommonButton(
                          onPressed: () {
                            getGalleryImage().whenComplete(
                              () => Get.to(
                                () => UploadScreen(
                                  videoFile: image,
                                  videoString: image?.path,
                                ),
                              ),
                            );
                          },
                          text: 'Gallery',
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: SvgPicture.asset(
          'assets/images/svg/plus.svg',
          height: 26.h,
          width: 26.w,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: GestureDetector(
              onTap: () async {
                await FirebaseAuth.instance.signOut();

                log('+++++++++++++++++++++++++++++++++++++++++++++${GetStorage().read('emails')}');
                await GetStorage().remove('emails').then((value) {
                  //  log('+++++++++++++++++++++++++++++++++++++++++++++${GetStorage().read('emails')}');
                  Get.snackbar(
                      duration: Duration(seconds: 2),
                      colorText: Colors.white,
                      backgroundColor: PickColor.buttonColor,
                      'success',
                      'SuccessFully LogOut');
                }).whenComplete(() => Get.offAll(() => SignInScreen()));
              },
              child: Icon(
                Icons.logout,
                color: PickColor.buttonColor,
              ),
            ),
          )
        ],
        leading: Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: SvgPicture.asset(
            'assets/images/svg/splash.svg',
            height: 60.23.h,
            width: 60.23.w,
          ),
        ),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         setState(() {
        //           print('refresh');
        //         });
        //       },
        //       icon: Icon(
        //         Icons.refresh,
        //         color: Color(0xff000000),
        //       ))
        // ],
      ),
      body: GetBuilder<ConnectivityProvider>(
        builder: (controller) {
          if (controller.isOnline!) {
            return Column(
              children: [
                SizedBox(height: 10.h),
                GetBuilder<GetAllVideoViewModel>(
                  builder: (controller) {
                    if (controller.getAllVideoApiResponse.status ==
                        Status.COMPLETE) {
                      GetAllVideoResponseModel response =
                          controller.getAllVideoApiResponse.data;
                      return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('VideoData')
                            .orderBy('time', descending: true)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            if (controller.videoList.length == 0) {
                              return Column(
                                children: [
                                  SizedBox(height: 100.h),
                                  Lottie.asset('assets/images/png/nodata.json')
                                ],
                              );
                            } else {
                              return Expanded(
                                child: ListView.builder(
                                  itemCount: controller.videoList.length,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 30.h),
                                      child: Container(
                                        width: Get.width,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 20.w, vertical: 15.h),
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.shade400,
                                              offset: Offset(1, 1.8),
                                              spreadRadius: 1.5,
                                              blurRadius: 3,
                                            ),
                                          ],
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(16.r),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(
                                                  () => VideoViewScreen(
                                                    videoFile:
                                                        'https://stream.mux.com/${controller.videoList[index].playbackIds![0].id}.m3u8',
                                                  ),
                                                  transition: Transition.fade,
                                                );
                                              },
                                              child: Container(
                                                height: 300.h,
                                                width: Get.width,
                                                alignment: Alignment.center,
                                                child: Column(
                                                  children: [
                                                    SizedBox(height: 25.h),
                                                    Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    10.w),
                                                        child: PopupMenuButton(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.r),
                                                          ),
                                                          child: Icon(
                                                            Icons
                                                                .more_vert_rounded,
                                                            color: Colors.grey,
                                                          ),
                                                          itemBuilder:
                                                              (BuildContext
                                                                  context) {
                                                            return [
                                                              PopupMenuItem(
                                                                child:
                                                                    ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                          primary: PickColor
                                                                              .buttonColor,
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(6.r),
                                                                          ),
                                                                          fixedSize: Size(
                                                                              92.w,
                                                                              34.h)),
                                                                  onPressed:
                                                                      () {
                                                                    Get.to(
                                                                        () =>
                                                                            UpdateScreen(
                                                                              id: '${snapshot.data?.docs[index].id}',
                                                                              videoLink: 'https://stream.mux.com/${controller.videoList[index].playbackIds![0].id}.m3u8',
                                                                            ))?.then(
                                                                        (value) =>
                                                                            Get.back());
                                                                  },
                                                                  child:
                                                                      CommonText(
                                                                    text:
                                                                        'Edit',
                                                                    fontSize:
                                                                        18.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                              ),
                                                              PopupMenuItem(
                                                                child:
                                                                    ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    primary: Colors
                                                                        .white,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(6.r),
                                                                        side: BorderSide(
                                                                          color:
                                                                              PickColor.buttonColor,
                                                                        )),
                                                                    fixedSize:
                                                                        Size(
                                                                            92.w,
                                                                            34.h),
                                                                  ),

                                                                  // onPressed: () {
                                                                  //   DeleteVideoServices.deleteVideoServices('${controller.videoList[index].id}').then((value) => Get.snackbar(
                                                                  //       backgroundColor:
                                                                  //           PickColor
                                                                  //               .buttonColor,
                                                                  //       duration: Duration(
                                                                  //           seconds:
                                                                  //               2),
                                                                  //       'Video Deleted',
                                                                  //       'SuccessFully'));
                                                                  //   log('++++Delete Video+++${response.data![index].id}');
                                                                  //
                                                                  //   controller.deleteVideo(
                                                                  //       controller
                                                                  //           .videoList[
                                                                  //               index]
                                                                  //           .id!);
                                                                  //
                                                                  //   FirebaseFirestore
                                                                  //       .instance
                                                                  //       .collection(
                                                                  //           'VideoData')
                                                                  //       .doc(
                                                                  //           '${snapshot.data?.docs[index].id}')
                                                                  //       .delete();
                                                                  //   Get.back();
                                                                  // },

                                                                  onPressed:
                                                                      () {
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return AlertDialog(
                                                                          content:
                                                                              Text(
                                                                            'Do you want to Delete this Video?',
                                                                            style:
                                                                                TextStyle(color: PickColor.buttonColor),
                                                                          ),
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5.h),
                                                                          ),
                                                                          title: Text(
                                                                              'Delete Video',
                                                                              style: TextStyle(
                                                                                color: PickColor.buttonColor,
                                                                                fontWeight: FontWeight.bold,
                                                                              )),
                                                                          actions: [
                                                                            MaterialButton(
                                                                              color: PickColor.buttonColor,
                                                                              minWidth: 80.w,
                                                                              height: 50.h,
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(5.h),
                                                                              ),
                                                                              onPressed: () {
                                                                                DeleteVideoServices.deleteVideoServices('${controller.videoList[index].id}').then((value) => Get.snackbar(backgroundColor: PickColor.buttonColor, colorText: Colors.white, duration: Duration(seconds: 2), 'Video Deleted', 'SuccessFully'));
                                                                                log('++++Delete Video+++${response.data![index].id}');

                                                                                controller.deleteVideo(controller.videoList[index].id!);

                                                                                FirebaseFirestore.instance.collection('VideoData').doc('${snapshot.data?.docs[index].id}').delete();
                                                                                Get.back();
                                                                              },
                                                                              child: Text(
                                                                                'Yes',
                                                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ),
                                                                            MaterialButton(
                                                                              color: PickColor.buttonColor,
                                                                              minWidth: 80.w,
                                                                              height: 50.h,
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(5.h),
                                                                              ),
                                                                              onPressed: () {
                                                                                Get.back();
                                                                              },
                                                                              child: Text(
                                                                                'No',
                                                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        );
                                                                      },
                                                                    ).then((value) =>
                                                                        Get.back());
                                                                  },
                                                                  child:
                                                                      CommonText(
                                                                    text:
                                                                        'Delete',
                                                                    color: PickColor
                                                                        .buttonColor,
                                                                    fontSize:
                                                                        18.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                              ),
                                                            ];
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                        // "https://image.mux.com/${response.data![index].playbackIds![0].id}/thumbnail.jpg"
                                                        "https://image.mux.com/${controller.videoList[index].playbackIds![0].id}/animated.gif?width=640&fps=5"),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16.r),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 26.h),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w),
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CommonText(
                                                          text:
                                                              '${snapshot.data?.docs[index]['title']}',
                                                          fontSize: 20.sp,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                        SizedBox(height: 15.h),
                                                        CommonText(
                                                          text:
                                                              '${snapshot.data?.docs[index]['Description']}',
                                                          fontSize: 14.sp,
                                                          color: PickColor
                                                              .secondary1TextColor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        SizedBox(height: 24.h),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                          } else {
                            return SizedBox();
                          }
                        },
                      );
                    } else {
                      if (controller.getAllVideoApiResponse.status ==
                          Status.ERROR) {
                        return Center(child: Text('Somthing Went Wrong'));
                      }
                      // return Center(
                      //   child: CircularProgressIndicator(
                      //       color: PickColor.buttonColor),
                      // );
                      return Center(
                        child: LoadingAnimationWidget.inkDrop(
                          color: PickColor.buttonColor,
                          size: 50.h,
                        ),
                      );
                    }
                  },
                ),
              ],
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

  Widget buildCommonText(GetAllVideoResponseModel response, int index) {
    try {
      return CommonText(
        text: '${response.data![index].tracks![0].type} ',
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
      );
    } catch (e) {
      return SizedBox();
    }
  }
}
