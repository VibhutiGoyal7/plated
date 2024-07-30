import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class CreateSupportTicketResponse {
  final int? id;
  final String? amount;
  final int? merchantId;
  final String? paymentTime;
  final String? customerNumber;
  final String? agentNumber;
  final String? trxId;
  final String? serviceType;
  final String? bankType;
  final String? comment;
  final String? screenshot;
  final String? issueType;
  final String? createdAt;
  final String? updatedAt;
  final String? customerId;
  final String? message;

  CreateSupportTicketResponse({
  this.id,
    this.amount,
    this.merchantId,
    this.paymentTime,
    this.customerNumber,
    this.agentNumber,
    this.trxId,
    this.serviceType,
    this.bankType,
    this.comment,
    this.screenshot,
    this.issueType,
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
      customerNumber: json['data']?['customer_number'] as String?,
      agentNumber: json['data']?['agent_number'] as String?,
      trxId: json['data']?['trx_id'] as String?,
      serviceType: json['data']?['service_type'] as String?,
      bankType: json['data']?['bank_type'] as String?,
      comment: json['data']?['comment'] as String?,
      screenshot: json['data']?['screenshot'] as String?,
      issueType: json['data']?['issue_type'] as String?,
      createdAt: json['data']?['created_at'] as String?,
      updatedAt: json['data']?['updated_at'] as String?,
      customerId: json['data']?['customer_id'] as String?,
    );
  }
}