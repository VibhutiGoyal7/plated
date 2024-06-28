import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ProfileResponse {
  final String? firstName;
  final String? lastName;
  final int? userId;
  final String? imageUrl;
  final String? email;
  final String? address;
  final String? dob;
  final String? status;
  final String? phoneNumber;
  final String? message;
  final String? username;
  final int? balance;
  final String? kycStatus;
  final int? activityPts;
  final String? vipLevel;
  final int? countryId;
  final String? countryName;
  final String? countryPhoneCode;
  final String? createdAt;
  final bool? isEmailVerified;

  ProfileResponse({
    this.firstName,
    this.lastName,
    this.userId,
    this.imageUrl,
    this.email,
    this.address,
    this.dob,
    this.status,
    this.phoneNumber,
    this.isEmailVerified,
    this.message,
    this.username,
    this.createdAt,
    this.countryPhoneCode,
    this.countryName,
    this.countryId,
    this.vipLevel,
    this.activityPts,
    this.kycStatus,
    this.balance,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      firstName: json['data']['first_name'] as String?,
      lastName: json['data']['last_name'] as String?,
      userId: json['data']['id'] as int?,
      imageUrl: json['data']['image_url'] as String?,
      phoneNumber: json['data']['phone_number'] as String?,
      email: json['data']['email'] as String?,
      address: json['data']['address'] as String?,
      dob: json['data']['dob'] as String?,
      isEmailVerified: json['data']['is_email_verified'] as bool?,
      username: json['data']['username'] as String?,
      balance: json['data']['balance'] as int?,
      kycStatus: json['data']['kyc_status'] as String?,
      activityPts: json['data']['activity_points'] as int?,
      vipLevel: json['data']['vip_level'] as String?,
      countryId: json['data']['country_id'] as int?,
      countryName: json['data']['country_name'] as String?,
      countryPhoneCode: json['data']['country_phone_code'] as String?,
      createdAt: json['data']['created_at'] as String?,
      message: json['message'] as String?,
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['id'] = this.userId;
    data['image_url'] = this.imageUrl;
    data['phone_number'] = this.phoneNumber;
    data['email'] = this.email;
    data['address'] = this.address;
    data['dob'] = this.dob;
    data['is_email_verified'] = this.isEmailVerified;
    data['message'] = this.message;
    data['username'] = this.username;
    data['created_at'] = this.createdAt;
    data['kyc_status'] = this.kycStatus;
    data['vip_level'] = this.vipLevel;
    data['balance'] = this.balance;
    data['country_id'] = this.countryId;
    data['country_name'] = this.countryName;
    data['country_phone_code'] = this.countryPhoneCode;
    data['activity_points'] = this.activityPts;
    return data;
  }
  factory ProfileResponse.fromPref(Map<String, dynamic> json) {
    return ProfileResponse(
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      userId: json['id'] as int?,
      imageUrl: json['image_url'] as String?,
      phoneNumber: json['phone_number'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      dob: json['dob'] as String?,
      username: json['username'] as String?,
      balance: json['balance'] as int?,
      kycStatus: json['kyc_status'] as String?,
      activityPts: json['activity_points'] as int?,
      vipLevel: json['vip_level'] as String?,
      countryId: json['country_id'] as int?,
      countryName: json['country_name'] as String?,
      countryPhoneCode: json['country_phone_code'] as String?,
      createdAt: json['created_at'] as String?,
      isEmailVerified: json['is_email_verified'] as bool?,
    );
  }

}
