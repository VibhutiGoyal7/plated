class GenerateOtpTPINChangeResponse {
  final String? otp;
  final String? message;
  final int? status;

  GenerateOtpTPINChangeResponse({
    this.otp,
    this.message,
    this.status,
  });

  factory GenerateOtpTPINChangeResponse.fromJson(Map<String, dynamic> json) {
    return GenerateOtpTPINChangeResponse(
      otp: json['data']['otp'] as String?,
      message: json['message'] as String?,
      status: json['status'] as int?,
    );
  }
}