import 'dart:io';

import 'package:BDOne/model/request/changeOldPasswordRequest.dart';
import 'package:BDOne/model/request/createOtpChangePass.dart';
import 'package:BDOne/model/request/driverCurrentLocRequest.dart';
import 'package:BDOne/model/request/exustingUserRequest.dart';
import 'package:BDOne/model/request/generateTpinRequest.dart';
import 'package:BDOne/model/request/productListRequest.dart';
import 'package:BDOne/model/request/rideRequest.dart';
import 'package:BDOne/model/request/setUpAccountRequest.dart';
import 'package:BDOne/model/request/signInRequest.dart';
import 'package:BDOne/model/request/signInWithPhoneNumber.dart';
import 'package:BDOne/model/request/signUpRequest.dart';
import 'package:BDOne/model/request/updateCartRequest.dart';
import 'package:BDOne/model/request/vehicleListRequest.dart';
import 'package:BDOne/model/request/verifyOtpChangePass.dart';
import 'package:BDOne/model/response/cartListReponse.dart';
import 'package:BDOne/model/response/countryListResponse.dart';
import 'package:BDOne/model/response/createOtpChangePassResponse.dart';
import 'package:BDOne/model/response/dashboardResponse.dart';
import 'package:BDOne/model/response/driverStatusResponse.dart';
import 'package:BDOne/model/response/existingUserResponse.dart';
import 'package:BDOne/model/response/fetchKycDocResponse.dart';
import 'package:BDOne/model/response/generateTpinResponse.dart';
import 'package:BDOne/model/response/initiateRideResponse.dart';
import 'package:BDOne/model/response/kycStatusResponse.dart';
import 'package:BDOne/model/response/otpVerifyResponse.dart';
import 'package:BDOne/model/response/phoneVerifyResponse.dart';
import 'package:BDOne/model/response/productsListReponse.dart';
import 'package:BDOne/model/response/profileResponse.dart';
import 'package:BDOne/model/response/setUpAccountResponse.dart';
import 'package:BDOne/model/response/signInResponse.dart';
import 'package:BDOne/model/response/signUpResponse.dart';
import 'package:BDOne/model/response/updateCartListReponse.dart';
import 'package:BDOne/model/response/uploadKycResponse.dart';
import 'package:BDOne/model/response/vehicleListResponse.dart';
import 'package:BDOne/model/services/api/base_service.dart';
import 'package:BDOne/model/services/api/bd_one_api_service.dart';
import 'package:BDOne/model/services/remote/BdOneApiServicesImpl.dart';

class MainRepository {
  BaseService _BDOneService = BdOneApiService();
  BdOneApiServicesImpl _ApiServices = BdOneApiServicesImpl();

  //FetchPhoneVerifyResponse
  Future<PhoneVerifyResponse> fetchPhoneVerifyResponse(
      PhoneRequest phoneRequest) async {
    print("Api: FetchPhoneVerifyResponse");
    dynamic response =
        await _ApiServices.fetchPhoneVerifyResponseApi(phoneRequest);
    return response;
  }


  //FetchOtpVerifyData
  Future<OtpVerifyResponse> fetchOtpVerifyData(
      PhoneRequest phoneRequest) async {
    print("Api: FetchOtpVerifyData");
    dynamic response = await _ApiServices.fetchOtpVerifyDataApi(phoneRequest);
    return response;
  }


  //ExistingUserData
  Future<ExistingUserResponse> existingUserData(
      ExistingUserRequest existingUserRequest) async {
    print("Api: ExistingUserData");
    dynamic response =
        await _ApiServices.existingUserDataApi(existingUserRequest);
    return response;
  }

  //ProductsListData
  Future<ProductsListResponse> getProductsFromCategoryApi(
      String value, ProductListRequest productListRequest) async {
    print("Api: TransactionListData");
    dynamic response =
    await _ApiServices.getProductsFromCategoryApi(productListRequest);
    return response;
  }

  //UpdateCartDataApi
  Future<UpdateCartListResponse> updateCartDataApi(UpdateCartRequest request) async {
    print("Api: UpdateCartDataApi");
    dynamic response =
    await _ApiServices.updateCartDataApi(request);
    return response;
  }

