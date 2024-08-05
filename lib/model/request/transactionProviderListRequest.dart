class TransactionProviderListRequest {
  int? transactionMethodId;

  TransactionProviderListRequest({
    required this.transactionMethodId,
  });

  Map<String, dynamic> toJson() {
    return {
      'transaction_method_id': transactionMethodId,
    };
  }
}