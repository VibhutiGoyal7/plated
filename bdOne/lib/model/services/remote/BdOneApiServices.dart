import 'package:BDOne/model/response/countryListResponse.dart';

import '../../request/exustingUserRequest.dart';
import '../../request/productListRequest.dart';
import '../../request/setUpAccountRequest.dart';
import '../../request/signInRequest.dart';
import '../../request/signInWithPhoneNumber.dart';
import '../../response/existingUserResponse.dart';
import '../../response/otpVerifyResponse.dart';
import '../../response/phoneVerifyResponse.dart';
import '../../response/productsListReponse.dart';
import '../../response/setUpAccountResponse.dart';
import '../../response/signInResponse.dart';

abstract class BdOneApiServices {
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
}
