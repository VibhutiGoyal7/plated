import 'package:BDOne/model/response/transactionListReponse.dart';
import 'package:floor/floor.dart';

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
    List<TransactionDetails>? transactionList =
        list?.map((i) => TransactionDetails.fromJson(i)).toList();

    return DashboardResponse(
      message: json['message'] as String?,
      status: json['status'] as int?,
      customerRecentTxn: json['data']?['customer_recent_transactions'] != null
          ? transactionList
          : null,
      customerData: json['data']?['customer_data'] != null
          ? new CustomerData.fromJson(json['data']?['customer_data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': {
        'customer_recent_transactions':
            customerRecentTxn?.map((e) => e.toJson()).toList(),
        'customer_data': customerData?.toJson(),
      },
    };
  }
}

class DashboardTransaction {
  int? id;
  String? amount;
  String? transactionType;
  String? uniqueId;
  String? status;
  int? customerId;
  String? username;
  String? phoneNumber;
  String? email;
  String? fullName;
  String? createdAt;

  DashboardTransaction({
    required this.id,
    required this.amount,
    required this.transactionType,
    required this.uniqueId,
    required this.customerId,
    required this.status,
    required this.username,
    required this.phoneNumber,
    required this.email,
    required this.fullName,
    required this.createdAt,
  });

  factory DashboardTransaction.fromJson(Map<String, dynamic> json) {
    return DashboardTransaction(
      id: json["id"] as int?,
      amount: json["amount"] as String?,
      transactionType: json["transaction_type"] as String?,
      uniqueId: json["unique_id"] as String?,
      username: json["username"] as String?,
      email: json["email"] as String?,
      phoneNumber: json["phone_number"] as String?,
      status: json["status"] as String?,
      createdAt: json["created_at"] as String?,
      fullName: json["full_name"] as String?,
      customerId: json["customer_id"] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "amount": amount,
      "transaction_type": transactionType,
      "unique_id": uniqueId,
      "username": username,
      "email": email,
      "phone_number": phoneNumber,
      "currency": status,
      "status": status,
      "created_at": createdAt,
      "full_name": fullName,
      "customer_id": customerId,
    };
  }
}

@entity
class CustomerData {
  @primaryKey
  final String? email;
  final String? firstName;
  final String? username;
  final String? balance;
  final String? countryName;
  final String? countryPhoneCode;
  final String? countryCurrencySymbol;
  final String? imageUrl;
  final String? kycStatus;
  final String? tpin;

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

  Map<String, dynamic> toJson() {
    return {
      "first_name": firstName,
      "email": email,
      "username": username,
      "balance": balance,
      "country_name": countryName,
      "country_phone_code": countryPhoneCode,
      "country_currency_symbol": countryCurrencySymbol,
      "image_url": imageUrl,
      "kyc_status": kycStatus,
      "tpin": tpin,
    };
  }
}
