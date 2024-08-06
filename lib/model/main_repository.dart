import 'dart:io';

import 'package:Payrio/model/request/AddMoneyRequest.dart';
import 'package:Payrio/model/request/changeOldPasswordRequest.dart';
import 'package:Payrio/model/request/checkCustomerRequest.dart';
import 'package:Payrio/model/request/completeP2PRequest.dart';
import 'package:Payrio/model/request/createOtpChangePass.dart';
import 'package:Payrio/model/request/createOtpEmailVerifyRequest.dart';
import 'package:Payrio/model/request/exustingUserRequest.dart';
import 'package:Payrio/model/request/generateOtpTpinChange.dart';
import 'package:Payrio/model/request/generateTpinRequest.dart';
import 'package:Payrio/model/request/initiateP2PRequest.dart';
import 'package:Payrio/model/request/transactionProviderListRequest.dart';
import 'package:Payrio/model/request/serviceTypeListRequest.dart';
import 'package:Payrio/model/request/setUpAccountRequest.dart';
import 'package:Payrio/model/request/signInRequest.dart';
import 'package:Payrio/model/request/signInWithPhoneNumber.dart';
import 'package:Payrio/model/request/supportListRequest.dart';
import 'package:Payrio/model/request/transactionListRequest.dart';
import 'package:Payrio/model/request/transactionMethodRequest.dart';
import 'package:Payrio/model/request/verifyOtpChangePass.dart';
import 'package:Payrio/model/request/verifyOtpEmailVerifyRequest.dart';
import 'package:Payrio/model/request/withdrawRequest.dart';
import 'package:Payrio/model/response/AddMoneyResponse.dart';
import 'package:Payrio/model/response/GenerateOtpTPINChangeResponse.dart';
import 'package:Payrio/model/response/allSupportTicketResponse.dart';
import 'package:Payrio/model/response/checkCustomerReponse.dart';
import 'package:Payrio/model/response/completeP2PResponse.dart';
import 'package:Payrio/model/response/countryListResponse.dart';
import 'package:Payrio/model/response/createOtpChangePassResponse.dart';
import 'package:Payrio/model/response/createOtpForEmailVerifyResponse.dart';
import 'package:Payrio/model/response/createSupportTicketResponse.dart';
import 'package:Payrio/model/response/dashboardResponse.dart';
import 'package:Payrio/model/response/existingUserResponse.dart';
import 'package:Payrio/model/response/fetchKycDocResponse.dart';
import 'package:Payrio/model/response/generateTpinResponse.dart';
import 'package:Payrio/model/response/initiateP2PResponse.dart';
import 'package:Payrio/model/response/kycStatusResponse.dart';
import 'package:Payrio/model/response/messagesSupportChatResponse.dart';
import 'package:Payrio/model/response/sendMessageResponse.dart';
import 'package:Payrio/model/response/transactionProviderListReponse.dart';
import 'package:Payrio/model/response/payorioMethodListReponse.dart';
import 'package:Payrio/model/response/phoneVerifyResponse.dart';
import 'package:Payrio/model/response/profileResponse.dart';
import 'package:Payrio/model/response/setUpAccountResponse.dart';
import 'package:Payrio/model/response/transactionListReponse.dart';
import 'package:Payrio/model/response/transactionMethodListReponse.dart';
import 'package:Payrio/model/response/uploadKycResponse.dart';
import 'package:Payrio/model/response/withdrawResponse.dart';
import 'package:Payrio/model/services/base_service.dart';
import 'package:Payrio/model/services/payrio_service.dart';

import 'response/otpVerifyResponse.dart';

class MainRepository {
  BaseService _payrioService = PayrioService();

