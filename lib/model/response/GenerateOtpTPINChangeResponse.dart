class GenerateOtpTPINChangeResponse {
  final String? otp;
  final String? message;

  GenerateOtpTPINChangeResponse({
    this.otp,
    this.message,
  });

  factory GenerateOtpTPINChangeResponse.fromJson(Map<String, dynamic> json) {
    return GenerateOtpTPINChangeResponse(
      otp: json['data']['otp'] as String?,
      message: json['message'] as String?,
    );
  }
}