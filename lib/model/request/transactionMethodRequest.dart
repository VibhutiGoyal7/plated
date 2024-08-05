class TransactionMethodRequest {
  int? transactionTypeId;

  TransactionMethodRequest({
    required this.transactionTypeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'transaction_type_id': transactionTypeId,
    };
  }
}