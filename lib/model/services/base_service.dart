import 'dart:io';

import 'package:FlutterBasicStructure/model/request/signInWithPhoneNumber.dart';

abstract class BaseService {
  final String BaseUrl = "https://custapi.payorio.com/";

  String getFullUrl(String endpoint) {
    return "$BaseUrl$endpoint";
  }

  Future<dynamic> postResponse(String url, dynamic phoneRequest);

  Future<dynamic> putResponse(String url, dynamic phoneRequest);

  Future<dynamic> getResponse(String url);

  Future<dynamic> putMultiFormResponse(String url, File file, String firstName,
      String lastName, String dob);
}