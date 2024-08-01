class TransactionListResponse {
  String? message;
  int? status;
  List<TransactionDetails>? data;
  PagyDetails? pagy;

  TransactionListResponse({
    required this.message,
    required this.status,
    required this.data,
    required this.pagy,
  });

  factory TransactionListResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<TransactionDetails>? transactionList =
        list?.map((i) => TransactionDetails.fromJson(i)).toList();

    return TransactionListResponse(
      message: json['message'] as String?,
      status: json['status'] as int?,
      data: transactionList,
      pagy:
          json['pagy'] != null ? new PagyDetails.fromJson(json['pagy']) : null,
    );
  }
}

class TransactionDetails {
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
  int? customerId;

  TransactionDetails({
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
    required this.customerId,
  });

  factory TransactionDetails.fromJson(Map<String, dynamic> json) {
    return TransactionDetails(
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
      customerId: json["customer_id"] as int?,
    );
  }
}

class PagyDetails {
  int? totalRow;
  int? pageNo;
  int? pageSize;

  PagyDetails({
    this.totalRow,
    this.pageNo,
    this.pageSize,
  });

  factory PagyDetails.fromJson(Map<String, dynamic> json) {
    return PagyDetails(
      totalRow: json["total_rows"] as int?,
      pageNo: json["page_number"] as int?,
      pageSize: json["page_size"] as int?,
    );
  }
}
