import 'dart:convert';

import 'package:mvvm_flutter_app/model/request/changeOldPasswordRequest.dart';
import 'package:mvvm_flutter_app/model/request/createOtpChangePass.dart';
import 'package:mvvm_flutter_app/model/request/createOtpEmailVerifyRequest.dart';
import 'package:mvvm_flutter_app/model/request/verifyOtpEmailVerifyRequest.dart';
import 'package:mvvm_flutter_app/model/response/createOtpForEmailVerifyResponse.dart';
import 'package:mvvm_flutter_app/model/response/phoneVerifyResponse.dart';
import 'package:mvvm_flutter_app/model/response/createOtpChangePassResponse.dart';
import 'package:mvvm_flutter_app/model/response/profileResponse.dart';
import 'package:mvvm_flutter_app/model/services/base_service.dart';
import 'package:mvvm_flutter_app/model/services/media_service.dart';
import 'package:mvvm_flutter_app/model/request/setUpAccountRequest.dart';
import 'package:mvvm_flutter_app/model/response/setUpAccountResponse.dart';
import 'package:mvvm_flutter_app/model/request/signInWithPhoneNumber.dart';
import 'package:mvvm_flutter_app/model/request/verifyOtpChangePass.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/Helper.dart';
import 'response/otpVerifyResponse.dart';

class MediaRepository {
  BaseService _mediaService = MediaService();

  Future<PhoneVerifyResponse> fetchMediaList(String value, PhoneRequest phoneRequest  ) async {
    print(phoneRequest);
    dynamic response = await _mediaService.postResponse(value,phoneRequest);
    final jsonData = response;//['data'];
    print(jsonData);
    PhoneVerifyResponse mediaList = PhoneVerifyResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<OtpVerifyResponse> fetchOtpVerifyData(String value, PhoneRequest phoneRequest) async {
    print(phoneRequest);
    dynamic response = await _mediaService.postResponse(value,phoneRequest);
    print(value);
    final jsonData = response;
    print(jsonData);
    OtpVerifyResponse mediaList = OtpVerifyResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<SetUpAccountResponse> fetchSetUpScreenData(String value, SetUpAccountRequest setUpAccountRequest) async {
    print(setUpAccountRequest);
    dynamic response = await _mediaService.putResponse(value,setUpAccountRequest);
    print(value);
    final jsonData = response;
    print(jsonData);
    SetUpAccountResponse mediaList = SetUpAccountResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<ProfileResponse> ProfileScreenData(String value) async {
    dynamic response = await _mediaService.getResponse(value);
    print(value);
    final jsonData = response;//['data'];
    print(jsonData);
    ProfileResponse mediaList = ProfileResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<dynamic> ChangeWithOldPasswordData(String value, ChangeOldPassRequest changeOldPassRequest) async {
    print(changeOldPassRequest);
    dynamic response = await _mediaService.putResponse(value,changeOldPassRequest);
    print(value);
    final jsonData = response;
    print(jsonData);
    return response;
    //SetUpAccountResponse mediaList = SetUpAccountResponse.fromJson(jsonData);
  }

  Future<CreateOtpChangePassResponse> CreateOtpChangePass(String value, CreateOtpChangePassRequest createOtpChangePassRequest) async {
    print(createOtpChangePassRequest);
    dynamic response = await _mediaService.postResponse(value,createOtpChangePassRequest);
    print(value);
    final jsonData = response;
    print(jsonData);
    CreateOtpChangePassResponse mediaList = CreateOtpChangePassResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<dynamic> VerifyOtpChangePass(String value, VerifyOtChangePassRequest verifyOtChangePassRequest) async {
    print(verifyOtChangePassRequest);
    dynamic response = await _mediaService.postResponse(value,verifyOtChangePassRequest);
    print(value);
    final jsonData = response;
    print(jsonData);
    return response;
  }

  Future<CreateOtpVerifyEmailResponse> CreateOtpVerifyEmail(String value, CreateOtpEmailVerifyRequest createOtpEmailVerifyRequest) async {
    print(createOtpEmailVerifyRequest);
    dynamic response = await _mediaService.postResponse(value,createOtpEmailVerifyRequest);
    print(value);
    final jsonData = response;
    final jsonDat = response;
    print(jsonDat);
    CreateOtpVerifyEmailResponse mediaList = CreateOtpVerifyEmailResponse.fromJson(jsonData);
    print(mediaList.mobileOtp);
    return mediaList;
  }

  Future<dynamic> VerifyOtpVerifyEmail(String value, VerifyOtpEmailVerifyRequest verifyOtpEmailVerifyRequest) async {
    print(verifyOtpEmailVerifyRequest);
    dynamic response = await _mediaService.postResponse(value,verifyOtpEmailVerifyRequest);
    print(value);
    final jsonData = response;
    print(jsonData);
    return response;
  }
}
