import 'dart:convert';
import 'dart:io';

import 'package:Payrio/model/request/changeOldPasswordRequest.dart';
import 'package:Payrio/model/request/createOtpChangePass.dart';
import 'package:Payrio/model/request/createOtpEmailVerifyRequest.dart';
import 'package:Payrio/model/request/verifyOtpEmailVerifyRequest.dart';
import 'package:Payrio/model/response/countryListResponse.dart';
import 'package:Payrio/model/response/createOtpForEmailVerifyResponse.dart';
import 'package:Payrio/model/response/fetchKycDocResponse.dart';
import 'package:Payrio/model/response/phoneVerifyResponse.dart';
import 'package:Payrio/model/response/createOtpChangePassResponse.dart';
import 'package:Payrio/model/response/profileResponse.dart';
import 'package:Payrio/model/response/uploadKycResponse.dart';
import 'package:Payrio/model/services/base_service.dart';
import 'package:Payrio/model/services/media_service.dart';
import 'package:Payrio/model/request/setUpAccountRequest.dart';
import 'package:Payrio/model/response/setUpAccountResponse.dart';
import 'package:Payrio/model/request/signInWithPhoneNumber.dart';
import 'package:Payrio/model/request/verifyOtpChangePass.dart';
import 'package:Payrio/model/request/changeOldPasswordRequest.dart';
import 'package:Payrio/model/request/createOtpChangePass.dart';
import 'package:Payrio/model/request/createOtpEmailVerifyRequest.dart';
import 'package:Payrio/model/request/exustingUserRequest.dart';
import 'package:Payrio/model/request/signInRequest.dart';
import 'package:Payrio/model/request/verifyOtpEmailVerifyRequest.dart';
import 'package:Payrio/model/response/createOtpForEmailVerifyResponse.dart';
import 'package:Payrio/model/response/existingUserResponse.dart';
import 'package:Payrio/model/response/phoneVerifyResponse.dart';
import 'package:Payrio/model/response/createOtpChangePassResponse.dart';
import 'package:Payrio/model/response/profileResponse.dart';
import 'package:Payrio/model/response/signInResponse.dart';
import 'package:Payrio/model/services/base_service.dart';
import 'package:Payrio/model/services/media_service.dart';
import 'package:Payrio/model/request/setUpAccountRequest.dart';
import 'package:Payrio/model/response/setUpAccountResponse.dart';
import 'package:Payrio/model/request/signInWithPhoneNumber.dart';
import 'package:Payrio/model/request/verifyOtpChangePass.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/Helper.dart';
import 'response/otpVerifyResponse.dart';

class MediaRepository {
  BaseService _mediaService = MediaService();

  Future<PhoneVerifyResponse> fetchMediaList(String value, PhoneRequest phoneRequest  ) async {
    print(phoneRequest);
    dynamic response = await _mediaService.postResponse(value,phoneRequest);
    final jsonData = response;
    print(jsonData);
    PhoneVerifyResponse mediaList = PhoneVerifyResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<ExistingUserResponse> existingUserData(String value, ExistingUserRequest existingUserRequest  ) async {
    print(existingUserRequest);
    dynamic response = await _mediaService.postResponse(value,existingUserRequest);
    final jsonData = response;
    print(jsonData);
    ExistingUserResponse mediaList = ExistingUserResponse.fromJson(jsonData);
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
  Future<SignInResponse> signInWithPass(String value, SignInRequest signInRequest) async {
    print(signInRequest);
    dynamic response = await _mediaService.postResponse(value,signInRequest);
    print(value);
    final jsonData = response;
    print(jsonData);
    SignInResponse mediaList = SignInResponse.fromJson(jsonData);
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
    final jsonData = response;
    print(jsonData);
    ProfileResponse mediaList = ProfileResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<ProfileResponse> putMultiFormResponse(String value, File file) async {
    dynamic response = await _mediaService.putMultiFormResponse(value, file);
    print(value);
    final jsonData = response;
    print(jsonData);
    ProfileResponse mediaList = ProfileResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<UploadKycDocResponse> postMultiFormResponse(String value, File file, String docType,String imageName) async {
    dynamic response = await _mediaService.postMultiFormResponse(value, file, docType, imageName);
    print(value);
    final jsonData = response;
    print(jsonData);
    UploadKycDocResponse mediaList = UploadKycDocResponse.fromJson(jsonData);
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

  Future<FetchKycDocResponse> fetchKycDocData(String value) async {
    dynamic response = await _mediaService.getResponse(value);
    print(value);
    final jsonData = response;
    print(jsonData);
    FetchKycDocResponse mediaList = FetchKycDocResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<CountryListResponse> fetchCountryList(String value) async {
    dynamic response = await _mediaService.getResponse(value);
    print(value);
    final jsonData = response;
    print(jsonData);
    CountryListResponse mediaList = CountryListResponse.fromJson(jsonData);
    return mediaList;
  }
}
