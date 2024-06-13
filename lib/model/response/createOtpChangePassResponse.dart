import 'dart:convert';

class CreateOtpChangePassResponse {
  String mobileOtp;

  CreateOtpChangePassResponse({required this.mobileOtp});

  factory CreateOtpChangePassResponse.fromJson(Map<String, dynamic> json){
    return CreateOtpChangePassResponse (
      mobileOtp : json["mobile_otp"] as String,// Convert the customer object to JSON
    );
  }
}

