class WithDrawResponse {
  String? message;
  int? status;
  String? redirectUrl;
  String? requestId;
  String? currency;
  int? dataStatus;
  String? dataMessage;
  String? uniqueId;



  WithDrawResponse({
    required this.message,
    required this.status,
    required this.redirectUrl,
    required this.requestId,
    required this.currency,
    required this.dataStatus,
    required this.dataMessage,
    required this.uniqueId,
  });

  factory WithDrawResponse.fromJson(Map<String, dynamic> json) {
    return WithDrawResponse(
      message: json["message"] as String?,
      status: json["status"] as int?,
      redirectUrl: json["data"]?["redirect_url"] as String?,
      requestId: json["data"]?["request_id"] as String?,
      currency: json["data"]?["currency"] as String?,
      dataStatus: json["data"]?["status"] as int?,
      dataMessage: json["data"]?["message"] as String?,
      uniqueId: json["data"]?["unique_id"] as String?,
    );
  }
}
