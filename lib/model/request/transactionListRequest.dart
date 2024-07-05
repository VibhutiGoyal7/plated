class TransactionListRequest {
  int? pageNo;
  int? pageSize;
  String? paymentRequestId;
  String? trxId;
  String? requestType;
  String? status;

  TransactionListRequest({
    required this.pageNo,
    required this.pageSize,
    required this.paymentRequestId,
    required this.trxId,
    required this.requestType,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'page_number': pageNo,
      'page_size': pageSize,
      'payment_request_id': paymentRequestId,
      'trx_id': trxId,
      'request_type': requestType,
      'status': status,
    };
  }
}