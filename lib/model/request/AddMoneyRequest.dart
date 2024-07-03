class AddMoneyRequest {
  int? amount;

  AddMoneyRequest({required this.amount});

  Map<String, dynamic> toJson() {
    return {
      'amount': amount, // Convert the customer object to JSON
    };
  }
}