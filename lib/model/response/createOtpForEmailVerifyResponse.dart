import 'dart:convert';
import 'dart:ffi';

class CreateOtpVerifyEmailResponse {
  String email;
  String emailOtp;
  int emailOtpExpireAt;
  int userId;
  String phoneNumber;
  String createdAt;
  String updatedAt;
  String mobileOtp;
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

  });

  factory CreateOtpVerifyEmailResponse.fromJson(Map<String, dynamic> json){
    return CreateOtpVerifyEmailResponse (
      email : json['email'] as String,
      emailOtp : json['email_otp'] as String,
      emailOtpExpireAt : json['email_otp_expire_at'] as int,
      userId : json['id'] as int,
      phoneNumber : json['phone_number'] as String,
      createdAt : json['created_at'] as String,
      updatedAt : json['updated_at'] as String,
      mobileOtp : json["mobile_otp"] as String,
      mobileOtpExpireAt : json["mobile_otp_expire_at"] as int,
    );
  }
}

