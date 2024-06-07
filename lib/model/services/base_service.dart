import 'package:mvvm_flutter_app/model/signInWithPhoneNumber.dart';

abstract class BaseService {
  final String mediaBaseUrl = "https://custapi.payorio.com/";

  String getFullUrl(String endpoint) {
    return "$mediaBaseUrl$endpoint";
  }

  Future<dynamic> getResponse(String url, dynamic phoneRequest);

}