import 'package:floor/floor.dart';

class AllSupportTicketsResponse {
  String? message;
  int? status;
  List<AllSupportTicketsDetails>? data;
  PagyDetails? pagy;

  AllSupportTicketsResponse({
    required this.message,
    required this.status,
    required this.data,
    required this.pagy,
  });

  factory AllSupportTicketsResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<AllSupportTicketsDetails>? transactionList =
    list?.map((i) => AllSupportTicketsDetails.fromJson(i)).toList();

    return AllSupportTicketsResponse(
      message: json['message'] as String?,
      status: json['status'] as int?,
      data: transactionList,
      pagy:
      json['pagy'] != null ? new PagyDetails.fromJson(json['pagy']) : null,
    );
  }
}

@entity
class AllSupportTicketsDetails {
  @primaryKey
  final int? id;
  final int? status;
  final String? message;
  final String? amount;
  final int? merchantId;
  final String? paymentTime;
  final String? customerMerchantNumber;
  final String? trxId;
  final String? comment;
  final String? screenshot;
  final String? queryType;
  final int? transactionTypeId;
  final String? transactionType;
  final String? transactionMethod;
  final String? transactionProvider;
  final int? transactionMethodId;
  final int? transactionProviderId ;
  final String? createdAt;
  final String? updatedAt;
  final int? customerId;

  AllSupportTicketsDetails({
    this.id,
    this.status,
    this.amount,
    this.message,
    this.merchantId,
    this.paymentTime,
    this.transactionTypeId,
    this.transactionProviderId,
    this.trxId,
    this.transactionMethodId,
    this.customerMerchantNumber,
    this.comment,
    this.screenshot,
    this.queryType,
    this.createdAt,
    this.updatedAt,
    this.customerId,
    this.transactionType,
    this.transactionMethod,
    this.transactionProvider,
  });

  factory AllSupportTicketsDetails.fromJson(Map<String, dynamic> json) {
    return AllSupportTicketsDetails(
      id: json['id'] as int?,
      amount: json['amount'] as String?,
      merchantId: json['merchant_id'] as int?,
      paymentTime: json['payment_time'] as String?,
      transactionTypeId: json['transaction_type_id'] as int?,
      transactionType: json['transaction_type'] as String?,
      transactionProviderId: json['transaction_provider_id'] as int?,
      transactionProvider: json['transaction_provider'] as String?,
      trxId: json['trx_id'] as String?,
      customerMerchantNumber: json['customer_merchant_number'] as String?,
      queryType: json['query_type'] as String?,
      comment: json['comment'] as String?,
      screenshot: json['screenshot'] as String?,
      transactionMethodId: json['transaction_method_id'] as int?,
      transactionMethod: json['transaction_method'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      customerId: json['customer_id'] as int?,
    );
  }

  factory AllSupportTicketsDetails.fromFilteredJson(Map<String, dynamic> json) {
    return AllSupportTicketsDetails(
      status: json['status'] as int?,
      message: json['message'] as String?,
      id: json['data']?['id'] as int?,
      amount: json['data']?['amount'] as String?,
      merchantId: json['data']?['merchant_id'] as int?,
      paymentTime: json['data']?['payment_time'] as String?,
      transactionTypeId: json['data']?['transaction_type_id'] as int?,
      transactionType: json['data']?['transaction_type'] as String?,
      transactionProviderId: json['data']?['transaction_provider_id'] as int?,
      transactionProvider: json['data']?['transaction_provider'] as String?,
      trxId: json['data']?['trx_id'] as String?,
      customerMerchantNumber: json['data']?['customer_merchant_number'] as String?,
      queryType: json['data']?['query_type'] as String?,
      comment: json['data']?['comment'] as String?,
      screenshot: json['data']?['screenshot'] as String?,
      transactionMethodId: json['data']?['transaction_method_id'] as int?,
      transactionMethod: json['data']?['transaction_method'] as String?,
      createdAt: json['data']?['created_at'] as String?,
      updatedAt: json['data']?['updated_at'] as String?,
      customerId: json['data']?['customer_id'] as int?,
    );
  }
/*
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "amount": amount,
      "transaction_type": transactionType,
      "full_name": fullName,
      "unique_id": uniqueId,
      "username": username,
      "phone_number": phoneNumber,
      "email": email,
      "status": status,
      "created_at": createdAt,
      "customer_id": customerId,
    };
  }*/
}

class PagyDetails {
  int? totalRow;
  int? pageNo;
  //int? pageSize;

  PagyDetails({
    this.totalRow,
    this.pageNo,
    //this.pageSize,
  });

  factory PagyDetails.fromJson(Map<String, dynamic> json) {
    return PagyDetails(
      totalRow: json["total_rows"] as int?,
      pageNo: json["page_number"] as int?,/*
      pageSize: json["page_size"] as int?,*/
    );
  }
}
