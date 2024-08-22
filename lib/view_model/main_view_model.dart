import 'dart:io';

import 'package:FlutterBasicStructure/model/apis/api_response.dart';
import 'package:FlutterBasicStructure/model/main_repository.dart';
import 'package:FlutterBasicStructure/model/request/setUpAccountRequest.dart';
import 'package:FlutterBasicStructure/model/request/signInWithPhoneNumber.dart';
import 'package:FlutterBasicStructure/model/response/dashboardResponse.dart';
import 'package:FlutterBasicStructure/model/response/fetchKycDocResponse.dart';
import 'package:FlutterBasicStructure/model/response/kycStatusResponse.dart';
import 'package:FlutterBasicStructure/model/response/phoneVerifyResponse.dart';
import 'package:FlutterBasicStructure/model/response/profileResponse.dart';
import 'package:FlutterBasicStructure/model/response/setUpAccountResponse.dart';
import 'package:flutter/cupertino.dart';

import '../model/request/changeOldPasswordRequest.dart';
import '../model/request/createOtpChangePass.dart';
import '../model/request/exustingUserRequest.dart';
import '../model/request/generateTpinRequest.dart';
import '../model/request/signInRequest.dart';
import '../model/request/verifyOtpChangePass.dart';
import '../model/response/countryListResponse.dart';
import '../model/response/createOtpChangePassResponse.dart';
import '../model/response/existingUserResponse.dart';
import '../model/response/generateTpinResponse.dart';
import '../model/response/otpVerifyResponse.dart';

class MainViewModel with ChangeNotifier {
  ApiResponse _apiResponse = ApiResponse.initial('Empty data');

  PhoneVerifyResponse? _media;

  ApiResponse get response {
    return _apiResponse;
  }

  PhoneVerifyResponse? get media {
    return _media;
  }

