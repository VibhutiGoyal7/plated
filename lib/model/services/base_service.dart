import 'dart:io';

import 'package:Payrio/model/request/signInWithPhoneNumber.dart';

abstract class BaseService {
  final String BaseUrl = "https://custapi.payorio.com/";

  String getFullUrl(String endpoint) {
    return "$BaseUrl$endpoint";
  }

  Future<dynamic> postResponse(String url, dynamic phoneRequest);
  Future<dynamic> putResponse(String url, dynamic phoneRequest);
  Future<dynamic> getResponse(String url);
  Future<dynamic> putMultiFormResponse(String url, File file);
  Future<dynamic> postMultiFormResponse(String url, File imageFile, String docType,File videoFile);

}