import 'dart:developer';
import 'package:get/get.dart';
import 'package:tamil_admin_panel/apiModel/Repo/get_all_video_repo.dart';
import '../apiModel/api_services/api_response.dart';
import '../model/res_model/get_video_model.dart';

class GetAllVideoViewModel extends GetxController {
  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get getAllVideoApiResponse => _apiResponse;

  List<Datum> videoList = [];

  Future<void> getAllVideoViewModel() async {
    _apiResponse = ApiResponse.loading(message: 'Loading');
    update();
    try {
      GetAllVideoResponseModel response =
          await GetAllVideoRepo().getAllVideoRepo();
      log('==GetVideoResModel=>$response');
      _apiResponse = ApiResponse.complete(response);
      videoList.addAll(response.data!);
    } catch (e) {
      _apiResponse = ApiResponse.error(message: e.toString());
      log("==GetVideoResModel=> $e");
    }
    update();
  }

  deleteVideo(String id) {
    print('PRINT:- ${id}');
    for (var i = 0; i < videoList.length; i++) {
      if (videoList[i].id == id) {
        print('videoList[i].id ${videoList[i].id}====${id}');

        videoList.remove(videoList[i]);
      }
    }
    update();
  }
}
