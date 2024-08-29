import 'dart:developer';

import '../../model/res_model/get_video_model.dart';
import '../api_services/api_routes.dart';
import '../api_services/api_service.dart';

class GetAllVideoRepo extends ApiRoutes {
  Future<dynamic> getAllVideoRepo() async {
    var response =
        await ApiService().getResponse(apiType: APIType.aGet, url: getAllVideo);

    log('getVideoResModel ----------- $response');
    log('getVideoResModel URL ----------- $getAllVideo ');

    GetAllVideoResponseModel getAllVideoResponseModel =
        GetAllVideoResponseModel.fromJson(response);
    return getAllVideoResponseModel;
  }
}
