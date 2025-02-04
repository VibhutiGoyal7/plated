import 'package:Plated/model/request/productListRequest.dart';
import 'package:Plated/model/response/cartListReponse.dart';
import 'package:Plated/model/response/countryListResponse.dart';
import 'package:Plated/model/response/productsListReponse.dart';

import '../../request/exustingUserRequest.dart';
import '../../request/setUpAccountRequest.dart';
import '../../request/signInRequest.dart';
import '../../request/signInWithPhoneNumber.dart';
import '../../request/updateCartRequest.dart';
import '../../response/dashboardResponse.dart';
import '../../response/deleteCartResponse.dart';
import '../../response/emptyResponse.dart';
import '../../response/existingUserResponse.dart';
import '../../response/fetchKycDocResponse.dart';
import '../../response/kycStatusResponse.dart';
import '../../response/otpVerifyResponse.dart';
import '../../response/phoneVerifyResponse.dart';
import '../../response/setUpAccountResponse.dart';
import '../../response/signInResponse.dart';
import '../../response/updateCartListReponse.dart';
import '../api/bd_one_api_service.dart';
import 'PlatedApiServices.dart';

class PlatedApiServicesImpl implements PlatedApiServices {
  PlatedApiService _PlatedService = PlatedApiService();
  static const GET = 'GET';
  static const POST = 'POST';
  static const PUT = 'PUT';
  static const DELETE = 'DELETE';

  Future<T> _fetchData<T>(
    String url, {
    dynamic requestBody,
    required T Function(Map<String, dynamic>) fromJson,
    String method = 'GET',
    bool isSetupAccount = false,
    String token = '',
  }) async {
    print("_fetchData Token: $isSetupAccount $token $method");
    try {
      // Decide which HTTP method to use (GET, POST, PUT)
      late final dynamic response;
      if (method == GET) {
        response = await _PlatedService.getResponse(url);
      } else if (method == POST) {
        response = await _PlatedService.postResponse(url, requestBody);
      } else if (method == PUT && !isSetupAccount) {
        response = await _PlatedService.putResponse(
            url, requestBody); // Assuming you have a putResponse method
      } else if (method == PUT && isSetupAccount) {
        print("method Token: $isSetupAccount $token");
        print("Request: $requestBody");
        response = await _PlatedService.putSetUpAccountResponse(
            url, requestBody, token); // Assuming you have a putResponse method
      } else if (method == DELETE) {
        print("DELETE: $DELETE");
        response = await _PlatedService.deleteResponse(url);
      } else {
        throw Exception('Unsupported HTTP method: $method');
      }

      // If the response is null, throw an exception
      if (response != null) {
        // Parse and return the response using the provided fromJson function
        return fromJson(response);
      } else {
        throw Exception("No response received");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  @override
  Future<PhoneVerifyResponse> fetchPhoneVerifyResponseApi(
      PhoneRequest phoneRequest) async {
    return _fetchData<PhoneVerifyResponse>(
      'api/v1/app/temp_customers/initiate_customer',
      requestBody: phoneRequest,
      method: POST,
      fromJson: (json) => PhoneVerifyResponse.fromJson(json),
    );
  }

  @override
  Future<ExistingUserResponse> existingUserDataApi(
      ExistingUserRequest existingUserRequest) async {
    return _fetchData<ExistingUserResponse>(
      'api/v1/app/customers/check_customer_existance',
      requestBody: existingUserRequest,
      method: POST,
      fromJson: (json) => ExistingUserResponse.fromJson(json),
    );
  }

  @override
  Future<OtpVerifyResponse> fetchOtpVerifyDataApi(
      PhoneRequest phoneRequest) async {
    return _fetchData<OtpVerifyResponse>(
      'api/v1/app/temp_customers/verify_customer_mobile_otp_for_signup',
      requestBody: phoneRequest,
      method: POST,
      fromJson: (json) => OtpVerifyResponse.fromJson(json),
    );
  }

  @override
  Future<SetUpAccountResponse> fetchSetUpScreenDataApi(
      SetUpAccountRequest setUpAccountRequest, String token) async {
    print("Token: $token");
    print("SetUpAccountRequest: ${setUpAccountRequest.customer.email}");
    return _fetchData<SetUpAccountResponse>(
      'api/v1/app/customers/update_customer',
      method: PUT,
      token: token,
      isSetupAccount: true,
      requestBody: setUpAccountRequest,
      fromJson: (json) => SetUpAccountResponse.fromJson(json),
    );
  }


  @override
  Future<SignInResponse> signInWithPassApi(SignInRequest signInRequest) async {
    return _fetchData<SignInResponse>(
      'api/v1/app/customers/sign_in',
      requestBody: signInRequest,
      method: POST,
      fromJson: (json) => SignInResponse.fromJson(json),
    );
  }

  @override
  Future<CategoryListResponse> fetchCategoryListApi() async {
    return _fetchData<CategoryListResponse>(
      'api/v1/app/menu_items/category_list',
      method: GET,
      fromJson: (json) => CategoryListResponse.fromJson(json),
    );
  }

  @override
  Future<FetchKycDocResponse> fetchKycDocDataApi() {
    return _fetchData<FetchKycDocResponse>(
      'api/v1/app/customers/customer_uploaded_documents',
      method: GET,
      fromJson: (json) => FetchKycDocResponse.fromJson(json),
    );
  }

  @override
  Future<ProductsListResponse> getProductsFromCategoryApi(
      ProductListRequest request) async {
    return _fetchData<ProductsListResponse>(
      'api/v1/app/menu_items/get_list',
      method: POST,
      requestBody: request,
      fromJson: (json) => ProductsListResponse.fromJson(json),
    );
  }

  @override
  Future<UpdateCartListResponse> updateCartDataApi(
      UpdateCartRequest request) async {
    return _fetchData<UpdateCartListResponse>(
      'api/v1/app/food_carts/update_cart',
      method: PUT,
      requestBody: request,
      fromJson: (json) => UpdateCartListResponse.fromJson(json),
    );
  }

  @override
  Future<KycStatusResponse> kycStatusDataApi() async {
    return _fetchData<KycStatusResponse>(
      'api/v1/app/customers/check_customer_kyc_status',
      method: GET,
      fromJson: (json) => KycStatusResponse.fromJson(json),
    );
  }

  @override
  Future<CartListResponse> getCartDataListApi() async {
    return _fetchData<CartListResponse>(
      'api/v1/app/food_carts/show_cart',
      method: GET,
      fromJson: (json) => CartListResponse.fromJson(json),
    );
  }


  @override
  Future<DashboardResponse> dashboardDataApi() {
    return _fetchData<DashboardResponse>(
      'api/v1/app/customers/dashboard_data',
      method: GET,
      fromJson: (json) => DashboardResponse.fromJson(json),
    );
  }

  @override
  Future<EmptyResponse> driverLogoutApi() async {
    return _fetchData<EmptyResponse>(
      'api/v1/app/food_carts/clear_cart',
      method: DELETE,
      fromJson: (json) => EmptyResponse.fromJson(json),
    );
  }

  @override
  Future<DeleteCartResponse> clearCartApi() async {
    return _fetchData<DeleteCartResponse>(
      'api/v1/app/food_carts/clear_cart',
      method: DELETE,
      fromJson: (json) => DeleteCartResponse.fromJson(json),
    );
  }


}
