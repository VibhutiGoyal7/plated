class CreateSupportTicketRequest {
   String? otp;
   String? tpin;
   int? paymentTransactionId;
   int? customerOtpId;
   String? amount;
   String? receiverUsername;
   String? receiverPhoneNumber;
   String? fullName;
   String? imageUrl;

   CreateSupportTicketRequest({
    this.otp,
    this.tpin,
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
      'tpin': tpin,
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