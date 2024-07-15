import 'dart:io';

import 'package:Payrio/model/apis/api_response.dart';
import 'package:Payrio/model/main_repository.dart';
import 'package:Payrio/model/request/AddMoneyRequest.dart';
import 'package:Payrio/model/request/setUpAccountRequest.dart';
import 'package:Payrio/model/request/signInWithPhoneNumber.dart';
import 'package:Payrio/model/request/transactionListRequest.dart';
import 'package:Payrio/model/request/withdrawRequest.dart';
import 'package:Payrio/model/response/AddMoneyResponse.dart';
import 'package:Payrio/model/response/createOtpForEmailVerifyResponse.dart';
import 'package:Payrio/model/response/dashboardResponse.dart';
import 'package:Payrio/model/response/fetchKycDocResponse.dart';
import 'package:Payrio/model/response/kycStatusResponse.dart';
import 'package:Payrio/model/response/phoneVerifyResponse.dart';
import 'package:Payrio/model/response/profileResponse.dart';
import 'package:Payrio/model/response/setUpAccountResponse.dart';
import 'package:Payrio/model/response/transactionListReponse.dart';
import 'package:Payrio/model/response/uploadKycResponse.dart';
import 'package:Payrio/model/response/withdrawResponse.dart';
import 'package:flutter/cupertino.dart';

