class DashboardResponse {
  String? message;
  List<DashboardTransaction>? customerRecentTxn;
  CustomerData? customerData;

  DashboardResponse({
    required this.message,
    required this.customerRecentTxn,
    required this.customerData,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {

    var list = json['data']?['customer_recent_transactions'] as List;
    List<DashboardTransaction>? transactionList = list?.map((i) => DashboardTransaction.fromJson(i)).toList();

    return DashboardResponse(
      message: json['message'] as String?,
      customerRecentTxn: transactionList,
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

  CustomerData({
    this.firstName,
    this.email,
    this.username,
    this.balance,
    this.countryName,
    this.countryPhoneCode,
    this.countryCurrencySymbol,
    this.imageUrl,
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
    );
  }
}
