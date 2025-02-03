import 'dart:io';

import 'package:BDOne/model/apis/api_response.dart';
import 'package:BDOne/model/main_repository.dart';
import 'package:BDOne/model/request/productListRequest.dart';
import 'package:BDOne/model/request/setUpAccountRequest.dart';
import 'package:BDOne/model/request/signInWithPhoneNumber.dart';
import 'package:BDOne/model/response/cartListReponse.dart';
import 'package:BDOne/model/response/dashboardResponse.dart';
import 'package:BDOne/model/response/deleteCartResponse.dart';
import 'package:BDOne/model/response/fetchKycDocResponse.dart';
import 'package:BDOne/model/response/kycStatusResponse.dart';
import 'package:BDOne/model/response/phoneVerifyResponse.dart';
import 'package:BDOne/model/response/profileResponse.dart';
import 'package:BDOne/model/response/setUpAccountResponse.dart';
import 'package:BDOne/model/response/signUpResponse.dart';
import 'package:flutter/cupertino.dart';

import '../model/request/changeOldPasswordRequest.dart';
import '../model/request/createOtpChangePass.dart';
import '../model/request/driverCurrentLocRequest.dart';
import '../model/request/exustingUserRequest.dart';
import '../model/request/generateTpinRequest.dart';
import '../model/request/requestHistoryListRequest.dart';
import '../model/request/rideRequest.dart';
import '../model/request/signInRequest.dart';
import '../model/request/signUpRequest.dart';
import '../model/request/updateCartRequest.dart';
import '../model/request/vehicleListRequest.dart';
import '../model/request/verifyOtpChangePass.dart';
import '../model/response/countryListResponse.dart';
import '../model/response/createOtpChangePassResponse.dart';
import '../model/response/driverStatusResponse.dart';
import '../model/response/existingUserResponse.dart';
import '../model/response/generateTpinResponse.dart';
import '../model/response/initiateRideResponse.dart';
import '../model/response/otpVerifyResponse.dart';
import '../model/response/productsListReponse.dart';
import '../model/response/requestListResponse.dart';
import '../model/response/signInResponse.dart';
import '../model/response/updateCartListReponse.dart';
import '../model/response/uploadKycResponse.dart';
import '../model/response/vehicleListResponse.dart';

class MainViewModel with ChangeNotifier {
  ApiResponse _apiResponse = ApiResponse.initial('Empty data');

  PhoneVerifyResponse? _media;

  String currencySymbol = "৳";

  ApiResponse get response {
    return _apiResponse;
  }

  PhoneVerifyResponse? get media {
    return _media;
  }

