import 'dart:io';


abstract class BaseService {
  //final String BaseUrl = "https://trnsapi.bd-one.net/";
  final String BaseUrl = "https://swiceapi.bd-one.net/";

  String getFullUrl(String endpoint) {
    return "$BaseUrl$endpoint";
  }

  Future<dynamic> postResponse(String url, dynamic phoneRequest);

  Future<dynamic> putResponse(String url, dynamic phoneRequest);

  Future<dynamic> putSetUpAccountResponse(
      String url, dynamic phoneRequest, String token);

  Future<dynamic> getResponse(String url);

  Future<dynamic> deleteResponse(String url);

  Future<dynamic> putMultiFormResponse(
      String url, File file, String firstName, String lastName, String dob);

  Future<dynamic> postMultiFormResponse(
      String url, File imageFile, String docType, File videoFile);

  Future<dynamic> postMultiFormMessageResponse(
      String url, File imageFile, String content);

  Future<dynamic> postMultiFormResponseToCreateSupport({
    required String url,
    required String customerId,
    required String amount,
    required String customerMerchantNumber,
    required String trxId,
    required String? transactionProviderId,
    required String? transactionMethodId,
    required String bankName,
    required String comment,
    required String transactionTypeId,
    File? supportTicketDocument, // Nullable
  });

  Future<dynamic> postMultiFormResponseForCryptoPayment({
    required String url,
    required String crypto_amount,
    required String amount,
    required String crypto_network_id,
    required String crypto_network_name,
    required String? crypto_name,
    required String? transaction_id,
    required String? crypto_address,
    File? screenshot, // Nullable
  });

  Future<dynamic> postMultiFormResponseToCreateSupportCustom({
    required String url,
    required String customerId,
    required String amount,
    required String customerMerchantNumber,
    required String trxId,
    required String comment,
    required String transactionTypeId,
    File? supportTicketDocument, // Nullable
  });
}