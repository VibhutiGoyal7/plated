class WithDrawResponse {
  double? requestedAmount;
  String? requestType;
  String? bankType;
  String? currency;
  String? requestId;
  String? callbackUrl;
  String? msg;
  int? status;
  String? message;

  WithDrawResponse({
    required this.requestedAmount,
    required this.requestType,
    required this.bankType,
    required this.currency,
    required this.requestId,
    required this.callbackUrl,
    required this.msg,
    required this.status,
    required this.message,
  });

  factory WithDrawResponse.fromJson(Map<String, dynamic> json) {
    return WithDrawResponse(
      message: json["message"] as String?,
      requestedAmount: json["data"]?["requested_amount"] as double?,
      requestType: json["data"]?["request_type"] as String?,
      bankType: json["data"]?["bank_type"] as String?,
      currency: json["data"]?["currency"] as String?,
      requestId: json["data"]?["request_id"] as String?,
      callbackUrl: json["data"]?["callback_url"] as String?,
      msg: json["data"]?["msg"] as String?,
      status: json["data"]?["status"] as int?,
    );
  }
}
