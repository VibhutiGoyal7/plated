import 'package:Payrio/model/response/transactionListReponse.dart';

class DashboardResponse {
  String? message;
  int? status;
  List<TransactionDetails>? customerRecentTxn;
  CustomerData? customerData;

  DashboardResponse({
    required this.message,
    required this.status,
    required this.customerRecentTxn,
    required this.customerData,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {

    var list = json['data']?['customer_recent_transactions'] as List?;
    List<TransactionDetails>? transactionList = list?.map((i) => TransactionDetails.fromJson(i)).toList();

    return DashboardResponse(
      message: json['message'] as String?,
      status: json['status'] as int?,
      customerRecentTxn: json['data']?['customer_recent_transactions'] != null
          ?transactionList : null,
      customerData: json['data']?['customer_data'] != null
          ? new CustomerData.fromJson(json['data']?['customer_data'])
          : null,
    );
  }
}

class DashboardTransaction {
  int? id;
  String? amount;
  String? bankType;
  String? bankService;
  String? requestType;
  String? paymentRequestId;
  String? trxId;
  String? currency;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? customerId;

  DashboardTransaction({
    required this.id,
    required this.amount,
    required this.bankType,
    required this.bankService,
    required this.requestType,
    required this.paymentRequestId,
    required this.trxId,
    required this.currency,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.customerId,
  });

  factory DashboardTransaction.fromJson(Map<String, dynamic> json) {
    return DashboardTransaction(
      id: json["id"] as int?,
      amount: json["amount"] as String?,
      bankType: json["bank_type"] as String?,
      bankService: json["bank_service"] as String?,
      requestType: json["request_type"] as String?,
      paymentRequestId: json["payment_request_id"] as String?,
      trxId: json["trx_id"] as String?,
      currency: json["currency"] as String?,
      status: json["status"] as String?,
      createdAt: json["created_at"] as String?,
      updatedAt: json["updated_at"] as String?,
      customerId: json["customer_id"] as int?,
    );
  }
}

class CustomerData {
  String? firstName;
  String? email;
  String? username;
  String? balance;
  String? countryName;
  String? countryPhoneCode;
  String? countryCurrencySymbol;
  String? imageUrl;
  String? kycStatus;
  String? tpin;

  CustomerData({
    this.firstName,
    this.email,
    this.username,
    this.balance,
    this.countryName,
    this.countryPhoneCode,
    this.countryCurrencySymbol,
    this.imageUrl,
    this.kycStatus,
    this.tpin,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      firstName: json["first_name"] as String?,
      email: json["email"] as String?,
      username: json["username"] as String?,
      balance: json["balance"] as String?,
      countryName: json["country_name"] as String?,
      countryPhoneCode: json["country_phone_code"] as String?,
      countryCurrencySymbol: json["country_currency_symbol"] as String?,
      imageUrl: json["image_url"] as String?,
      kycStatus: json["kyc_status"] as String?,
      tpin: json["tpin"] as String?,
    );
  }
}
