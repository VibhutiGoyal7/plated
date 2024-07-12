class WithdrawRequest {
  String? amount;
  String? bankType;
  String? custPhone;

  WithdrawRequest({
    required this.amount,
    required this.bankType,
    required this.custPhone,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount, // Convert the customer object to JSON
      'bank_type': bankType, // Convert the customer object to JSON
      'cust_phone': custPhone, // Convert the customer object to JSON
    };
  }
}