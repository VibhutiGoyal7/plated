class CompleteP2PResponse {
  final String? status;
  final String? amount;
  final String? message;
  final int? id;
  final int? customerId;
  final String? bankType;
  final String? bankService;
  final String? requestType;
  final String? paymentRequestId;
  final String? trxId;
  final String? currency;
  final String? createdAt;
  final String? updatedAt;
  final int? senderId;
  final int? receiverId;

  CompleteP2PResponse({
    this.status,
    this.amount,
    this.message,
    this.id,
    this.customerId,
    this.bankType,
    this.bankService,
    this.requestType,
    this.paymentRequestId,
    this.trxId,
    this.currency,
    this.createdAt,
    this.updatedAt,
    this.senderId,
    this.receiverId,
  });

  factory CompleteP2PResponse.fromJson(Map<String, dynamic> json) {
    return CompleteP2PResponse(
      message: json['message'] as String?,
      status: json['data']?['status'] as String?,
      amount: json['data']?['amount'] as String?,
      id: json['data']?['id'] as int?,
      customerId: json['data']?['customer_id'] as int?,
      bankType: json['data']?['bank_type'] as String?,
      bankService: json['data']?['bank_service'] as String?,
      requestType: json['data']?['request_type'] as String?,
      paymentRequestId: json['data']?['payment_request_id'] as String?,
      trxId: json['data']?['trx_id'] as String?,
      currency: json['data']?['currency'] as String?,
      createdAt: json['data']?['created_at'] as String?,
      updatedAt: json['data']?['updated_at'] as String?,
      senderId: json['data']?['sender_id'] as int?,
      receiverId: json['data']?['receiver_id'] as int?,
    );
  }
}