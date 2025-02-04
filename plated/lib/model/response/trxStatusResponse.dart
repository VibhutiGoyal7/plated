
class TrxStatusResponse {
  final int? status;
  final int? id;
  final int? customerId;
  final String? message;
  final String? dataStatus;
  final String? amount;
  final String? transactionType;
  final String? transactionMethod;
  final String? transactionProvider;
  final String? uniqueId;
  final String? createdAt;
  final String? updatedAt;
  final TrxDetails? trxDetails;

  TrxStatusResponse({
    this.status,
    this.id,
    this.customerId,
    this.message,
    this.dataStatus,
    this.transactionType,
    this.transactionMethod,
    this.transactionProvider,
    this.uniqueId,
    this.createdAt,
    this.updatedAt,
    this.amount,
    this.trxDetails,

  });

  factory TrxStatusResponse.fromJson(Map<String, dynamic> json){
    return TrxStatusResponse(
      message : json['message'] as String?,
      status : json['status'] as int?,
      dataStatus : json['data']?['status'] as String?,
      id : json['data']?['id'] as int?,
      customerId : json['data']?['customer_id'] as int?,
      transactionType : json['data']?['transaction_type'] as String?,
      transactionMethod : json['data']?['transaction_method'] as String?,
      transactionProvider : json['data']?['transaction_provider'] as String?,
      uniqueId : json['data']?['unique_id'] as String?,
      createdAt : json['data']?['created_at'] as String?,
      amount : json['data']?['amount'] as String?,
      updatedAt : json['data']?['updated_at'] as String?,
      trxDetails : json['data']?['trx_details'] != null
          ? TrxDetails.fromJson(
          json['data']?['trx_details'])
          : null,
    );
  }
}
class TrxDetails {
  final int? status;
  final String? msg;
  final String? requestId;
  final String? redirectUrl;
  final String? currency;

  TrxDetails({
    this.status,
    this.msg,
    this.requestId,
    this.redirectUrl,
    this.currency,

  });

  factory TrxDetails.fromJson(Map<String, dynamic> json){
    return TrxDetails(
      status : json['data']?['status'] as int?,
      msg : json['data']?['message'] as String?,
      requestId : json['data']?['request_id'] as String?,
      redirectUrl : json['data']?['redirect_url'] as String?,
      currency : json['data']?['currency'] as String?,
    );
  }
}