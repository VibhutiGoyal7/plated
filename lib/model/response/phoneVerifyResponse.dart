class PhoneVerifyResponse {
  final String? mobileOtp;
  final int? mobileOtpExpireAt;
  final int? id;
  final String? phoneNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? email;
  final String? emailOtp;
  final String? message;
  final int? emailOtpExpireAt;

  PhoneVerifyResponse({
    this.mobileOtp,
    this.mobileOtpExpireAt,
    this.id,
    this.phoneNumber,
    this.createdAt,
    this.updatedAt,
    this.email,
    this.emailOtp,
    this.emailOtpExpireAt,
    this.message,
  });

  factory PhoneVerifyResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] == null) {
      return PhoneVerifyResponse(message: json['message'] as String?);
    }
    return PhoneVerifyResponse(
      mobileOtp: json['data']['mobile_otp'] as String?,
      mobileOtpExpireAt: json['data']['mobile_otp_expire_at'] as int?,
      id: json['data']['id'] as int?,
      phoneNumber: json['data']['phone_number'] as String?,
      createdAt: json['data']['created_at'] != null
          ? DateTime.parse(json['data']['created_at'] as String)
          : null,
      updatedAt: json['data']['updated_at'] != null
          ? DateTime.parse(json['data']['updated_at'] as String)
          : null,
      email: json['data']['email'] as String?,
      emailOtp: json['data']['email_otp'] as String?,
      emailOtpExpireAt: json['data']['email_otp_expire_at'] as int?,
      message: json['message'] as String?,
    );
  }
}
