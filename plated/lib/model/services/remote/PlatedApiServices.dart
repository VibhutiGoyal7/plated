import 'package:Plated/model/response/cartListReponse.dart';
import 'package:Plated/model/response/countryListResponse.dart';
import 'package:Plated/model/response/deleteCartResponse.dart';
import 'package:Plated/model/response/emptyResponse.dart';

import '../../request/exustingUserRequest.dart';
import '../../request/productListRequest.dart';
import '../../request/setUpAccountRequest.dart';
import '../../request/signInRequest.dart';
import '../../request/signInWithPhoneNumber.dart';
import '../../request/updateCartRequest.dart';
import '../../response/dashboardResponse.dart';
import '../../response/existingUserResponse.dart';
import '../../response/fetchKycDocResponse.dart';
import '../../response/kycStatusResponse.dart';
import '../../response/otpVerifyResponse.dart';
import '../../response/phoneVerifyResponse.dart';
import '../../response/productsListReponse.dart';
import '../../response/setUpAccountResponse.dart';
import '../../response/signInResponse.dart';
import '../../response/updateCartListReponse.dart';

abstract class PlatedApiServices {
  Future<PhoneVerifyResponse> fetchPhoneVerifyResponseApi(
      PhoneRequest phoneRequest);

  Future<OtpVerifyResponse> fetchOtpVerifyDataApi(PhoneRequest phoneRequest);

  Future<ExistingUserResponse> existingUserDataApi(
      ExistingUserRequest existingUserRequest);

  Future<SetUpAccountResponse> fetchSetUpScreenDataApi(
      SetUpAccountRequest setUpAccountRequest, String token);

  Future<SignInResponse> signInWithPassApi(SignInRequest signInRequest);

  Future<CategoryListResponse> fetchCategoryListApi();

  Future<ProductsListResponse> getProductsFromCategoryApi(
      ProductListRequest request);

  Future<UpdateCartListResponse> updateCartDataApi(
      UpdateCartRequest request);

  Future<FetchKycDocResponse> fetchKycDocDataApi();

  Future<KycStatusResponse> kycStatusDataApi();

  Future<DashboardResponse> dashboardDataApi();

  Future<CartListResponse> getCartDataListApi();

  Future<EmptyResponse> driverLogoutApi();

  Future<DeleteCartResponse> clearCartApi();

}
