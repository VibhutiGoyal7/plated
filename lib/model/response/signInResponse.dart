class SignInResponse {
  final String? firstName;
  final String? lastName;
  final int? id;
  final String? phoneNumber;
  final String? createdAt;
  final String? updatedAt;
  final String? email;
  final String? address;
  final String? dob;
  final String? token;
  final String? kycStatus;
  final String? status;
  final bool? isEmailVerified;
  final String? mobileOtpExpireAt;
  final String? mobileOtp;
  final String? message;

  SignInResponse(
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
        this.kycStatus});

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      firstName: json['data']['customer']?['first_name'] as String?,
      lastName: json['data']['customer']?['last_name'] as String?,
      id: json['data']['customer']?['id'] as int?,
      phoneNumber: json['data']['customer']?['phone_number'] as String?,
      createdAt: json['data']['customer']?['created_at'] /*!= null
          ? DateTime.parse(json['data']['customer']?['created_at']*/ as String?/*)
          : null,*/,
      updatedAt: json['data']['customer']?['updated_at'] /*!= null
          ? DateTime.parse(json['data']['customer']?['updated_at']*/ as String/*)
          : null,*/,
      email: json['data']['customer']?['email'] as String?,
      address: json['data']['customer']?['address'] as String?,
      dob: json['data']['customer']?['dob'] as String?,
      isEmailVerified: json['data']['customer']?['is_email_verified'] as bool?,
      mobileOtpExpireAt: json['data']['customer']?['mobile_otp_expire_at'] as String?,
      mobileOtp: json['data']['customer']?['mobile_otp'] as String?,
      kycStatus: json['data']['customer']?['kyc_status'] as String?,
      token: json['data']['token'] as String?,
      message: json['message'] as String?,
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

  factory SignInResponse.fromPref(Map<String, dynamic> json) {
    return SignInResponse(
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      id: json['id'] as int?,
      phoneNumber: json['phone_number'] as String?,
      createdAt: json['created_at']/* != null
          ? DateTime.parse(json['created_at'] */as String/*)
          : null*/,
      updatedAt: json['updated_at']/* != null
          ? DateTime.parse(json['updated_at']*/ as String?/*)
          : null*/,
      email: json['email'] as String?,
      address: json['address'] as String?,
      dob: json['dob'] as String?,
      kycStatus: json['kyc_status'] as String?,
      mobileOtp: json['mobile_otp'] as String?,
      mobileOtpExpireAt: json['mobile_otp_expire_at'] as String?,
      isEmailVerified: json['is_email_verified'] as bool?,
    );
  }
}
