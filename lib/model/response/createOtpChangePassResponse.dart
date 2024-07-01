

class CreateOtpChangePassResponse {
  String mobileOtp;
  String message;

  CreateOtpChangePassResponse({
    required this.mobileOtp,
    required this.message,
  });

  factory CreateOtpChangePassResponse.fromJson(Map<String, dynamic> json) {
    return CreateOtpChangePassResponse(
      mobileOtp: json['data']?["mobile_otp"] as String,
      message: json["message"] as String,
    );
  }
}
