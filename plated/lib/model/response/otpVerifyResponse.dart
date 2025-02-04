import 'AddressDetails.dart';

class OtpVerifyResponse {
  final String? firstName;
  final String? lastName;
  final int? id;
  final String? phoneNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? email;
  final AddressDetails? address;
  final String? dob;
  final String? token;
  final String? kycStatus;
  final String? dataStatus;
  final bool? isEmailVerified;
  final String? mobileOtpExpireAt;
  final String? mobileOtp;
  final String? message;
  final int? status;

  OtpVerifyResponse(
      {this.firstName,
      this.lastName,
      this.id,
      this.phoneNumber,
      this.createdAt,
      this.updatedAt,
      this.email,
      this.address,
      this.dob,
      this.status,
      this.isEmailVerified,
      this.mobileOtpExpireAt,
      this.mobileOtp,
      this.token,
      this.message,
      this.dataStatus,
      this.kycStatus});

  factory OtpVerifyResponse.fromJson(Map<String, dynamic> json) {
    return OtpVerifyResponse(
      token: json['data']?['token'] as String?,
      message: json['message'] as String?,
      status: json['status'] as int?,
      firstName: json['data']?['customer']?['first_name'] as String?,
      lastName: json['data']?['customer']?['last_name'] as String?,
      id: json['data']?['customer']?['id'] as int?,
      phoneNumber: json['data']?['customer']?['phone_number'] as String?,
      createdAt: json['data']?['customer']?['created_at'] != null
          ? DateTime.parse(json['data']?['customer']?['created_at'] as String)
          : null,
      updatedAt: json['data']?['customer']?['updated_at'] != null
          ? DateTime.parse(json['data']?['customer']?['updated_at'] as String)
          : null,
      email: json['data']?['customer']?['email'] as String?,
      address: json['data']?['customer']?['address'] != null
          ? AddressDetails.fromJson(json['data']?['customer']?['address'])
          : null,
      dob: json['data']?['customer']?['dob'] as String?,
      isEmailVerified: json['data']?['customer']?['is_email_verified'] as bool?,
      mobileOtpExpireAt:
          json['data']?['customer']?['mobile_otp_expire_at'] as String?,
      mobileOtp: json['data']?['customer']?['mobile_otp'] as String?,
      kycStatus: json['data']?['customer']?['kyc_status'] as String?,
    );
  }
}
