import 'AddressDetails.dart';

class SignInResponse {
  final String? firstName;
  final String? lastName;
  final int? id;
  final String? phoneNumber;
  final String? createdAt;
  final String? email;
  final AddressDetails? address;
  final String? dob;
  final String? token;
  final String? kycStatus;
  final int? status;
  final bool? isEmailVerified;
  final String? message;
  final int? activityPoints;
  final int? countryId;
  final String? balance;
  final String? vipLevel;
  final bool? isProfileSetupDone;
  final String? username;
  final String? countryName;
  final String? countryCurrencySymbol;
  final String? tpin;
  final String? countryPhoneCode;

  SignInResponse(
      {this.firstName,
      this.lastName,
      this.id,
      this.phoneNumber,
      this.createdAt,
      this.email,
      this.address,
      this.dob,
      this.status,
      this.isEmailVerified,
      this.token,
      this.message,
      this.kycStatus,
      this.activityPoints,
      this.countryId,
      this.balance,
      this.isProfileSetupDone,
      this.vipLevel,
      this.countryName,
      this.countryCurrencySymbol,
      this.tpin,
      this.countryPhoneCode,
      this.username});

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      message: json['message'] as String?,
      status: json['status'] as int?,
      firstName: json['data']?['customer']?['first_name'] as String?,
      lastName: json['data']?['customer']?['last_name'] as String?,
      id: json['data']?['customer']?['id'] as int?,
      phoneNumber: json['data']?['customer']?['phone_number'] as String?,
      createdAt: json['data']?['customer']?['created_at'] as String?,
      email: json['data']?['customer']?['email'] as String?,
      countryName: json['data']?['customer']?['country_name'] as String?,
      address: json['data']?['customer']?['address'] != null
          ? AddressDetails.fromJson(json['data']?['customer']?['address'])
          : null,
      dob: json['data']?['customer']?['dob'] as String?,
      isEmailVerified: json['data']?['customer']?['is_email_verified'] as bool?,
      kycStatus: json['data']?['customer']?['kyc_status'] as String?,
      vipLevel: json['data']?['customer']?['vip_level'] as String?,
      balance: json['data']?['customer']?['balance'] as String?,
      username: json['data']?['customer']?['username'] as String?,
      countryCurrencySymbol:
          json['data']?['customer']?['country_currency_symbol'] as String?,
      countryPhoneCode:
          json['data']?['customer']?['country_phone_code'] as String?,
      tpin: json['data']?['customer']?['tpin'] as String?,
      countryId: json['data']?['customer']?['country_id'] as int?,
      isProfileSetupDone:
          json['data']?['customer']?['is_profile_setup_done'] as bool?,
      activityPoints: json['data']?['customer']?['activity_points'] as int?,
      token: json['data']?['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['id'] = this.id;
    data['phone_number'] = this.phoneNumber;
    data['email'] = this.email;
    data['address'] = this.address?.toJson();
    data['kyc_status'] = this.kycStatus;
    data['created_at'] = this.createdAt;
    data['status'] = this.status;
    data['dob'] = this.dob;
    data['country_currency_symbol'] = this.countryCurrencySymbol;
    data['country_phone_code'] = this.countryPhoneCode;
    data['tpin'] = this.tpin;
    data['is_email_verified'] = this.isEmailVerified;
    return data;
  }

  factory SignInResponse.fromPref(Map<String, dynamic> json) {
    return SignInResponse(
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      id: json['id'] as int?,
      phoneNumber: json['phone_number'] as String?,
      createdAt: json[
              'created_at'] /* != null
          ? DateTime.parse(json['created_at'] */
          as String /*)
          : null*/
      ,
      email: json['email'] as String?,
      countryCurrencySymbol: json['country_currency_symbol'] as String?,
      countryPhoneCode: json['country_phone_code'] as String?,
      tpin: json['tpin'] as String?,
      address: json['address'] != null
          ? AddressDetails.fromJson(json['address'])
          : null,
      dob: json['dob'] as String?,
      kycStatus: json['kyc_status'] as String?,
      isEmailVerified: json['is_email_verified'] as bool?,
    );
  }
}
