class TransactionListRequest {
  int? pageNo;
  int? pageSize;
  String? uniqueId;
  String? transactionType;
  String? status;

  TransactionListRequest({
    required this.pageNo,
    required this.pageSize,
    required this.uniqueId,
    required this.transactionType,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'page_number': pageNo,
      'page_size': pageSize,
      'unique_id': uniqueId,
      'transaction_type': transactionType,
      'status': status,
    };
  }
}