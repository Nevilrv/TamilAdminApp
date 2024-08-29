import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import '../constant/color.dart';
import '../controller/network_checker_controller.dart';

class VideoViewScreen extends StatefulWidget {
  VideoViewScreen({Key? key, required this.videoFile}) : super(key: key);

  String videoFile;

  @override
  State<VideoViewScreen> createState() => _VideoViewScreenState();
}

class _VideoViewScreenState extends State<VideoViewScreen> {
  late VideoPlayerController _controller;

  bool _isPlay = true;

  Future<void> getVideo({String? videoUrl}) async {
    _controller = VideoPlayerController.network(
      '${widget.videoFile}',
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

  ConnectivityProvider _connectivityProvider = Get.put(ConnectivityProvider());

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ConnectivityProvider>(
        builder: (controller) {
          if (controller.isOnline!) {
            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ],
                ),
                _isPlay == false
                    ? Positioned(
                        top: 450.h,
                        left: 200.w,
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
                      ),
              ],
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
