import 'dart:io';

import 'package:Payrio/model/request/signInWithPhoneNumber.dart';

abstract class BaseService {
  final String mediaBaseUrl = "https://custapi.payorio.com/";

  String getFullUrl(String endpoint) {
    return "$mediaBaseUrl$endpoint";
  }

  Future<dynamic> postResponse(String url, dynamic phoneRequest);
  Future<dynamic> putResponse(String url, dynamic phoneRequest);
  Future<dynamic> getResponse(String url);
  Future<dynamic> putMultiFormResponse(String url, File file);
  Future<dynamic> postMultiFormResponse(String url, File file, String docType,String imageName);

}