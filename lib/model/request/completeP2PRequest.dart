class CompleteP2PRequest {
  String? otp;
  String? uniqueId;
  String? fullName;
  String? receiverPhoneNumber;
  String? receiverUsername;
  String? amount;
  String? imageUrl;
  String? paymentTransactionId;

  CompleteP2PRequest({
    this.otp,
    this.uniqueId,
    this.fullName,
    this.receiverPhoneNumber,
    this.receiverUsername,
    this.amount,
    this.imageUrl,
    this.paymentTransactionId,
  });

  Map<String, dynamic> toJson() {
    return {
      'otp': otp,
      'unique_id': uniqueId,
      'full_name': fullName,
      'receiver_phone_number': receiverPhoneNumber,
      'receiver_username': receiverUsername,
      'amount': amount,
      'imageUrl': imageUrl,
      'payment_transaction_id': paymentTransactionId,
    };
  }
}
