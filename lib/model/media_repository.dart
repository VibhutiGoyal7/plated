import 'dart:convert';

import 'package:mvvm_flutter_app/model/media.dart';
import 'package:mvvm_flutter_app/model/services/base_service.dart';
import 'package:mvvm_flutter_app/model/services/media_service.dart';
import 'package:mvvm_flutter_app/model/setUpAccountRequest.dart';
import 'package:mvvm_flutter_app/model/setUpAccountResponse.dart';
import 'package:mvvm_flutter_app/model/signInWithPhoneNumber.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/Helper.dart';
import 'otpVerifyResponse.dart';

class MediaRepository {
  BaseService _mediaService = MediaService();

  Future<Media> fetchMediaList(String value, PhoneRequest phoneRequest) async {
    print(phoneRequest);
    dynamic response = await _mediaService.getResponse(value,phoneRequest);
    final jsonData = response['data'];
    print(jsonData);
    Media mediaList = Media.fromJson(jsonData);
    return mediaList;
  }

  Future<OtpVerifyResponse> fetchOtpVerifyData(String value, PhoneRequest phoneRequest) async {
    print(phoneRequest);
    dynamic response = await _mediaService.getResponse(value,phoneRequest);
    print(value);
    final jsonData = response['data'];
    print(jsonData);
    OtpVerifyResponse mediaList = OtpVerifyResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<SetUpAccountResponse> fetchSetUpScreenData(String value, SetUpAccountRequest setUpAccountRequest) async {
    print(setUpAccountRequest);
    dynamic response = await _mediaService.putResponse(value,setUpAccountRequest);
    print(value);
    final jsonData = response['data'];
    print(jsonData);
    SetUpAccountResponse mediaList = SetUpAccountResponse.fromJson(jsonData);
    return mediaList;
  }
}