  Future<VehicleListResponse> getVehicleFareListData(
      String value, VehicleListRequest vehicleListRequest) async {
    print(vehicleListRequest);
    dynamic response =
        await _BDOneService.postResponse(value, vehicleListRequest);
    print(value);
    final jsonData = response;
    print(jsonData);
    VehicleListResponse mediaList = VehicleListResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<InitiateRideResponse> createRideRequestApi(
      String value, RideRequest rideRequest) async {
    print(rideRequest);
    dynamic response = await _BDOneService.postResponse(value, rideRequest);
    print(value);
    final jsonData = response;
    print(jsonData);
    InitiateRideResponse mediaList = InitiateRideResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<DriverStatusResponse> getDriverStatus(
      String value, DriverCurrentLocRequest driverCurrentLocRequest) async {
    print(driverCurrentLocRequest);
    dynamic response =
        await _BDOneService.postResponse(value, driverCurrentLocRequest);
    print(value);
    final jsonData = response;
    print(jsonData);
    DriverStatusResponse mediaList = DriverStatusResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<GenerateTpinResponse> generateTpinrequestData(
      String value, GenerateTpinrequest generateTpinrequest) async {
    print(generateTpinrequest);
    dynamic response =
        await _BDOneService.postResponse(value, generateTpinrequest);
    print(value);
    final jsonData = response;
    print(jsonData);
    GenerateTpinResponse generateTpinResponse =
        GenerateTpinResponse.fromJson(jsonData);
    return generateTpinResponse;
  }

  //SignInWithPass
  Future<SignInResponse> signInWithPass(SignInRequest signInRequest) async {
    print("Api: SignInWithPass");
    dynamic response = await _ApiServices.signInWithPassApi(signInRequest);
    return response;
  }

  Future<SignUpResponse> signUpUsingMobileApi(
      String value, SignUpRequest signUpRequest) async {
    print(signUpRequest);
    dynamic response = await _BDOneService.postResponse(value, signUpRequest);
    print(value);
    final jsonData = response;
    print(" ${jsonData}");
    SignUpResponse mediaList = SignUpResponse.fromJson(jsonData);
    return mediaList;
  }

  //FetchSetUpScreenData
  Future<SetUpAccountResponse> fetchSetUpScreenData(
      SetUpAccountRequest setUpAccountRequest, String token) async {
    print("Token: $token");
    print("Api: FetchSetUpScreenData");
    dynamic response =
    await _ApiServices.fetchSetUpScreenDataApi(setUpAccountRequest, token);
    return response;
  }

  Future<ProfileResponse> putMultiFormResponse(String value, File file,
      String firstName, String lastName, String dob) async {
    dynamic response = await _BDOneService.putMultiFormResponse(
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
        await _BDOneService.putResponse(value, changeOldPassRequest);
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
        await _BDOneService.postResponse(value, createOtpChangePassRequest);
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
        await _BDOneService.postResponse(value, verifyOtChangePassRequest);
    print(value);
    final jsonData = response;
    print(jsonData);
    return response;
  }

  //FetchKycDocData
  Future<FetchKycDocResponse> fetchKycDocData() async {
    print("Api: FetchKycDocData");
    dynamic response = await _ApiServices.fetchKycDocDataApi();
    return response;
  }

  //FetchCountryList
  Future<CategoryListResponse> fetchCategoryListApi() async {
    print("Api: FetchCountryList");
    dynamic response = await _ApiServices.fetchCategoryListApi();
    return response;
  }

  //DashboardData
  Future<DashboardResponse> dashboardData() async {
    print("Api: DashboardData");
    dynamic response = await _ApiServices.dashboardDataApi();
    return response;
  }

  Future<UploadKycDocResponse> postMultiFormResponse(
      String value, File imageFile, String docType, File videoFile) async {
    dynamic response = await _BDOneService.postMultiFormResponse(
        value, imageFile, docType, videoFile);
    print(value);
    final jsonData = response;
    print(jsonData);
    UploadKycDocResponse mediaList = UploadKycDocResponse.fromJson(jsonData);
    return mediaList;
  }


  //KycStatusData
  Future<KycStatusResponse> kycStatusData() async {
    print("Api: KycStatusData");
    dynamic response = await _ApiServices.kycStatusDataApi();
    return response;
  }

  //GetCartDataListApi
  Future<CartListResponse> getCartDataListApi() async {
    print("Api: KycStatusData");
    dynamic response = await _ApiServices.getCartDataListApi();
    return response;
  }

}
