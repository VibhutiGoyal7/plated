class KycStatusResponse {
  final String? kycStatus;
  final String? message;
  final int? status;

  KycStatusResponse({
    this.kycStatus,
    this.message,
    this.status,
  });

  factory KycStatusResponse.fromJson(Map<String, dynamic> json) {
    return KycStatusResponse(
      kycStatus: json['data']['kyc_status'] as String?,
      message: json['message'] as String?,
      status: json['status'] as int?,
    );
  }
}
