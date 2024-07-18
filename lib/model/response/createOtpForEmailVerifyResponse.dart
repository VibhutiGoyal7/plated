class CreateOtpVerifyEmailResponse {
  String email;
  String emailOtp;
  int emailOtpExpireAt;
  int userId;
  String phoneNumber;
  String createdAt;
  String updatedAt;
  String mobileOtp;
  String message;
  int mobileOtpExpireAt;



  CreateOtpVerifyEmailResponse({
    required this.email,
    required this.emailOtp,
    required this.emailOtpExpireAt,
    required this.userId,
    required this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.mobileOtp,
    required this.mobileOtpExpireAt,
    required this.message,

  });

  factory CreateOtpVerifyEmailResponse.fromJson(Map<String, dynamic> json){
    return CreateOtpVerifyEmailResponse (
      message : json["message"] as String,
      email : json['data']?['email'] as String,
      emailOtp : json['data']?['email_otp'] as String,
      emailOtpExpireAt : json['data']?['email_otp_expire_at'] as int,
      userId : json['data']?['id'] as int,
      phoneNumber : json['data']?['phone_number'] as String,
      createdAt : json['data']?['created_at'] as String,
      updatedAt : json['data']?['updated_at'] as String,
      mobileOtp : json['data']?["mobile_otp"] as String,
      mobileOtpExpireAt : json['data']?["mobile_otp_expire_at"] as int,
    );
  }
}

