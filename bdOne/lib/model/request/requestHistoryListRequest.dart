class RequestHistoryListRequest {
  String status;
  int pageNo;
  int pageSize;

  RequestHistoryListRequest({
    required this.status,
    required this.pageNo,
    required this.pageSize,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'page_number': pageNo,
      'page_size': pageSize
    };
  }
}
