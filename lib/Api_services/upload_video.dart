import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tamil_admin_panel/model/req_model/upload_video_model.dart';

import '../ViewModel/text_edit_controller.dart';

List videosData = [];

String auth = '824ff0ea-e3e4-42b5-bb8e-af7a2b1432a8' +
    ':' +
    '+7apr7haKAJ8vtquqRSclYRy//ZVoFGqrgvFzZj2u/5ZtCR477h5Rjj3BhkFTc1bGHHwyJ1TzZD';

class UploadVideoServices {
  static Future uploadVideoServices({var url}) async {
    TextEditControllerFind _editControllerFind =
        Get.put(TextEditControllerFind());

    print(
        "_editControllerFind_controllerValue${_editControllerFind.titleController}");
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization':
          'Basic M2MxMDNhM2YtY2E5Yy00NTAxLTg2YWYtZTgzZDljODk3Mzk0OkVGUTBLY2NzeWFmWm9EY21MOWxkWFdEeGFWeWNacjhZQkxuRi8zUXd6UEVLSlNUNjgvMFg2anBuaWtpY2dNcjZDRmoyb254azVTcw=='
    };
    http.Response response = await http.post(
      Uri.parse('https://api.mux.com/video/v1/assets'),
      body: json.encode({
        "input": [
          {"url": url}
        ],
        "playback_policy": ["public"]
      }),
      headers: headers,
    );
    if (response.statusCode == 201) {
      log('===>>>${response.body}');
      videosData = [];
      videosData.add(jsonDecode(response.body));
      var playBackId = videosData[0]['data']['playback_ids'][0]['id'];
      var assetId = videosData[0]['data']['id'];
      FirebaseFirestore.instance.collection('VideoData').doc(playBackId).set({
        'title': _editControllerFind.titleController.text,
        'Description': _editControllerFind.desCrIpTionController.text,
        'playBackIds': playBackId,
        'assetIds': assetId,
        'time': DateTime.now(),
      });
      return jsonDecode(response.body);
    } else {
      print('status${response.body}');
    }
    return null;
  }
}
