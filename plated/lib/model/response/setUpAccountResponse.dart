import 'AddressDetails.dart';

class SetUpAccountResponse {
  final String? firstName;
  final String? lastName;
  final int? id;
  final String? phoneNumber;
  final String? createdAt;
  final String? email;
  final AddressDetails? address;
  final String? dob;
  final int? status;
  final String? dataStatus;
  final String? kycStatus;
  final String? message;
  final String? username;
  final String? balance;
  final int? activityPts;
  final String? vipLevel;
  final int? countryId;
  final String? countryName;
  final String? countryPhoneCode;
  final bool? isEmailVerified;

  SetUpAccountResponse({
    this.firstName,
    this.lastName,
    this.id,
    this.phoneNumber,
    this.createdAt,
    this.email,
    this.address,
    this.dob,
    this.status,
    this.dataStatus,
    this.isEmailVerified,
    this.kycStatus,
    this.message,
    this.username,
    this.countryPhoneCode,
    this.countryName,
    this.countryId,
    this.vipLevel,
    this.activityPts,
    this.balance,
  });

  factory SetUpAccountResponse.fromJson(Map<String, dynamic> json) {
    return SetUpAccountResponse(
      firstName: json['data']?['first_name'] as String?,
      lastName: json['data']?['last_name'] as String?,
      id: json['data']?['id'] as int?,
      phoneNumber: json['data']?['phone_number'] as String?,
      createdAt: json['data']?['created_at']/* != null
          ? DateTime.parse(json['data']['created_at'] */as String/*)
          : null*/,

      email: json['data']?['email'] as String?,
      address: json['data']?['address'] != null
          ? AddressDetails.fromJson(json['data']?['address'])
          : null,
      dob: json['data']?['dob'] as String?,
      kycStatus: json['data']?['kyc_status'] as String?,
      message: json['message'] as String?,
      status: json['status'] as int?,
      username: json['data']?['username'] as String?,
      balance: json['data']?['balance'] as String?,
      activityPts: json['data']?['activity_points'] as int?,
      vipLevel: json['data']?['vip_level'] as String?,
      countryId: json['data']?['country_id'] as int?,
      countryName: json['data']?['country_name'] as String?,
      countryPhoneCode: json['data']?['country_phone_code'] as String?,
      isEmailVerified: json['data']?['is_email_verified'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['id'] = this.id;
    data['phone_number'] = this.phoneNumber;
    data['email'] = this.email;
    data['address'] = this.address;
    data['kyc_status'] = this.kycStatus;
    data['created_at'] = this.createdAt ;
    data['status'] = this.status;
    data['dob'] = this.dob;
    data['is_email_verified'] = this.isEmailVerified;
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

  factory SetUpAccountResponse.fromPref(Map<String, dynamic> json) {
    return SetUpAccountResponse(
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      id: json['id'] as int?,
      phoneNumber: json['phone_number'] as String?,
      createdAt: json['created_at']/* != null
          ? DateTime.parse(json['created_at'] */as String/*)
          : null*/,
      email: json['email'] as String?,
      address: json['address'] != null
          ? AddressDetails.fromJson(json['address'])
          : null,
      dob: json['dob'] as String?,
      kycStatus: json['kyc_status'] as String?,
      balance: json['balance'] as String?,
      activityPts: json['activity_points'] as int?,
      vipLevel: json['vip_level'] as String?,
      countryId: json['country_id'] as int?,
      countryName: json['country_name'] as String?,
      countryPhoneCode: json['country_phone_code'] as String?,
      isEmailVerified: json['is_email_verified'] as bool?,
    );
  }
}
