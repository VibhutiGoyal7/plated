import 'package:floor/floor.dart';

class TransactionListResponse {
  String? message;
  List<TransactionDetails>? data;
  PagyDetails? pagy;

  TransactionListResponse({
    required this.message,
    required this.data,
    required this.pagy,
  });

  factory TransactionListResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<TransactionDetails>? transactionList =
        list?.map((i) => TransactionDetails.fromJson(i)).toList();

    return TransactionListResponse(
      message: json['message'] as String?,
      data: transactionList,
      pagy:
          json['pagy'] != null ? new PagyDetails.fromJson(json['pagy']) : null,
    );
  }
}

@entity
class TransactionDetails {
  @primaryKey
  final int? id;
  final String? amount;
  final String? bankType;
  final String? bankService;
  final String? requestType;
  final String? paymentRequestId;
  final String? trxId;
  final String? currency;
  final String? status;
  final String? createdAt;
  final int? customerId;

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

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "amount": amount,
      "bank_type": bankType,
      "bank_service": bankService,
      "request_type": requestType,
      "payment_request_id": paymentRequestId,
      "trx_id": trxId,
      "currency": currency,
      "status": status,
      "created_at": createdAt,
      "customer_id": customerId,
    };
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
