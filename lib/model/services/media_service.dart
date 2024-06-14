import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:mvvm_flutter_app/model/apis/app_exception.dart';
import 'package:mvvm_flutter_app/model/services/base_service.dart';

import '../../utils/Helper.dart';

class MediaService extends BaseService {
  String? retrievedToken;
  var selectedLanguage;

  Future<void> setState() async {
    retrievedToken = await Helper.getUserToken();
    selectedLanguage = await Helper.getLocale();
  }

  Future<Map<String, String>> getHeaders() async {
    if (retrievedToken == null || selectedLanguage == null) {
      await setState();
    }
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $retrievedToken',
      'Accept-Language': selectedLanguage.languageCode,
    };
  }

  void printRequestDetails(String url, Map<String, String> headers, dynamic body) {
    print('Request URL: $url');
    print('Request Headers: $headers');
    if (body != null) {
      print('Request Body: ${jsonEncode(body)}');
    }
  }

  void printResponseDetails(http.Response response) {
    print('Response Status Code: ${response.statusCode}');
    print('Response Headers: ${response.headers}');
    print('Response Body: ${response.body}');
    try {
      var responseBody = jsonDecode(response.body);
      print('Success: ${responseBody['success']}');
      print('Message: ${responseBody['message']}');
      print('Status: ${responseBody['status']}');
      print('Data: ${responseBody['data']}');
    } catch (e) {
      print('Error parsing response body: $e');
    }
  }

  @override
  Future<dynamic> postResponse(String url, dynamic requestBody) async {
    dynamic responseJson;
    try {
      await Future.delayed(Duration(milliseconds: 2));
      var headers = await getHeaders();

      printRequestDetails(getFullUrl(url), headers, requestBody);
      final response = await http.post(
        Uri.parse(getFullUrl(url)),
        headers: headers,
        body: jsonEncode(requestBody),
      );
      responseJson = returnResponse(response);
      printResponseDetails(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }


  @override
  Future<dynamic> putResponse(String url, dynamic requestBody) async {
    dynamic responseJson;
    try {
      await Future.delayed(Duration(milliseconds: 2));
      var headers = await getHeaders();

      printRequestDetails(getFullUrl(url), headers, requestBody);

      final response = await http.put(
        Uri.parse(getFullUrl(url)),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      responseJson = returnResponse(response);
      printResponseDetails(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future getResponse(String url) async {
    dynamic responseJson;
    try {
      await Future.delayed(Duration(milliseconds: 2));
      var headers = await getHeaders();

      printRequestDetails(getFullUrl(url), headers, {});

      final response = await http
          .get(Uri.parse(getFullUrl(url)), headers: headers
      );
      responseJson = returnResponse(response);
      printResponseDetails(response);
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
                ' with status code : ${response.statusCode} ${response.body
                    .toString()}');
    }
  }
}
