import 'dart:io';

import 'package:Payrio/model/apis/api_response.dart';
import 'package:Payrio/model/main_repository.dart';
import 'package:Payrio/model/request/AddMoneyRequest.dart';
import 'package:Payrio/model/request/P2PTransactionListRequest.dart';
import 'package:Payrio/model/request/initiateP2PRequest.dart';
import 'package:Payrio/model/request/notificationListRequest.dart';
import 'package:Payrio/model/request/saveAddressRequest.dart';
import 'package:Payrio/model/request/transactionProviderListRequest.dart';
import 'package:Payrio/model/request/serviceTypeListRequest.dart';
import 'package:Payrio/model/request/setUpAccountRequest.dart';
import 'package:Payrio/model/request/signInWithPhoneNumber.dart';
import 'package:Payrio/model/request/transactionListRequest.dart';
import 'package:Payrio/model/request/transactionMethodRequest.dart';
import 'package:Payrio/model/request/trxStatusRequest.dart';
import 'package:Payrio/model/request/withdrawRequest.dart';
import 'package:Payrio/model/response/AddMoneyResponse.dart';
import 'package:Payrio/model/response/checkCustomerReponse.dart';
import 'package:Payrio/model/response/completeP2PResponse.dart';
import 'package:Payrio/model/response/createOtpForEmailVerifyResponse.dart';
import 'package:Payrio/model/response/createSupportTicketResponse.dart';
import 'package:Payrio/model/response/dashboardResponse.dart';
import 'package:Payrio/model/response/fetchKycDocResponse.dart';
import 'package:Payrio/model/response/initiateP2PResponse.dart';
import 'package:Payrio/model/response/kycStatusResponse.dart';
import 'package:Payrio/model/response/messagesSupportChatResponse.dart';
import 'package:Payrio/model/response/notificationListResponse.dart';
import 'package:Payrio/model/response/transactionProviderListReponse.dart';
import 'package:Payrio/model/response/payorioMethodListReponse.dart';
import 'package:Payrio/model/response/phoneVerifyResponse.dart';
import 'package:Payrio/model/response/profileResponse.dart';
import 'package:Payrio/model/response/setUpAccountResponse.dart';
import 'package:Payrio/model/response/transactionListReponse.dart';
import 'package:Payrio/model/response/trxStatusResponse.dart';
import 'package:Payrio/model/response/uploadKycResponse.dart';
import 'package:Payrio/model/response/withdrawResponse.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

