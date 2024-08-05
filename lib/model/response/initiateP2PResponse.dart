class InitiateP2PResponse {
  final String? message;
  final int? status;
  final int? id;
  final int? customerId;
  final String? amount;
  final String? otp;
  final String? transactionType;
  final String? transactionMethod;
  final String? transactionProvider;
  final String? uniqueId;
  final int? senderId;
  final int? receiverId;
  final String? notes;
  final String? dataStatus;
  final TrxDetails? trxDetails;
  final String? createdAt;
  final String? updatedAt;

  InitiateP2PResponse({
    this.message,
    this.status,
    this.id,
    this.customerId,
    this.amount,
    this.otp,
    this.transactionType,
    this.transactionMethod,
    this.transactionProvider,
    this.uniqueId,
    this.senderId,
    this.receiverId,
    this.notes,
    this.dataStatus,
    this.trxDetails,
    this.createdAt,
    this.updatedAt,
  });

  factory InitiateP2PResponse.fromJson(Map<String, dynamic> json) {
    return InitiateP2PResponse(
      message: json['message'] as String?,
      status: json['status'] as int?,
      id: json['data']?['id'] as int?,
      customerId: json['data']?['customer_id'] as int?,
      amount: json['data']?['amount'] as String?,
      otp: json['data']?['otp'] as String?,
      transactionType: json['data']?['transaction_type'] as String?,
      transactionMethod: json['data']?['transaction_method'] as String?,
      transactionProvider: json['data']?['transaction_provider'] as String?,
      uniqueId: json['data']?['unique_id'] as String?,
      senderId: json['data']?['sender_id'] as int?,
      receiverId: json['data']?['receiver_id'] as int?,
      notes: json['data']?['notes'] as String?,
      dataStatus: json['data']?['status'] as String?,
      trxDetails: json['data']?['trx_details']  != null ? new TrxDetails.fromJson(json['data']?['trx_details']) : null,
      createdAt: json['data']?['created_at'] as String?,
      updatedAt: json['data']?['updated_at'] as String?,
    );
  }
}

class TrxDetails {
  final String? otp;
  final String? unique_id;

  TrxDetails({
    this.otp,
    this.unique_id,
  });

  factory TrxDetails.fromJson(Map<String, dynamic> json) {
    return TrxDetails(
      otp: json['otp'] as String?,
      unique_id: json['unique_id'] as String?,
    );
  }
}
