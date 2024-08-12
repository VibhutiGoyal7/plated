class P2PTransactionListRequest {
  int? pageNo;
  int? pageSize;
  String? uniqueId;

  P2PTransactionListRequest({
    required this.pageNo,
    required this.pageSize,
    required this.uniqueId,
  });

  Map<String, dynamic> toJson() {
    return {
      'page_number': pageNo,
      'page_size': pageSize,
      'unique_id': uniqueId,
      "sorting": {"created_at": "desc"},
    };
  }
}
