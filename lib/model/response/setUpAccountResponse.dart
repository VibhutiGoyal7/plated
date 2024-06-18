class SetUpAccountResponse {
  final String? firstName;
  final String? lastName;
  final int? id;
  final String? phoneNumber;
  final String? createdAt;
  final String? updatedAt;
  final String? email;
  final String? address;
  final String? dob;
  final String? status;
  final String? kycStatus;
  final String? message;
  final bool? isEmailVerified;
  final String? mobileOtp;
  final String? mobileOtpExpireAt;

  SetUpAccountResponse({
    this.firstName,
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
    this.kycStatus,
    this.message
    this.mobileOtp,
    this.mobileOtpExpireAt,
  });

  factory SetUpAccountResponse.fromJson(Map<String, dynamic> json) {
    return SetUpAccountResponse(
      firstName: json['data']['first_name'] as String?,
      lastName: json['data']['last_name'] as String?,
      id: json['data']['id'] as int?,
      phoneNumber: json['data']['phone_number'] as String?,
      createdAt: json['data']['created_at']/* != null
          ? DateTime.parse(json['data']['created_at'] */as String/*)
          : null*/,
      updatedAt: json['data']['updated_at']/* != null
          ? DateTime.parse(json['data']['updated_at']*/ as String?/*)
          : null*/,
      email: json['data']['email'] as String?,
      address: json['data']['address'] as String?,
      dob: json['data']['dob'] as String?,
      kycStatus: json['data']['kyc_status'] as String?,
      message: json['message'] as String?,
      mobileOtp: json['data']['mobile_otp'] as String?,
      mobileOtpExpireAt: json['data']['mobile_otp_expire_at'] as String?,
      isEmailVerified: json['data']['is_email_verified'] as bool?,
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
    data['updated_at'] = this.updatedAt;
    data['status'] = this.status;
    data['dob'] = this.dob;
    data['mobile_otp'] = this.mobileOtp;
    data['mobile_otp_expire_at'] = this.mobileOtpExpireAt;
    data['is_email_verified'] = this.isEmailVerified;
    return data;
  }
}
