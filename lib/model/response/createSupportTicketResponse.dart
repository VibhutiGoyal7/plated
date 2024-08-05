import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class CreateSupportTicketResponse {
  final int? id;
  final String? amount;
  final int? merchantId;
  final String? paymentTime;
  final String? customerMerchantNumber;
  final String? trxId;
  final String? comment;
  final String? screenshot;
  final String? queryType;
  final int? transactionTypeId;
  final int? transactionMethodId;
  final int? transactionProviderId ;
  final String? createdAt;
  final String? updatedAt;
  final int? customerId;
  final String? message;

  CreateSupportTicketResponse({
  this.id,
    this.amount,
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
    this.message
  });

  factory CreateSupportTicketResponse.fromJson(Map<String, dynamic> json) {
    return CreateSupportTicketResponse(
      message: json['message'] as String?,
      id: json['data']?['id'] as int?,
      amount: json['data']?['amount'] as String?,
      merchantId: json['data']?['merchant_id'] as int?,
      paymentTime: json['data']?['payment_time'] as String?,
      transactionTypeId: json['data']?['transaction_type_id'] as int?,
      transactionProviderId: json['data']?['transaction_provider_id'] as int?,
      trxId: json['data']?['trx_id'] as String?,
      customerMerchantNumber: json['data']?['customer_merchant_number'] as String?,
      queryType: json['data']?['query_type'] as String?,
      comment: json['data']?['comment'] as String?,
      screenshot: json['data']?['screenshot'] as String?,
      transactionMethodId: json['data']?['transaction_method_id'] as int?,
      createdAt: json['data']?['created_at'] as String?,
      updatedAt: json['data']?['updated_at'] as String?,
      customerId: json['data']?['customer_id'] as int?,
    );
  }
}