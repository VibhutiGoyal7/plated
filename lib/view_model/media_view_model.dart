import 'package:flutter/cupertino.dart';
import 'package:mvvm_flutter_app/model/apis/api_response.dart';
import 'package:mvvm_flutter_app/model/response/createOtpForEmailVerifyResponse.dart';
import 'package:mvvm_flutter_app/model/media.dart';
import 'package:mvvm_flutter_app/model/media_repository.dart';
import 'package:mvvm_flutter_app/model/response/profileResponse.dart';
import 'package:mvvm_flutter_app/model/request/setUpAccountRequest.dart';
import 'package:mvvm_flutter_app/model/response/setUpAccountResponse.dart';
import 'package:mvvm_flutter_app/model/request/signInWithPhoneNumber.dart';

import '../model/request/changeOldPasswordRequest.dart';
import '../model/request/createOtpChangePass.dart';
import '../model/request/createOtpEmailVerifyRequest.dart';
import '../model/request/verifyOtpEmailVerifyRequest.dart';
import '../model/response/createOtpChangePassResponse.dart';
import '../model/response/otpVerifyResponse.dart';
import '../model/request/verifyOtpChangePass.dart';

class MediaViewModel with ChangeNotifier {
  ApiResponse _apiResponse = ApiResponse.initial('Empty data');

  Media? _media;

  ApiResponse get response {
    return _apiResponse;
  }

  Media? get media {
    return _media;
  }

  /// Call the media service and gets the data of requested media data of
  /// an artist.
    Future<void> fetchMediaData(String value, PhoneRequest phoneRequest) async {
    _apiResponse = ApiResponse.loading('Fetching artist data');
    //String requestAsString = phoneRequestToString(request);
    notifyListeners();
    try {
      print(phoneRequest.customer.phoneNumber);

      Media mediaList = await MediaRepository().fetchMediaList(value,phoneRequest);
      print("Yess"+ mediaList.mobileOtp.toString());
      _apiResponse = ApiResponse.completed(mediaList);
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> fetchOtpVerifyData(String value, PhoneRequest phoneRequest) async {
    _apiResponse = ApiResponse.loading('Fetching artist data');
    print("Yess"+ phoneRequest.customer.mobileOtp);
    notifyListeners();
    try {
      print(phoneRequest.customer.phoneNumber);
      OtpVerifyResponse otpVerifyResponse = await MediaRepository().fetchOtpVerifyData(value,phoneRequest);
      print("Yess"+ otpVerifyResponse.token.toString());
      _apiResponse = ApiResponse.completed(otpVerifyResponse);
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> fetchSetUpScreenData(String value, SetUpAccountRequest setUpAccountRequest) async {
    _apiResponse = ApiResponse.loading('Fetching artist data');
    print("Yess"+ setUpAccountRequest.customer.email);
    notifyListeners();
    try {
      print(setUpAccountRequest.customer.email);
      SetUpAccountResponse setUpAccountResponse = await MediaRepository().fetchSetUpScreenData(value, setUpAccountRequest);
      print("Yess"+ setUpAccountResponse.email.toString());
      _apiResponse = ApiResponse.completed(setUpAccountResponse);
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> profileScreenData(String value) async {
    _apiResponse = ApiResponse.loading('Fetching artist data');
    //print("Yess"+ phoneRequest.customer.mobileOtp);
    notifyListeners();
    try {
      //print(phoneRequest.customer.phoneNumber);
      ProfileResponse profileResponse = await MediaRepository().ProfileScreenData(value);
      print("Yess"+ profileResponse.firstName.toString());
      _apiResponse = ApiResponse.completed(profileResponse);
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> changeOldPasswordData(String value, ChangeOldPassRequest changeOldPassRequest) async {
    _apiResponse = ApiResponse.loading('Fetching artist data');
    //print("Yess"+ changeOldPassRequest.customer.email);
    notifyListeners();
    try {
      //print(changeOldPassRequest.customer.email);
      final response = await MediaRepository().ChangeWithOldPasswordData(value, changeOldPassRequest);
      //print("Yess"+ setUpAccountResponse.email.toString());
      _apiResponse = ApiResponse.completed(response);
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> CreateOtpChangePass(String value, CreateOtpChangePassRequest createOtpChangePassRequest) async {
    _apiResponse = ApiResponse.loading('Fetching artist data');
    //print("Yess"+ changeOldPassRequest.customer.email);
    notifyListeners();
    try {
      print(createOtpChangePassRequest.customer.phoneNumber);

      CreateOtpChangePassResponse createOtpChangePassResponse = await MediaRepository().CreateOtpChangePass(value, createOtpChangePassRequest);
      print("Yess"+ createOtpChangePassResponse.mobileOtp);
      _apiResponse = ApiResponse.completed(createOtpChangePassResponse);
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> VerifyOtpChangePass(String value, VerifyOtChangePassRequest verifyOtChangePassRequest) async {
    _apiResponse = ApiResponse.loading('Fetching artist data');
    notifyListeners();
    try {
      final response = await MediaRepository().VerifyOtpChangePass(value, verifyOtChangePassRequest);
      _apiResponse = ApiResponse.completed(response);
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> CreateOtpVerifyEmail(String value, CreateOtpEmailVerifyRequest createOtpEmailVerifyRequest) async {
    _apiResponse = ApiResponse.loading('Fetching artist data');
    notifyListeners();
    try {
      print(createOtpEmailVerifyRequest.customer.phoneNumber);

      CreateOtpVerifyEmailResponse createOtpVerifyEmailResponse = await MediaRepository().CreateOtpVerifyEmail(value, createOtpEmailVerifyRequest);
      print("Yess"+ createOtpVerifyEmailResponse.mobileOtp);
      _apiResponse = ApiResponse.completed(createOtpVerifyEmailResponse);
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> VerifyOtpVerifyEmail(String value, VerifyOtpEmailVerifyRequest verifyOtpEmailVerifyRequest) async {
    _apiResponse = ApiResponse.loading('Fetching artist data');
    notifyListeners();
    try {
      final response = await MediaRepository().VerifyOtpVerifyEmail(value, verifyOtpEmailVerifyRequest);
      _apiResponse = ApiResponse.completed(response);
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  void setSelectedMedia(Media? media) {
    _media = media;
    notifyListeners();
  }
}