  //Authentication
  Future<void> PhoneVerifyData(PhoneRequest phoneRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    //String requestAsString = phoneRequestToString(request);
    notifyListeners();
    try {
      print(phoneRequest.customer.phoneNumber);

      PhoneVerifyResponse phoneVerifyResponse =
          await MainRepository().fetchPhoneVerifyResponse(phoneRequest);
      if (phoneVerifyResponse.status == 200 ||
          phoneVerifyResponse.status == 201) {
        _apiResponse = ApiResponse.completed(phoneVerifyResponse);
      } else {
        _apiResponse = ApiResponse.error(phoneVerifyResponse.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> signInWithPass(SignInRequest signInRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    print("Yess" + signInRequest.customer.phoneNumber);
    notifyListeners();
    try {
      print(signInRequest.customer.phoneNumber);
      SignInResponse signInResponse =
          await MainRepository().signInWithPass(signInRequest);
      print("ApiResponse ${signInResponse.status}");
      //_apiResponse = ApiResponse.completed(signInResponse);
      if (signInResponse.status == 200 || signInResponse.status == 201) {
        print("ApiResponse ${signInResponse.countryName}");
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

  Future<void> fetchOtpVerifyData(PhoneRequest phoneRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    //print("Yess" + phoneRequest.customer.mobileOtp);
    notifyListeners();
    try {
      //print(phoneRequest.customer.phoneNumber);
      OtpVerifyResponse otpVerifyResponse =
          await MainRepository().fetchOtpVerifyData(phoneRequest);
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

  Future<void> existingUserData(ExistingUserRequest existingUserRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    //String requestAsString = phoneRequestToString(request);
    notifyListeners();
    try {
      print(existingUserRequest.customer.phoneNumber);

      ExistingUserResponse? existingUserResponse =
          await MainRepository().existingUserData(existingUserRequest);
      if (existingUserResponse.status == 200 ||
          existingUserResponse.status == 201) {
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

  Future<void> getVehicleFareListData(
      String value, VehicleListRequest vehicleListRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      VehicleListResponse vehicleListResponse = await MainRepository()
          .getVehicleFareListData(value, vehicleListRequest);
      if (vehicleListResponse.status == 200 ||
          vehicleListResponse.status == 201) {
        _apiResponse = ApiResponse.completed(vehicleListResponse);
      } else {
        _apiResponse = ApiResponse.error(vehicleListResponse.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> createRideRequestApi(
      String value, RideRequest rideRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    //print("Yess" + phoneRequest.customer.mobileOtp);
    notifyListeners();
    try {
      //print(phoneRequest.customer.phoneNumber);
      InitiateRideResponse response =
          await MainRepository().createRideRequestApi(value, rideRequest);
      //print("Yess"+ otpVerifyResponse.token.toString());
      //_apiResponse = ApiResponse.completed(otpVerifyResponse);
      if (response.status == 200 || response.status == 201) {
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


  Future<void> getRequestHistoryListData(String value,RequestHistoryListRequest requestHistoryListRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      RequestListResponse requestListResponse =
      await MainRepository().getRequestHistoryListData(value,requestHistoryListRequest);
      print("Yess ${requestListResponse.message}");
      if (requestListResponse.status == 200 || requestListResponse.status == 201) {
        _apiResponse = ApiResponse.completed(requestListResponse);
      } else {
        _apiResponse = ApiResponse.error(requestListResponse.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print("Catch $e");
    }
    notifyListeners();
  }



  Future<void> getDriverStatus(
      String value, DriverCurrentLocRequest driverCurrentLocRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    //print("Yess" + phoneRequest.customer.mobileOtp);
    notifyListeners();
    try {
      //print(phoneRequest.customer.phoneNumber);
      DriverStatusResponse driverStatusResponse = await MainRepository()
          .getDriverStatus(value, driverCurrentLocRequest);
      //print("Yess"+ otpVerifyResponse.token.toString());
      //_apiResponse = ApiResponse.completed(otpVerifyResponse);
      if (driverStatusResponse.status == 200 ||
          driverStatusResponse.status == 201) {
        _apiResponse = ApiResponse.completed(driverStatusResponse);
      } else {
        _apiResponse = ApiResponse.error(driverStatusResponse.message);
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
      if (generateTpinResponse.status == 200 ||
          generateTpinResponse.status == 20) {
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

  Future<void> signUpUsingMobileApi(
      String value, SignUpRequest signUpRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    print("Yess" + signUpRequest.customer.phoneNumber);
    notifyListeners();
    try {
      //print(signInRequest.customer.phoneNumber);
      SignUpResponse signUpResponse =
          await MainRepository().signUpUsingMobileApi(value, signUpRequest);
      print("Yess" + signUpResponse.message.toString());
      //_apiResponse = ApiResponse.completed(signInResponse);
      if (signUpResponse.status == 200 || signUpResponse.status == 201) {
        _apiResponse = ApiResponse.completed(signUpResponse);
      } else {
        _apiResponse = ApiResponse.error(signUpResponse.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print("signInResponse $e");
    }
    notifyListeners();
  }

  Future<void> fetchSetUpScreenData(
      SetUpAccountRequest setUpAccountRequest, String token) async {
    _apiResponse = ApiResponse.loading('Loading');
    print("Yess" + setUpAccountRequest.customer.email);
    notifyListeners();
    try {
      //print(setUpAccountRequest.customer.email);
      SetUpAccountResponse setUpAccountResponse = await MainRepository()
          .fetchSetUpScreenData(setUpAccountRequest, token);
      print("Yess" + setUpAccountResponse.email.toString());
      //_apiResponse = ApiResponse.completed(setUpAccountResponse);
      if (setUpAccountResponse.status == 200 ||
          setUpAccountResponse.status == 201) {
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

  Future<void> clearCartApi() async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      //print(setUpAccountRequest.customer.email);
      DeleteCartResponse response = await MainRepository().clearCartApi();
      print("Yess" + response.data.toString());
      //_apiResponse = ApiResponse.completed(setUpAccountResponse);
      if (response.status == 200 || response.status == 201) {
        _apiResponse = ApiResponse.completed(response);
      } else {
        print("viewmodel ${response.message}");
        _apiResponse = ApiResponse.error(response.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> putMultiFormResponse(String value, File file, String firstName,
      String lastName, String dob) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      ProfileResponse profileResponse = await MainRepository()
          .putMultiFormResponse(value, file, firstName, lastName, dob);
      print("Yess" + profileResponse.message.toString());
      if (profileResponse.status == 200 || profileResponse.status == 201) {
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
      GenerateTpinResponse generateTpinResponse = await MainRepository()
          .ChangeWithOldPasswordData(value, changeOldPassRequest);

      if (generateTpinResponse.status == 200 ||
          generateTpinResponse.status == 201) {
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

  Future<void> fetchKycDocData() async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      FetchKycDocResponse fetchKycDocResponse =
          await MainRepository().fetchKycDocData();
      print("FetchKycDocData" + fetchKycDocResponse.message.toString());

      // _apiResponse = ApiResponse.completed(fetchKycDocResponse);
      if (fetchKycDocResponse.passportImage?.customerId != null) {
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

  Future<void> fetchCategoryListApi() async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      CategoryListResponse countryListResponse =
          await MainRepository().fetchCategoryListApi();
      print("Yess" + countryListResponse.message.toString());

      //_apiResponse = ApiResponse.completed(countryListResponse);
      if (countryListResponse.status == 200 ||
          countryListResponse.status == 201) {
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

  Future<void> dashboardData() async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      DashboardResponse dashboardResponse =
          await MainRepository().dashboardData();
      print("DashboardData ${dashboardResponse.message}");
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

  Future<void> getProductsFromCategoryApi(
      String value, ProductListRequest request) async {
    _apiResponse = ApiResponse.loading('Loading');
    print("TransactionListData ${request.foodCategoryId}");
    notifyListeners();
    try {
      ProductsListResponse transactionListResponse =
          await MainRepository().getProductsFromCategoryApi(value, request);
      if (transactionListResponse.status == 200 ||
          transactionListResponse.status == 201) {
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

  Future<void> updateCartDataApi(UpdateCartRequest request) async {
    _apiResponse = ApiResponse.loading('Loading');
    print("TransactionListData ${request.type}");
    notifyListeners();
    try {
      UpdateCartListResponse response =
          await MainRepository().updateCartDataApi(request);
      if (response.status == 200 || response.status == 201) {
        _apiResponse = ApiResponse.completed(response);
      } else {
        _apiResponse = ApiResponse.error(response.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print("Transaction List : $e");
    }
    notifyListeners();
  }

  void setSelectedMedia(PhoneVerifyResponse? media) {
    _media = media;
    notifyListeners();
  }

  Future<void> postMultiFormResponse(
      String value, File imgFile, String docType, File videoFile) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      UploadKycDocResponse uploadKycDocResponse = await MainRepository()
          .postMultiFormResponse(value, imgFile, docType, videoFile);
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

  Future<void> kycStatusData() async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      KycStatusResponse kycStatusResponse =
          await MainRepository().kycStatusData();
      print("KycStatusData" + kycStatusResponse.message.toString());

      //_apiResponse = ApiResponse.completed(kycStatusResponse);
      if (kycStatusResponse.status == 200 || kycStatusResponse.status == 201) {
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

  Future<void> getCartDataListApi() async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      CartListResponse response = await MainRepository().getCartDataListApi();
      print("KycStatusData" + response.message.toString());

      //_apiResponse = ApiResponse.completed(kycStatusResponse);
      if (response.status == 200 || response.status == 201) {
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
}