import '../model/request/changeOldPasswordRequest.dart';
import '../model/request/createOtpChangePass.dart';
import '../model/request/createOtpEmailVerifyRequest.dart';
import '../model/request/exustingUserRequest.dart';
import '../model/request/signInRequest.dart';
import '../model/request/verifyOtpChangePass.dart';
import '../model/request/verifyOtpEmailVerifyRequest.dart';
import '../model/response/countryListResponse.dart';
import '../model/response/createOtpChangePassResponse.dart';
import '../model/response/existingUserResponse.dart';
import '../model/response/otpVerifyResponse.dart';
import '../model/response/signInResponse.dart';

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
  Future<void> fetchMediaData(String value, PhoneRequest phoneRequest) async {
    _apiResponse = ApiResponse.loading('Fetching artist data');
    //String requestAsString = phoneRequestToString(request);
    notifyListeners();
    try {
      print(phoneRequest.customer.phoneNumber);

      PhoneVerifyResponse phoneVerifyResponse =
          await MainRepository().fetchMediaList(value, phoneRequest);
      print("Yess" + phoneVerifyResponse.mobileOtp.toString());
      if (phoneVerifyResponse.phoneNumber != null) {
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
    _apiResponse = ApiResponse.loading('Fetching artist data');
    //String requestAsString = phoneRequestToString(request);
    notifyListeners();
    try {
      print(existingUserRequest.customer.phoneNumber);

      ExistingUserResponse? existingUserResponse =
          await MainRepository().existingUserData(value, existingUserRequest);
      print("Yess" + existingUserResponse.userFound.toString());
      //_apiResponse = ApiResponse.completed(existingUserResponse);
      if (existingUserResponse.userFound != null) {
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
    _apiResponse = ApiResponse.loading('Fetching artist data');
    print("Yess" + phoneRequest.customer.mobileOtp);
    notifyListeners();
    try {
      print(phoneRequest.customer.phoneNumber);
      OtpVerifyResponse otpVerifyResponse =
          await MainRepository().fetchOtpVerifyData(value, phoneRequest);
      //print("Yess"+ otpVerifyResponse.token.toString());
      //_apiResponse = ApiResponse.completed(otpVerifyResponse);
      if (otpVerifyResponse.phoneNumber != null) {
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

  Future<void> signInWithPass(String value, SignInRequest signInRequest) async {
    _apiResponse = ApiResponse.loading('Fetching artist data');
    print("Yess" + signInRequest.customer.phoneNumber);
    notifyListeners();
    try {
      //print(signInRequest.customer.phoneNumber);
      SignInResponse signInResponse = await MainRepository().signInWithPass(value, signInRequest);
       print("Yess"+ signInResponse.toString());
      //_apiResponse = ApiResponse.completed(signInResponse);
      if (signInResponse != null && signInResponse.email != null) {
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
    _apiResponse = ApiResponse.loading('Fetching artist data');
    print("Yess" + setUpAccountRequest.customer.email);
    notifyListeners();
    try {
      print(setUpAccountRequest.customer.email);
      SetUpAccountResponse setUpAccountResponse = await MainRepository()
          .fetchSetUpScreenData(value, setUpAccountRequest);
      print("Yess" + setUpAccountResponse.email.toString());
      //_apiResponse = ApiResponse.completed(setUpAccountResponse);
      if (setUpAccountResponse.phoneNumber != null) {
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

  Future<void> profileScreenData(String value) async {
    _apiResponse = ApiResponse.loading('Fetching artist data');
    notifyListeners();
    try {
      ProfileResponse profileResponse =
          await MainRepository().ProfileScreenData(value);
      print("Yess ${profileResponse.message}");
      if (profileResponse.userId != null) {
        _apiResponse = ApiResponse.completed(profileResponse);
      } else {
        _apiResponse = ApiResponse.error(profileResponse.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print("Catch $e");
    }
    notifyListeners();
  }

  Future<void> putMultiFormResponse(String value, File file) async {
    _apiResponse = ApiResponse.loading('Fetching artist data');
    notifyListeners();
    try {
      ProfileResponse profileResponse =
          await MainRepository().putMultiFormResponse(value, file);
      print("Yess" + profileResponse.firstName.toString());
      if (profileResponse.userId != null) {
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

  Future<void> postMultiFormResponse(
      String value, File file, String docType, String imageName) async {
    _apiResponse = ApiResponse.loading('Fetching artist data');
    notifyListeners();
    try {
      UploadKycDocResponse uploadKycDocResponse = await MainRepository()
          .postMultiFormResponse(value, file, docType, imageName);
      print("Yess" + uploadKycDocResponse.message.toString());
      if (uploadKycDocResponse.userId != null) {
        _apiResponse = ApiResponse.completed(uploadKycDocResponse);
      } else {
        _apiResponse = ApiResponse.error(uploadKycDocResponse.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> changeOldPasswordData(
      String value, ChangeOldPassRequest changeOldPassRequest) async {
    _apiResponse = ApiResponse.loading('Fetching artist data');
    //print("Yess"+ changeOldPassRequest.customer.email);
    notifyListeners();
    try {
      //print(changeOldPassRequest.customer.email);
      final response = await MainRepository()
          .ChangeWithOldPasswordData(value, changeOldPassRequest);
      //print("Yess"+ setUpAccountResponse.email.toString());
      if (response != null) {
        _apiResponse = ApiResponse.completed(response);
      } else {
        _apiResponse = ApiResponse.error(response.message);
      }    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> CreateOtpChangePass(String value,
      CreateOtpChangePassRequest createOtpChangePassRequest) async {
    _apiResponse = ApiResponse.loading('Fetching artist data');
    //print("Yess"+ changeOldPassRequest.customer.email);
    notifyListeners();
    try {
      print(createOtpChangePassRequest.customer.phoneNumber);

      CreateOtpChangePassResponse createOtpChangePassResponse =
          await MainRepository()
              .CreateOtpChangePass(value, createOtpChangePassRequest);
      print("Yess" + createOtpChangePassResponse.mobileOtp);

      if (createOtpChangePassResponse.mobileOtp != null) {
        _apiResponse = ApiResponse.completed(createOtpChangePassResponse);
      } else {
        _apiResponse = ApiResponse.error(createOtpChangePassResponse.message);
      }    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> VerifyOtpChangePass(
      String value, VerifyOtChangePassRequest verifyOtChangePassRequest) async {
    _apiResponse = ApiResponse.loading('Fetching artist data');
    notifyListeners();
    try {
      final response = await MainRepository()
          .VerifyOtpChangePass(value, verifyOtChangePassRequest);

        //_apiResponse = ApiResponse.completed(response);
      if (response.mobileOtp != null) {
        _apiResponse = ApiResponse.completed(response);
      } else {
        _apiResponse = ApiResponse.error(response.message);
      }
         } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> CreateOtpVerifyEmail(String value,
      CreateOtpEmailVerifyRequest createOtpEmailVerifyRequest) async {
    _apiResponse = ApiResponse.loading('Fetching artist data');
    notifyListeners();
    try {
      print(createOtpEmailVerifyRequest.customer.phoneNumber);

      CreateOtpVerifyEmailResponse createOtpVerifyEmailResponse =
          await MainRepository()
              .CreateOtpVerifyEmail(value, createOtpEmailVerifyRequest);
      print("Yess" + createOtpVerifyEmailResponse.mobileOtp);

      if (createOtpVerifyEmailResponse.userId != null) {
        _apiResponse = ApiResponse.completed(createOtpVerifyEmailResponse);
      } else {
        _apiResponse = ApiResponse.error(createOtpVerifyEmailResponse.message);
      }    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> VerifyOtpVerifyEmail(String value,
      VerifyOtpEmailVerifyRequest verifyOtpEmailVerifyRequest) async {
    _apiResponse = ApiResponse.loading('Fetching artist data');
    notifyListeners();
    try {
      final response = await MainRepository()
          .VerifyOtpVerifyEmail(value, verifyOtpEmailVerifyRequest);
       // _apiResponse = ApiResponse.completed(response);
      if (response.mobileOtp != null) {
        _apiResponse = ApiResponse.completed(response);
      } else {
        _apiResponse = ApiResponse.error(response.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> addMoneyData(String value,
      AddMoneyRequest addMoneyRequest) async {
    _apiResponse = ApiResponse.loading('Fetching artist data');
    notifyListeners();
    try {
      AddMoneyResponse response = await MainRepository().addMoneyData(value, addMoneyRequest);
      print("MainViewModel $response");
      //  _apiResponse = ApiResponse.completed(response);
      if (response.redirectUrl != null) {
        _apiResponse = ApiResponse.completed(response);
      } else {
        _apiResponse = ApiResponse.error(response.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print("MainViewModelError $e");
    }
    notifyListeners();
  }

  Future<void> withDrawData(String value,
      WithdrawRequest withDrawRequest) async {
    _apiResponse = ApiResponse.loading('Fetching artist data');
    notifyListeners();
    try {
      WithDrawResponse response = await MainRepository().withDrawData(value, withDrawRequest);

      //  _apiResponse = ApiResponse.completed(response);
      if (response.currency != null) {
        print("MainViewModel ${response.message}");
        _apiResponse = ApiResponse.completed(response);
      } else {
        print("MainViewModelError ${response.message}");
        _apiResponse = ApiResponse.error("${response.message}");
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print("MainViewModelError $e");
    }
    notifyListeners();
  }

  Future<void> fetchKycDocData(String value) async {
    _apiResponse = ApiResponse.loading('Fetching artist data');
    notifyListeners();
    try {
      FetchKycDocResponse fetchKycDocResponse =
          await MainRepository().fetchKycDocData(value);
      print("Yess" + fetchKycDocResponse.message.toString());

       // _apiResponse = ApiResponse.completed(fetchKycDocResponse);
      if (fetchKycDocResponse.passportImage != null) {
        _apiResponse = ApiResponse.completed(fetchKycDocResponse);
      } else {
        _apiResponse = ApiResponse.error(fetchKycDocResponse.message);
      }
         } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> fetchCountryList(String value) async {
    _apiResponse = ApiResponse.loading('Fetching artist data');
    notifyListeners();
    try {
      CountryListResponse countryListResponse =
          await MainRepository().fetchCountryList(value);
      print("Yess" + countryListResponse.message.toString());

        //_apiResponse = ApiResponse.completed(countryListResponse);
      if (countryListResponse.countries != null) {
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
    _apiResponse = ApiResponse.loading('Fetching artist data');
    notifyListeners();
    try {
      KycStatusResponse kycStatusResponse =
          await MainRepository().kycStatusData(value);
      print("Yess" + kycStatusResponse.message.toString());

        //_apiResponse = ApiResponse.completed(kycStatusResponse);
      if (kycStatusResponse.kycStatus != null) {
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

  Future<void> transactionListData(String value, TransactionListRequest transactionListRequest) async {
    _apiResponse = ApiResponse.loading('Fetching artist data');
    print("Yess ${transactionListRequest.paymentRequestId}");
    notifyListeners();
    try {
      TransactionListResponse transactionListResponse = await MainRepository().transactionListData(value, transactionListRequest);
      if (transactionListResponse != null && transactionListResponse.data != null) {
        _apiResponse = ApiResponse.completed(transactionListResponse);
      } else {
        _apiResponse = ApiResponse.error(transactionListResponse.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print("Transaction List : $e");
    }
    notifyListeners();
  }

  Future<void> dashboardData(String value) async {
    _apiResponse = ApiResponse.loading('Fetching artist data');
    notifyListeners();
    try {
      DashboardResponse dashboardResponse =
      await MainRepository().dashboardData(value);
      print("Yess ${dashboardResponse.message}");
      if (dashboardResponse.customerRecentTxn != null) {
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