  Future<PhoneVerifyResponse> fetchPhoneVerifyResponse(
      String value, PhoneRequest phoneRequest) async {
    print(phoneRequest);
    dynamic response = await _payrioService.postResponse(value, phoneRequest);
    final jsonData = response;
    print(jsonData);
    PhoneVerifyResponse mediaList = PhoneVerifyResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<ExistingUserResponse> existingUserData(
      String value, ExistingUserRequest existingUserRequest) async {
    print(existingUserRequest);
    dynamic response =
        await _payrioService.postResponse(value, existingUserRequest);
    final jsonData = response;
    print(jsonData);
    ExistingUserResponse mediaList = ExistingUserResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<OtpVerifyResponse> fetchOtpVerifyData(
      String value, PhoneRequest phoneRequest) async {
    print(phoneRequest);
    dynamic response = await _payrioService.postResponse(value, phoneRequest);
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
        await _payrioService.postResponse(value, generateTpinrequest);
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
    dynamic response = await _payrioService.postResponse(value, signInRequest);
    print(value);
    final jsonData = response;
    print(" ${jsonData}");
    ProfileResponse mediaList = ProfileResponse.fromSignIn(jsonData);
    return mediaList;
  }

  Future<SetUpAccountResponse> fetchSetUpScreenData(
      String value, SetUpAccountRequest setUpAccountRequest) async {
    print(setUpAccountRequest);
    dynamic response =
        await _payrioService.putResponse(value, setUpAccountRequest);
    print(value);
    final jsonData = response;
    print(jsonData);
    SetUpAccountResponse mediaList = SetUpAccountResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<ProfileResponse> ProfileScreenData(String value) async {
    dynamic response = await _payrioService.getResponse(value);
    print(value);
    final jsonData = response;
    ProfileResponse mediaList = ProfileResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<ProfileResponse> putMultiFormResponse(String value, File file) async {
    dynamic response = await _payrioService.putMultiFormResponse(value, file);
    print(value);
    final jsonData = response;
    print(jsonData);
    ProfileResponse mediaList = ProfileResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<UploadKycDocResponse> postMultiFormResponse(
      String value, File imageFile, String docType, File videoFile) async {
    dynamic response = await _payrioService.postMultiFormResponse(
        value, imageFile, docType, videoFile);
    print(value);
    final jsonData = response;
    print(jsonData);
    UploadKycDocResponse mediaList = UploadKycDocResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<CreateSupportTicketResponse> postMultiFormResponseToCreateSupport(
      String url,
      String customerId,
      String amount,
      String paymentTime,
      String customerMerchantNumber,
      String trxId,
      String transactionProviderId,
      String transactionMethodId,
      String comment,
      String transactionTypeId,
      File? supportTicketDocument) async {
    dynamic response =
        await _payrioService.postMultiFormResponseToCreateSupport(
            url,
             customerId,
             amount,
             paymentTime,
             customerMerchantNumber,
             trxId,
             transactionProviderId,
             transactionMethodId,
             comment,
             transactionTypeId,
            supportTicketDocument);
    print(paymentTime);
    final jsonData = response;
    print(jsonData);
    CreateSupportTicketResponse mediaList =
        CreateSupportTicketResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<ProfileResponse> ChangeWithOldPasswordData(
      String value, ChangeOldPassRequest changeOldPassRequest) async {
    print(changeOldPassRequest);
    dynamic response =
        await _payrioService.putResponse(value, changeOldPassRequest);
    print(value);
    final jsonData = response;
    ProfileResponse mediaList = ProfileResponse.fromJson(jsonData);
    print(jsonData);
    return mediaList;
  }

  Future<CreateOtpChangePassResponse> CreateOtpChangePass(String value,
      CreateOtpChangePassRequest createOtpChangePassRequest) async {
    print(createOtpChangePassRequest);
    dynamic response =
        await _payrioService.postResponse(value, createOtpChangePassRequest);
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
        await _payrioService.postResponse(value, verifyOtChangePassRequest);
    print(value);
    final jsonData = response;
    print(jsonData);
    return response;
  }

  Future<CreateOtpVerifyEmailResponse> CreateOtpVerifyEmail(String value,
      CreateOtpEmailVerifyRequest createOtpEmailVerifyRequest) async {
    print(createOtpEmailVerifyRequest);
    dynamic response =
        await _payrioService.postResponse(value, createOtpEmailVerifyRequest);
    print(value);
    final jsonData = response;
    final jsonDat = response;
    print(jsonDat);
    CreateOtpVerifyEmailResponse mediaList =
        CreateOtpVerifyEmailResponse.fromJson(jsonData);
    print(mediaList.mobileOtp);
    return mediaList;
  }

  Future<GenerateTpinResponse> VerifyOtpVerifyEmail(String value,
      VerifyOtpEmailVerifyRequest verifyOtpEmailVerifyRequest) async {
    print(verifyOtpEmailVerifyRequest);
    dynamic response =
        await _payrioService.postResponse(value, verifyOtpEmailVerifyRequest);
    print(value);
    final jsonData = response;
    GenerateTpinResponse mediaList = GenerateTpinResponse.fromJson(jsonData);
    print(jsonData);
    return mediaList;
  }

  Future<dynamic> addMoneyData(
      String value, AddMoneyRequest addMoneyRequest) async {
    print(addMoneyRequest);
    dynamic response =
        await _payrioService.postResponse(value, addMoneyRequest);
    print("Repo $value");
    final jsonData = response;
    AddMoneyResponse mediaList = AddMoneyResponse.fromJson(jsonData);
    print("RepoJsonData $jsonData");
    return mediaList;
  }

  Future<dynamic> withDrawData(
      String value, WithdrawRequest withdrawRequest) async {
    print(withdrawRequest);
    dynamic response =
        await _payrioService.postResponse(value, withdrawRequest);
    print("Repo $value");
    final jsonData = response;
    WithDrawResponse mediaList = WithDrawResponse.fromJson(jsonData);
    print("RepoJsonData $jsonData");
    return mediaList;
  }

  Future<FetchKycDocResponse> fetchKycDocData(String value) async {
    dynamic response = await _payrioService.getResponse(value);
    print(value);
    final jsonData = response;
    print(jsonData);
    FetchKycDocResponse mediaList = FetchKycDocResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<CountryListResponse> fetchCountryList(String value) async {
    dynamic response = await _payrioService.getResponse(value);
    print(value);
    final jsonData = response;
    print(jsonData);
    CountryListResponse mediaList = CountryListResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<KycStatusResponse> kycStatusData(String value) async {
    dynamic response = await _payrioService.getResponse(value);
    print(value);
    final jsonData = response;
    //print("jsonData $jsonData");
    KycStatusResponse mediaList = KycStatusResponse.fromJson(jsonData);
    //print("object ${mediaList.message}");
    return mediaList;
  }

  Future<TransactionListResponse> transactionListData(
      String value, TransactionListRequest transactionListRequest) async {
    print(transactionListRequest);
    dynamic response =
        await _payrioService.postResponse(value, transactionListRequest);
    print(value);
    final jsonData = response;
    print(jsonData);
    TransactionListResponse mediaList =
        TransactionListResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<AllSupportTicketsResponse> supportListData(
      String value, SupportListRequest supportListRequest) async {
    print(supportListRequest);
    dynamic response =
        await _payrioService.postResponse(value, supportListRequest);
    print(value);
    final jsonData = response;
    print(jsonData);
    AllSupportTicketsResponse mediaList =
    AllSupportTicketsResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<ServiceTypeListResponse> serviceTypeListData(
      String value, ServiceTypeListRequest serviceTypeListRequest) async {
    print(serviceTypeListRequest);
    dynamic response =
    await _payrioService.postResponse(value, serviceTypeListRequest);
    print(value);
    final jsonData = response;
    print(jsonData);
    ServiceTypeListResponse mediaList =
    ServiceTypeListResponse.fromJson(jsonData);
    return mediaList;
  }


  Future<TransactionMethodListResponse> transactionMethodList(
      String value, TransactionMethodRequest transactionMethodRequest) async {
    print(transactionMethodRequest);
    dynamic response =
    await _payrioService.postResponse(value, transactionMethodRequest);
    print(value);
    final jsonData = response;
    print(jsonData);
    TransactionMethodListResponse mediaList =
    TransactionMethodListResponse.fromJson(jsonData);
    return mediaList;
  }


  Future<TransactionProviderListResponse> paymentMethodList(
      String value, TransactionProviderListRequest paymentMethodListRequest) async {
    print(paymentMethodListRequest);
    dynamic response =
    await _payrioService.postResponse(value, paymentMethodListRequest);
    print(value);
    final jsonData = response;
    print(jsonData);
    TransactionProviderListResponse mediaList =
    TransactionProviderListResponse.fromJson(jsonData);
    return mediaList;
  }


  Future<dynamic> getSupportChatData(String value) async {
    dynamic response = await _payrioService.getResponse(value);
    print(value);
    final jsonData = response;
    MessagesSupportChatResponse mediaList =
    MessagesSupportChatResponse.fromJson(jsonData);
    return mediaList;
  }


  Future<dynamic> getFilteredSupportTicket(String value) async {
    dynamic response = await _payrioService.getResponse(value);
    print(value);
    final jsonData = response;
    AllSupportTicketsDetails mediaList =
    AllSupportTicketsDetails.fromFilteredJson(jsonData);
    return mediaList;
  }


  Future<SendMessageResponse> postMultiFormMessageResponse(
      String value, File imageFile, String content) async {
    dynamic response = await _payrioService.postMultiFormMessageResponse(
        value, imageFile, content);
    print(value);
    final jsonData = response;
    print(jsonData);
    SendMessageResponse mediaList = SendMessageResponse.fromJson(jsonData);
    return mediaList;
  }



  Future<dynamic> getOtpTPINChange(String value) async {
    dynamic response = await _payrioService.getResponse(value);
    print(value);
    final jsonData = response;
    GenerateOtpTPINChangeResponse mediaList =
        GenerateOtpTPINChangeResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<dynamic> verifyOtpTPinChange(
      String value, VerifyOtpTPinChange generateOtpTPinChange) async {
    print(generateOtpTPinChange);
    dynamic response =
        await _payrioService.postResponse(value, generateOtpTPinChange);
    print(value);
    final jsonData = response;
    print(jsonData);
    return response;
  }

  Future<dynamic> initiateP2PTransaction(
      String value, InitiateP2PRequest initiateP2PRequest) async {
    print(initiateP2PRequest);
    dynamic response =
        await _payrioService.postResponse(value, initiateP2PRequest);
    print(value);
    final jsonData = response;
    InitiateP2PResponse mediaList = InitiateP2PResponse.fromJson(jsonData);
    print(jsonData);
    return mediaList;
  }

  Future<dynamic> checkCustomerByUsername(
      String value, CheckCustomerRequest checkCustomerRequest) async {
    print(checkCustomerRequest);
    dynamic response =
        await _payrioService.postResponse(value, checkCustomerRequest);
    print(value);
    final jsonData = response;
    print("jsonData::: ${jsonData}");
    CheckCustomerResponse? mediaList = CheckCustomerResponse.fromJson(jsonData);
    print("mediaList:: ${mediaList}");
    return mediaList;
  }

  Future<dynamic> completeP2PTransaction(
      String value, CompleteP2PRequest completeP2PRequest) async {
    print(completeP2PRequest);
    dynamic response =
        await _payrioService.postResponse(value, completeP2PRequest);
    print(value);
    final jsonData = response;
    CompleteP2PResponse mediaList = CompleteP2PResponse.fromJson(jsonData);
    print(jsonData);
    return mediaList;
  }

  Future<DashboardResponse> dashboardData(String value) async {
    dynamic response = await _payrioService.getResponse(value);
    print(value);
    final jsonData = response;
    //print("jsonData $jsonData");
    DashboardResponse mediaList = DashboardResponse.fromJson(jsonData);
    //print("object ${mediaList.message}");
    return mediaList;
  }
}