  /// Call the media service and gets the data of requested media data of
  /// an artist.
  Future<void> PhoneVerifyData(String value, PhoneRequest phoneRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    //String requestAsString = phoneRequestToString(request);
    notifyListeners();
    try {
      print(phoneRequest.customer.phoneNumber);

      PhoneVerifyResponse phoneVerifyResponse =
          await MainRepository().fetchPhoneVerifyResponse(value, phoneRequest);
      print("Yess" + phoneVerifyResponse.mobileOtp.toString());
      if (phoneVerifyResponse.status == 200 || phoneVerifyResponse.status == 201) {
        _apiResponse = ApiResponse.completed(phoneVerifyResponse);
      } else {
        print("viewmodel ${phoneVerifyResponse.message}");
        _apiResponse = ApiResponse.error(phoneVerifyResponse.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> existingUserData(
      String value, ExistingUserRequest existingUserRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    //String requestAsString = phoneRequestToString(request);
    notifyListeners();
    try {
      print(existingUserRequest.customer.phoneNumber);

      ExistingUserResponse? existingUserResponse =
          await MainRepository().existingUserData(value, existingUserRequest);
      print("Yess" + existingUserResponse.userFound.toString());
      //_apiResponse = ApiResponse.completed(existingUserResponse);
      if (existingUserResponse.status == 200 || existingUserResponse.status == 201) {
        _apiResponse = ApiResponse.completed(existingUserResponse);
      } else {
        print("viewmodel ${existingUserResponse.message}");
        _apiResponse = ApiResponse.error(existingUserResponse.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> fetchOtpVerifyData(
      String value, PhoneRequest phoneRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    //print("Yess" + phoneRequest.customer.mobileOtp);
    notifyListeners();
    try {
      //print(phoneRequest.customer.phoneNumber);
      OtpVerifyResponse otpVerifyResponse =
          await MainRepository().fetchOtpVerifyData(value, phoneRequest);
      //print("Yess"+ otpVerifyResponse.token.toString());
      //_apiResponse = ApiResponse.completed(otpVerifyResponse);
      if (otpVerifyResponse.status == 200 || otpVerifyResponse.status == 201) {
        _apiResponse = ApiResponse.completed(otpVerifyResponse);
      } else {
        _apiResponse = ApiResponse.error(otpVerifyResponse.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> generateTpinrequestData(
      String value, GenerateTpinrequest generateTpinrequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    print("Yess" + generateTpinrequest.tpin);
    notifyListeners();
    try {
      GenerateTpinResponse generateTpinResponse = await MainRepository()
          .generateTpinrequestData(value, generateTpinrequest);
      print("Yess" + generateTpinResponse.message.toString());
      //_apiResponse = ApiResponse.completed(otpVerifyResponse);
      if (generateTpinResponse?.status  == 200 || generateTpinResponse.status == 20) {
        _apiResponse = ApiResponse.completed(generateTpinResponse);
      } else {
        _apiResponse = ApiResponse.error(generateTpinResponse?.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> signInWithPass(String value, SignInRequest signInRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    print("Yess" + signInRequest.customer.phoneNumber);
    notifyListeners();
    try {
      //print(signInRequest.customer.phoneNumber);
      ProfileResponse signInResponse =
          await MainRepository().signInWithPass(value, signInRequest);
      print("Yess" + signInResponse.username.toString());
      //_apiResponse = ApiResponse.completed(signInResponse);
      if (signInResponse.status  == 200 || signInResponse.status == 201) {
        _apiResponse = ApiResponse.completed(signInResponse);
      } else {
        _apiResponse = ApiResponse.error(signInResponse.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print("signInResponse $e");
    }
    notifyListeners();
  }

  Future<void> fetchSetUpScreenData(
      String value, SetUpAccountRequest setUpAccountRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    print("Yess" + setUpAccountRequest.customer.email);
    notifyListeners();
    try {
      print(setUpAccountRequest.customer.email);
      SetUpAccountResponse setUpAccountResponse = await MainRepository()
          .fetchSetUpScreenData(value, setUpAccountRequest);
      print("Yess" + setUpAccountResponse.email.toString());
      //_apiResponse = ApiResponse.completed(setUpAccountResponse);
      if (setUpAccountResponse.status  == 200 || setUpAccountResponse.status == 201) {
        _apiResponse = ApiResponse.completed(setUpAccountResponse);
      } else {
        print("viewmodel ${setUpAccountResponse.message}");
        _apiResponse = ApiResponse.error(setUpAccountResponse.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }


  Future<void> putMultiFormResponse(String value, File file ,String firstName,String lastName,String dob) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      ProfileResponse profileResponse =
          await MainRepository().putMultiFormResponse(value, file ,firstName, lastName, dob);
      print("Yess" + profileResponse.message.toString());
      if (profileResponse.status  == 200 || profileResponse.status == 201) {
        _apiResponse = ApiResponse.completed(profileResponse);
      } else {
        _apiResponse = ApiResponse.error(profileResponse.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> changeOldPasswordData(
      String value, ChangeOldPassRequest changeOldPassRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    //print("Yess"+ changeOldPassRequest.customer.email);
    notifyListeners();
    try {
      GenerateTpinResponse generateTpinResponse =
      await MainRepository()
          .ChangeWithOldPasswordData(value, changeOldPassRequest);

      if (generateTpinResponse.status == 200 || generateTpinResponse.status == 201) {
        _apiResponse = ApiResponse.completed(generateTpinResponse);
      } else {
        _apiResponse = ApiResponse.error(generateTpinResponse.message);
      }

    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> CreateOtpChangePass(String value,
      CreateOtpChangePassRequest createOtpChangePassRequest) async {
    _apiResponse = ApiResponse.loading('Loading');

    notifyListeners();
    try {
      print(createOtpChangePassRequest.customer.phoneNumber);

      CreateOtpChangePassResponse createOtpChangePassResponse =
          await MainRepository()
              .CreateOtpChangePass(value, createOtpChangePassRequest);
      print("Yess" + "${createOtpChangePassResponse.mobileOtp}");

      if (createOtpChangePassResponse.mobileOtp != null) {
        _apiResponse = ApiResponse.completed(createOtpChangePassResponse);
      } else {
        _apiResponse = ApiResponse.error(createOtpChangePassResponse.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> VerifyOtpChangePass(
      String value, VerifyOtChangePassRequest verifyOtChangePassRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      final response = await MainRepository()
          .VerifyOtpChangePass(value, verifyOtChangePassRequest);

      _apiResponse = ApiResponse.completed(response);
      /*if (response.message != null) {
        _apiResponse = ApiResponse.completed(response);
      } else {
        _apiResponse = ApiResponse.error(response.message);
      }*/
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> fetchKycDocData(String value) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      FetchKycDocResponse fetchKycDocResponse =
          await MainRepository().fetchKycDocData(value);
      print("Yess" + fetchKycDocResponse.message.toString());

      // _apiResponse = ApiResponse.completed(fetchKycDocResponse);
      if (fetchKycDocResponse.passportImage?.userId != null) {
        _apiResponse = ApiResponse.completed(fetchKycDocResponse);
      } else {
        _apiResponse = ApiResponse.error(fetchKycDocResponse.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print("error ${e}");
    }
    notifyListeners();
  }

  Future<void> fetchCountryList(String value) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      CountryListResponse countryListResponse =
          await MainRepository().fetchCountryList(value);
      print("Yess" + countryListResponse.message.toString());

      //_apiResponse = ApiResponse.completed(countryListResponse);
      if (countryListResponse.status  == 200 || countryListResponse.status == 201) {
        _apiResponse = ApiResponse.completed(countryListResponse);
      } else {
        _apiResponse = ApiResponse.error(countryListResponse.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(" catch ${e}");
    }
    notifyListeners();
  }

  Future<void> kycStatusData(String value) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      KycStatusResponse kycStatusResponse =
          await MainRepository().kycStatusData(value);
      print("Yess" + kycStatusResponse.message.toString());

      //_apiResponse = ApiResponse.completed(kycStatusResponse);
      if (kycStatusResponse.status  == 200 || kycStatusResponse.status == 201) {
        _apiResponse = ApiResponse.completed(kycStatusResponse);
      } else {
        _apiResponse = ApiResponse.error(kycStatusResponse.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> dashboardData(String value) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      DashboardResponse dashboardResponse =
          await MainRepository().dashboardData(value);
      print("Yess ${dashboardResponse.message}");
      if (dashboardResponse.status == 200 || dashboardResponse.status == 201) {
        _apiResponse = ApiResponse.completed(dashboardResponse);
      } else {
        _apiResponse = ApiResponse.error(dashboardResponse.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print("Catch $e");
    }
    notifyListeners();
  }

  void setSelectedMedia(PhoneVerifyResponse? media) {
    _media = media;
    notifyListeners();
  }
}
