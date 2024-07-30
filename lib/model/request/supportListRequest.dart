class SupportListRequest {
  int? pageNo;
  int? pageSize;
  String? trxId;
  String? customerNumber;
  String? agentNumber;

  SupportListRequest({
    required this.pageNo,
    required this.pageSize,
    required this.trxId,
    required this.customerNumber,
    required this.agentNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'page_number': pageNo,
      'page_size': pageSize,
      'trx_id': trxId,
      'customer_number': customerNumber,
      'agent_number': agentNumber,
    };
  }
}