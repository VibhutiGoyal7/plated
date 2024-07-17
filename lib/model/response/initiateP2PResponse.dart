class InitiateP2PResponse {
  final String? otp;
  final int? paymentTransactionId;
  final int? customerOtpId;
  final String? message;

  InitiateP2PResponse({
    this.otp,
    this.paymentTransactionId,
    this.customerOtpId,
    this.message,
  });

  factory InitiateP2PResponse.fromJson(Map<String, dynamic> json) {
    return InitiateP2PResponse(
      message: json['message'] as String?,
      otp: json['data']?['otp'] as String?,
      paymentTransactionId: json['data']?['payment_transaction_id'] as int?,
      customerOtpId: json['data']?['customer_otp_id'] as int?,
    );
  }
}