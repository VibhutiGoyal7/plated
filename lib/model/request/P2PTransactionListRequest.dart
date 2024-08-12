class P2PTransactionListRequest {
  int? pageNo;
  int? pageSize;
  String? uniqueId;
  String? status;

  P2PTransactionListRequest({
    required this.pageNo,
    required this.pageSize,
    required this.uniqueId,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'page_number': pageNo,
      'page_size': pageSize,
      'unique_id': uniqueId,
      'status': status,
      "sorting": {"created_at": "desc"},
    };
  }
}
