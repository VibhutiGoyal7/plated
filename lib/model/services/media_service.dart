import 'dart:convert';
import 'dart:io';
import 'package:meta/meta.dart';

import 'package:http/http.dart' as http;
import 'package:mvvm_flutter_app/model/apis/app_exception.dart';
import 'package:mvvm_flutter_app/model/services/base_service.dart';
import 'package:mvvm_flutter_app/model/signInWithPhoneNumber.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/Helper.dart';

class MediaService extends BaseService {
  @override
  Future<dynamic> getResponse(String url, dynamic requestBody) async {
    dynamic responseJson;
    try {

      String? retrievedToken = await Helper.getUserToken();
      final response = await http.post(Uri.parse(mediaBaseUrl + url),
        headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $retrievedToken',
      },
        body:jsonEncode(requestBody),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future<dynamic> putResponse(String url, dynamic requestBody) async {
    dynamic responseJson;
    try {
      String? retrievedToken = await Helper.getUserToken();
      final response = await http.put(Uri.parse(mediaBaseUrl + url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $retrievedToken',
        },
        body:jsonEncode(requestBody),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }
  @visibleForTesting
  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 201:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 422:
        throw BadRequestException(response.body.toString());
      case 401:
        throw UnauthorisedException(response.body.toString());
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
        throw BadRequestException(response.body.toString());
      default:
        throw FetchDataException(
            'Error occured while communication with server' +
                ' with status code : ${response.statusCode} ${response.body.toString()}');
    }
  }
}
