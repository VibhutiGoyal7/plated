class CompleteP2PRequest {
   String? otp;
   int? paymentTransactionId;
   int? customerOtpId;
   String? amount;
   String? receiverUsername;
   String? receiverPhoneNumber;
   String? fullName;
   String? imageUrl;

   CompleteP2PRequest({
    this.otp,
    this.paymentTransactionId,
    this.customerOtpId,
     this.amount,
     this.receiverUsername,
     this.receiverPhoneNumber,
     this.fullName,
     this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'otp': otp,
      'payment_transaction_id': paymentTransactionId,
      'customer_otp_id': customerOtpId,
      'amount': amount,
      'receiver_username': receiverUsername,
      'receiver_phone_number': receiverPhoneNumber,
      'full_name': fullName,
      'image_url': imageUrl,
    };
  }
}