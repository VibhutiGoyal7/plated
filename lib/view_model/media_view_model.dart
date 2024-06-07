import 'package:flutter/cupertino.dart';
import 'package:mvvm_flutter_app/model/apis/api_response.dart';
import 'package:mvvm_flutter_app/model/media.dart';
import 'package:mvvm_flutter_app/model/media_repository.dart';
import 'package:mvvm_flutter_app/model/setUpAccountRequest.dart';
import 'package:mvvm_flutter_app/model/setUpAccountResponse.dart';
import 'package:mvvm_flutter_app/model/signInWithPhoneNumber.dart';

import '../model/otpVerifyResponse.dart';

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

  void setSelectedMedia(Media? media) {
    _media = media;
    notifyListeners();
  }
}
