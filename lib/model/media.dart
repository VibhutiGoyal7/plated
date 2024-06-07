class Media {
  final String? mobileOtp;
  final int? mobileOtpExpireAt;
  final int? id;
  final String? phoneNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? email;
  final String? emailOtp;
  final int? emailOtpExpireAt;

  Media({
    this.mobileOtp,
    this.mobileOtpExpireAt,
    this.id,
    this.phoneNumber,
    this.createdAt,
    this.updatedAt,
    this.email,
    this.emailOtp,
    this.emailOtpExpireAt,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      mobileOtp: json['mobile_otp'] as String?,
      mobileOtpExpireAt: json['mobile_otp_expire_at'] as int?,
      id: json['id'] as int?,
      phoneNumber: json['phone_number'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      email: json['email'] as String?,
      emailOtp: json['email_otp'] as String?,
      emailOtpExpireAt: json['email_otp_expire_at'] as int?,
    );
  }
}