import '../model/request/changeOldPasswordRequest.dart';
import '../model/request/checkCustomerRequest.dart';
import '../model/request/completeP2PRequest.dart';
import '../model/request/createOtpChangePass.dart';
import '../model/request/createOtpEmailVerifyRequest.dart';
import '../model/request/exustingUserRequest.dart';
import '../model/request/generateOtpTpinChange.dart';
import '../model/request/generateTpinRequest.dart';
import '../model/request/signInRequest.dart';
import '../model/request/supportListRequest.dart';
import '../model/request/verifyOtpChangePass.dart';
import '../model/request/verifyOtpEmailVerifyRequest.dart';
import '../model/response/GenerateOtpTPINChangeResponse.dart';
import '../model/response/allSupportTicketResponse.dart';
import '../model/response/countryListResponse.dart';
import '../model/response/createOtpChangePassResponse.dart';
import '../model/response/existingUserResponse.dart';
import '../model/response/generateTpinResponse.dart';
import '../model/response/otpVerifyResponse.dart';
import '../model/response/p2PTransactionListReponse.dart';
import '../model/response/sendMessageResponse.dart';
import '../model/response/transactionMethodListReponse.dart';

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

  Future<void> profileScreenData(String value) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      ProfileResponse profileResponse =
          await MainRepository().ProfileScreenData(value);
      print("Yess ${profileResponse.message}");
      if (profileResponse.status  == 200 || profileResponse.status == 201) {
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


  Future<void> saveAddressData(
      String value, SaveAddressRequest saveAddressRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    print("Yess" + saveAddressRequest.addressParams.city);
    notifyListeners();
    try {
      print(saveAddressRequest.addressParams.state);
      ProfileResponse profileResponse = await MainRepository()
          .saveAddressData(value, saveAddressRequest);
      print("Yess" + profileResponse.email.toString());
      //_apiResponse = ApiResponse.completed(setUpAccountResponse);
      if (profileResponse.status  == 200 || profileResponse.status == 201) {
        _apiResponse = ApiResponse.completed(profileResponse);
      } else {
        print("viewmodel ${profileResponse.message}");
        _apiResponse = ApiResponse.error(profileResponse.message);
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
      print("Yess" + profileResponse.firstName.toString());
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

  Future<void> postMultiFormResponseToCreateSupport(
      {required String url,
        required String amount,
        required String paymentTime,
        required String customerId,
        required String trxId,
        required String customerMerchantNumber,
        required String transactionProviderId,
        required String comment,
        required String transactionMethodId,
        required String transactionTypeId,
        required File? supportTicketDocument}) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      CreateSupportTicketResponse createSupportTicketResponse =
          await MainRepository().postMultiFormResponseToCreateSupport(
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
      print("Yess" + createSupportTicketResponse.message.toString());
      if (createSupportTicketResponse.trxId != null) {
        _apiResponse = ApiResponse.completed(createSupportTicketResponse);
      } else {
        _apiResponse = ApiResponse.error(createSupportTicketResponse.message);
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
    try {ProfileResponse profileResponse =
      await MainRepository()
          .ChangeWithOldPasswordData(value, changeOldPassRequest);

      if (profileResponse.status == 200 || profileResponse.status == 201) {
        _apiResponse = ApiResponse.completed(profileResponse.message);
      } else {
        _apiResponse = ApiResponse.error(profileResponse.message);
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

  Future<void> CreateOtpVerifyEmail(String value,
      CreateOtpEmailVerifyRequest createOtpEmailVerifyRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      print(createOtpEmailVerifyRequest.customer.phoneNumber);

      CreateOtpVerifyEmailResponse createOtpVerifyEmailResponse =
          await MainRepository()
              .CreateOtpVerifyEmail(value, createOtpEmailVerifyRequest);
      print("Yess  ${createOtpVerifyEmailResponse.mobileOtp}");

      if (createOtpVerifyEmailResponse.status == 200 || createOtpVerifyEmailResponse.status == 201) {
        _apiResponse = ApiResponse.completed(createOtpVerifyEmailResponse);
      } else {
        _apiResponse =
            ApiResponse.error("${createOtpVerifyEmailResponse.message}");
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> VerifyOtpVerifyEmail(String value,
      VerifyOtpEmailVerifyRequest verifyOtpEmailVerifyRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      final GenerateTpinResponse generateTpinResponse = await MainRepository()
          .VerifyOtpVerifyEmail(value, verifyOtpEmailVerifyRequest);
      print("generateTpinResponse ::: ${response}");
      if (generateTpinResponse.status == 200 || generateTpinResponse.status == 201) {
        _apiResponse = ApiResponse.completed(generateTpinResponse);
      } else {
        _apiResponse =
            ApiResponse.error("${generateTpinResponse.message}");
      }

    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> addMoneyData(
      String value, AddMoneyRequest addMoneyRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      AddMoneyResponse addMoneyResponse =
          await MainRepository().addMoneyData(value, addMoneyRequest);
      print("MainViewModel $response");
      //  _apiResponse = ApiResponse.completed(response);
      if (addMoneyResponse.redirectUrl != null) {
        _apiResponse = ApiResponse.completed(addMoneyResponse);
      } else {
        _apiResponse = ApiResponse.error(addMoneyResponse.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print("MainViewModelError $e");
    }
    notifyListeners();
  }

  Future<void> trxStatusData(
      String value, TrxStatusRequest trxStatusRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      TrxStatusResponse trxStatusResponse =
          await MainRepository().trxStatusData(value, trxStatusRequest);
      print("MainViewModel ${trxStatusResponse.status}");
      //  _apiResponse = ApiResponse.completed(response);
      if (trxStatusResponse.status ==200 || trxStatusResponse.status == 201) {
        _apiResponse = ApiResponse.completed(trxStatusResponse);
      } else {
        _apiResponse = ApiResponse.error(trxStatusResponse.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print("MainViewModelError $e");
    }
    notifyListeners();
  }

  Future<void> withDrawData(
      String value, WithdrawRequest withDrawRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      WithDrawResponse withDrawResponse =
          await MainRepository().withDrawData(value, withDrawRequest);

      //  _apiResponse = ApiResponse.completed(response);
      if (withDrawResponse.currency != null) {
        print("MainViewModel ${withDrawResponse.message}");
        _apiResponse = ApiResponse.completed(withDrawResponse);
      } else {
        print("MainViewModelError ${withDrawResponse.message}");
        _apiResponse = ApiResponse.error("${withDrawResponse.message}");
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print("MainViewModelError $e");
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

  Future<void> transactionListData(
      String value, TransactionListRequest transactionListRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    print("Yess ${transactionListRequest.uniqueId}");
    notifyListeners();
    try {
      TransactionListResponse transactionListResponse = await MainRepository()
          .transactionListData(value, transactionListRequest);
      if (transactionListResponse.status  == 200 || transactionListResponse.status == 201) {
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

  Future<void> p2PTransactionListData(
      String value, P2PTransactionListRequest request) async {
    _apiResponse = ApiResponse.loading('Loading');
    print("Yess ${request.uniqueId}");
    notifyListeners();
    try {
      P2PTransactionListResponse p2PTransactionListResponse = await MainRepository()
          .p2PTransactionListData(value, request);
      if (p2PTransactionListResponse.status  == 200 || p2PTransactionListResponse.status == 201) {
        _apiResponse = ApiResponse.completed(p2PTransactionListResponse);
      } else {
        _apiResponse = ApiResponse.error(p2PTransactionListResponse.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print("Transaction List : $e");
    }
    notifyListeners();
  }


  Future<void> notificationListData(
      String value, NotificationListRequest notificationListRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    print("Yess ${notificationListRequest.notificationType}");
    notifyListeners();
    try {
      NotificationListResponse notificationListResponse = await MainRepository()
          .notificationListData(value, notificationListRequest);
      if (notificationListResponse.status  == 200 || notificationListResponse.status == 201) {
        _apiResponse = ApiResponse.completed(notificationListResponse);
      } else {
        _apiResponse = ApiResponse.error(notificationListResponse.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print("Transaction List : $e");
    }
    notifyListeners();
  }

  Future<void> supportListData(
      String value, SupportListRequest supportListRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    print("Yess ${supportListRequest.agentNumber}");
    notifyListeners();
    try {
      AllSupportTicketsResponse allSupportTicketsResponse = await MainRepository()
          .supportListData(value, supportListRequest);
      if (allSupportTicketsResponse.status == 200 ||
          allSupportTicketsResponse.status == 201) {
        _apiResponse = ApiResponse.completed(allSupportTicketsResponse);
      } else {
        _apiResponse = ApiResponse.error(allSupportTicketsResponse.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print("Transaction List : $e");
    }
    notifyListeners();
  }

  Future<void> serviceTypeListData(
      String value, ServiceTypeListRequest serviceTypeListRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    print("Yess ${serviceTypeListRequest.countryId}");
    notifyListeners();
    try {
      ServiceTypeListResponse serviceTypeListResponse = await MainRepository()
          .serviceTypeListData(value, serviceTypeListRequest);
      if (serviceTypeListResponse.status == 201 ||
          serviceTypeListResponse.status == 200) {
        _apiResponse = ApiResponse.completed(serviceTypeListResponse);
      } else {
        _apiResponse = ApiResponse.error(serviceTypeListResponse.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print("Transaction List : $e");
    }
    notifyListeners();
  }


  Future<void> transactionMethodList(
      String value, TransactionMethodRequest transactionMethodRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    print("Yess ${transactionMethodRequest.transactionTypeId}");
    notifyListeners();
    try {
      TransactionMethodListResponse transactionMethodListResponse = await MainRepository()
          .transactionMethodList(value, transactionMethodRequest);
      if (transactionMethodListResponse.status == 201 ||
          transactionMethodListResponse.status == 200) {
        _apiResponse = ApiResponse.completed(transactionMethodListResponse);
      } else {
        _apiResponse = ApiResponse.error(transactionMethodListResponse.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print("Transaction Method : $e");
    }
    notifyListeners();
  }


  Future<void> paymentMethodList(
      String value, TransactionProviderListRequest paymentMethodListRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    print("Yess ${paymentMethodListRequest.transactionMethodId}");
    notifyListeners();
    try {
      TransactionProviderListResponse paymentMethodListResponse = await MainRepository()
          .paymentMethodList(value, paymentMethodListRequest);
      if (paymentMethodListResponse.status == 201 ||
          paymentMethodListResponse.status == 200) {
        _apiResponse = ApiResponse.completed(paymentMethodListResponse);
      } else {
        _apiResponse = ApiResponse.error(paymentMethodListResponse.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print("Payment Method : $e");
    }
    notifyListeners();
  }

  Future<void> getSupportChatData(String value) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      MessagesSupportChatResponse messagesSupportChatResponse =
          await MainRepository().getSupportChatData(value);
      print("Yess" + response.message.toString());
      if (messagesSupportChatResponse.status == 200 || messagesSupportChatResponse.status == 201) {
        _apiResponse = ApiResponse.completed(messagesSupportChatResponse);
      } else {
        _apiResponse = ApiResponse.error(messagesSupportChatResponse.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }


  Future<void> getFilteredSupportTicket(String value) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      AllSupportTicketsDetails allSupportTicketsDetails =
          await MainRepository().getFilteredSupportTicket(value);
      print("Yess" + response.message.toString());
      if (allSupportTicketsDetails.status == 200 || allSupportTicketsDetails.status == 201) {
        _apiResponse = ApiResponse.completed(allSupportTicketsDetails);
      } else {
        _apiResponse = ApiResponse.error(allSupportTicketsDetails.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }


  Future<void> postMultiFormMessageResponse(
      String value, File imgFile, String content) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      SendMessageResponse sendMessageResponse = await MainRepository()
          .postMultiFormMessageResponse(value, imgFile, content);
      print("Yess" + sendMessageResponse.message.toString());
      if (sendMessageResponse.status == 200 || sendMessageResponse.status == 201) {
        _apiResponse = ApiResponse.completed(sendMessageResponse);
      } else {
        _apiResponse = ApiResponse.error(sendMessageResponse.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }


  Future<void> getOtpTPINChange(String value) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      GenerateOtpTPINChangeResponse generateOtpTPINChangeResponse =
          await MainRepository().getOtpTPINChange(value);
      print("Yess" + response.message.toString());
      if (generateOtpTPINChangeResponse.status == 200 || generateOtpTPINChangeResponse.status == 201) {
        _apiResponse = ApiResponse.completed(generateOtpTPINChangeResponse);
      } else {
        _apiResponse = ApiResponse.error(generateOtpTPINChangeResponse.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> verifyOtpTPinChange(
      String value, VerifyOtpTPinChange verifyOtpTPinChange) async {
    _apiResponse = ApiResponse.loading('Loading');
    print("Yess ${verifyOtpTPinChange.tpin}");
    notifyListeners();
    try {
      final GenerateTpinResponse generateTpinResponse = await MainRepository()
          .verifyOtpTPinChange(value, verifyOtpTPinChange);
      print("Yess" + response.message.toString());
      if (generateTpinResponse.status == 200 || generateTpinResponse.status == 201) {
        _apiResponse = ApiResponse.completed(generateTpinResponse);
      } else {
        _apiResponse = ApiResponse.error(generateTpinResponse.message);
      }

      //_apiResponse = ApiResponse.completed(response);
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print("TPIN change : $e");
    }
    notifyListeners();
  }

  Future<void> initiateP2PTransaction(
      String value, InitiateP2PRequest initiateP2PRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    print("Yess  ${initiateP2PRequest.tpin}");
    notifyListeners();
    try {
      InitiateP2PResponse initiateP2PResponse = await MainRepository()
          .initiateP2PTransaction(value, initiateP2PRequest);
      if (initiateP2PResponse.status == 200 || initiateP2PResponse.status == 201) {
        _apiResponse = ApiResponse.completed(initiateP2PResponse);
      } else {
        _apiResponse = ApiResponse.error(initiateP2PResponse.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print("Transaction List : $e");
    }
    notifyListeners();
  }

  Future<void> checkCustomerByUsername(
      String value, CheckCustomerRequest checkCustomerRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    print("Yess  ${checkCustomerRequest.username}");
    notifyListeners();
    try {
      CheckCustomerResponse checkCustomerResponse = await MainRepository()
          .checkCustomerByUsername(value, checkCustomerRequest);
      print("Yess" + "${checkCustomerResponse.message}");

      if (checkCustomerResponse.status == 200 || checkCustomerResponse.status == 201) {
        _apiResponse = ApiResponse.completed(checkCustomerResponse);
      } else if ("${checkCustomerResponse.message}" ==
          "Customer found successfully") {
        _apiResponse = ApiResponse.completed(checkCustomerResponse);
      } else {
        _apiResponse = ApiResponse.error(checkCustomerResponse.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> completeP2PTransaction(
      String value, CompleteP2PRequest completeP2PRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    print("Yess  ${completeP2PRequest.otp}");
    notifyListeners();
    try {
      InitiateP2PResponse completeP2PResponse = await MainRepository()
          .completeP2PTransaction(value, completeP2PRequest);
      if (completeP2PResponse.status == 200 || completeP2PResponse.status == 201) {
        _apiResponse = ApiResponse.completed(completeP2PResponse);
      } else {
        _apiResponse = ApiResponse.error(completeP2PResponse.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print("Transaction List : $e");
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
