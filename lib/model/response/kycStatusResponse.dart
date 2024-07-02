class KycStatusResponse {
  final String? kycStatus;
  final String? message;

  KycStatusResponse({
    this.kycStatus,
    this.message,
  });

  factory KycStatusResponse.fromJson(Map<String, dynamic> json) {
    return KycStatusResponse(
      kycStatus: json['data']['kyc_status'] as String?,
      message: json['message'] as String?,
    );
  }
}
