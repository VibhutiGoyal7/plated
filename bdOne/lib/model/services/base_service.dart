import 'dart:io';


abstract class BaseService {
  final String BaseUrl = "http://192.168.1.74:3000/";

  String getFullUrl(String endpoint) {
    return "$BaseUrl$endpoint";
  }

  Future<dynamic> postResponse(String url, dynamic phoneRequest);

  Future<dynamic> putResponse(String url, dynamic phoneRequest);

  Future<dynamic> getResponse(String url);

  Future<dynamic> putMultiFormResponse(String url, File file, String firstName,
      String lastName, String dob);
}