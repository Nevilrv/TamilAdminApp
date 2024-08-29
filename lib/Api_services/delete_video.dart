import 'dart:developer';
import 'package:http/http.dart' as http;

class DeleteVideoServices {
  static Future<dynamic> deleteVideoServices(String id) async {
    // var headers = {
    //   'Authorization':
    //       'Basic ODI0ZmYwZWEtZTNlNC00MmI1LWJiOGUtYWY3YTJiMTQzMmE4Ois3YXByN2hhS0FKOHZ0cXVxUlNjbFlSeS8vWlZvRkdxcmd2RnpaajJ1LzVadENSNDc3aDVSamozQmhrRlRjMWJHSEh3eUoxVHpaRA=='
    // };
    var headers = {
      'Authorization':
          'Basic M2MxMDNhM2YtY2E5Yy00NTAxLTg2YWYtZTgzZDljODk3Mzk0OkVGUTBLY2NzeWFmWm9EY21MOWxkWFdEeGFWeWNacjhZQkxuRi8zUXd6UEVLSlNUNjgvMFg2anBuaWtpY2dNcjZDRmoyb254azVTcw=='
    };
    final http.Response response = await http.delete(
        Uri.parse('https://api.mux.com/video/v1/assets/$id'),
        headers: headers);

    if (response.statusCode == 204) {
      log('delete===>>>${response.statusCode}');
      var result = response.body;
      log(result);
      return response;
    } else {
      return "delete failed";
    }
  }
}
