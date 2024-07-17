class CompleteP2PRequest {
   String? otp;
   int? paymentTransactionId;
   int? customerOtpId;

   CompleteP2PRequest({
    this.otp,
    this.paymentTransactionId,
    this.customerOtpId,
  });

  Map<String, dynamic> toJson() {
    return {
      'otp': otp,
      'payment_transaction_id': paymentTransactionId,
      'customer_otp_id': customerOtpId,
    };
  }
}