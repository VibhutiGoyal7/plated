import 'dart:io';

import 'package:BDPass/model/request/changeOldPasswordRequest.dart';
import 'package:BDPass/model/request/createOtpChangePass.dart';
import 'package:BDPass/model/request/exustingUserRequest.dart';
import 'package:BDPass/model/request/generateTpinRequest.dart';
import 'package:BDPass/model/request/setUpAccountRequest.dart';
import 'package:BDPass/model/request/signInRequest.dart';
import 'package:BDPass/model/request/signInWithPhoneNumber.dart';
import 'package:BDPass/model/request/signUpRequest.dart';
import 'package:BDPass/model/request/verifyOtpChangePass.dart';
import 'package:BDPass/model/response/countryListResponse.dart';
import 'package:BDPass/model/response/createOtpChangePassResponse.dart';
import 'package:BDPass/model/response/dashboardResponse.dart';
import 'package:BDPass/model/response/existingUserResponse.dart';
import 'package:BDPass/model/response/fetchKycDocResponse.dart';
import 'package:BDPass/model/response/generateTpinResponse.dart';
import 'package:BDPass/model/response/kycStatusResponse.dart';
import 'package:BDPass/model/response/phoneVerifyResponse.dart';
import 'package:BDPass/model/response/profileResponse.dart';
import 'package:BDPass/model/response/setUpAccountResponse.dart';
import 'package:BDPass/model/response/signUpResponse.dart';
import 'package:BDPass/model/services/base_service.dart';
import 'package:BDPass/model/services/bd_pass_service.dart';

import 'response/otpVerifyResponse.dart';

class MainRepository {
  BaseService _BDPassService = BDPassService();

  Future<PhoneVerifyResponse> fetchPhoneVerifyResponse(
      String value, PhoneRequest phoneRequest) async {
    print(phoneRequest);
    dynamic response = await _BDPassService.postResponse(value, phoneRequest);
    final jsonData = response;
    print(jsonData);
    PhoneVerifyResponse mediaList = PhoneVerifyResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<ExistingUserResponse> existingUserData(
      String value, ExistingUserRequest existingUserRequest) async {
    print(existingUserRequest);
    dynamic response =
        await _BDPassService.postResponse(value, existingUserRequest);
    final jsonData = response;
    print(jsonData);
    ExistingUserResponse mediaList = ExistingUserResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<OtpVerifyResponse> fetchOtpVerifyData(
      String value, PhoneRequest phoneRequest) async {
    print(phoneRequest);
    dynamic response = await _BDPassService.postResponse(value, phoneRequest);
    print(value);
    final jsonData = response;
    print(jsonData);
    OtpVerifyResponse mediaList = OtpVerifyResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<GenerateTpinResponse> generateTpinrequestData(
      String value, GenerateTpinrequest generateTpinrequest) async {
    print(generateTpinrequest);
    dynamic response =
        await _BDPassService.postResponse(value, generateTpinrequest);
    print(value);
    final jsonData = response;
    print(jsonData);
    GenerateTpinResponse generateTpinResponse =
        GenerateTpinResponse.fromJson(jsonData);
    return generateTpinResponse;
  }

  Future<ProfileResponse> signInWithPass(
      String value, SignInRequest signInRequest) async {
    print(signInRequest);
    dynamic response = await _BDPassService.postResponse(value, signInRequest);
    print(value);
    final jsonData = response;
    print(" ${jsonData}");
    ProfileResponse mediaList = ProfileResponse.fromSignIn(jsonData);
    return mediaList;
  }

  Future<SignUpResponse> signUpUsingMobileApi(
      String value, SignUpRequest signUpRequest) async {
    print(signUpRequest);
    dynamic response = await _BDPassService.postResponse(value, signUpRequest);
    print(value);
    final jsonData = response;
    print(" ${jsonData}");
    SignUpResponse mediaList = SignUpResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<SetUpAccountResponse> fetchSetUpScreenData(
      String value, SetUpAccountRequest setUpAccountRequest) async {
    print(setUpAccountRequest);
    dynamic response =
        await _BDPassService.putResponse(value, setUpAccountRequest);
    print(value);
    final jsonData = response;
    print(jsonData);
    SetUpAccountResponse mediaList = SetUpAccountResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<ProfileResponse> putMultiFormResponse(String value, File file,
      String firstName, String lastName, String dob) async {
    dynamic response = await _BDPassService.putMultiFormResponse(
        value, file, firstName, lastName, dob);
    print(value);
    final jsonData = response;
    print(jsonData);
    ProfileResponse mediaList = ProfileResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<GenerateTpinResponse> ChangeWithOldPasswordData(
      String value, ChangeOldPassRequest changeOldPassRequest) async {
    print(changeOldPassRequest);
    dynamic response =
        await _BDPassService.putResponse(value, changeOldPassRequest);
    print(value);
    final jsonData = response;
    GenerateTpinResponse mediaList = GenerateTpinResponse.fromJson(jsonData);
    print(jsonData);
    return mediaList;
  }

  Future<CreateOtpChangePassResponse> CreateOtpChangePass(String value,
      CreateOtpChangePassRequest createOtpChangePassRequest) async {
    print(createOtpChangePassRequest);
    dynamic response =
        await _BDPassService.postResponse(value, createOtpChangePassRequest);
    print(value);
    final jsonData = response;
    print(jsonData);
    CreateOtpChangePassResponse mediaList =
        CreateOtpChangePassResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<dynamic> VerifyOtpChangePass(
      String value, VerifyOtChangePassRequest verifyOtChangePassRequest) async {
    print(verifyOtChangePassRequest);
    dynamic response =
        await _BDPassService.postResponse(value, verifyOtChangePassRequest);
    print(value);
    final jsonData = response;
    print(jsonData);
    return response;
  }

  Future<FetchKycDocResponse> fetchKycDocData(String value) async {
    dynamic response = await _BDPassService.getResponse(value);
    print(value);
    final jsonData = response;
    print(jsonData);
    FetchKycDocResponse mediaList = FetchKycDocResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<CountryListResponse> fetchCountryList(String value) async {
    dynamic response = await _BDPassService.getResponse(value);
    print(value);
    final jsonData = response;
    print(jsonData);
    CountryListResponse mediaList = CountryListResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<KycStatusResponse> kycStatusData(String value) async {
    dynamic response = await _BDPassService.getResponse(value);
    print(value);
    final jsonData = response;
    //print("jsonData $jsonData");
    KycStatusResponse mediaList = KycStatusResponse.fromJson(jsonData);
    //print("object ${mediaList.message}");
    return mediaList;
  }

  Future<DashboardResponse> dashboardData(String value) async {
    dynamic response = await _BDPassService.getResponse(value);
    print(value);
    final jsonData = response;
    //print("jsonData $jsonData");
    DashboardResponse mediaList = DashboardResponse.fromJson(jsonData);
    //print("object ${mediaList.message}");
    return mediaList;
  }
}
