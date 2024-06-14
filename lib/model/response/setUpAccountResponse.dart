class SetUpAccountResponse {
  final String? firstName;
  final String? lastName;
  final int? id;
  final String? phoneNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? email;
  final String? address;
  final String? dob;
  final String? status;
  final String? kycStatus;
  final String? message;
  final bool? isEmailVerified;

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
  });

  factory SetUpAccountResponse.fromJson(Map<String, dynamic> json) {
    return SetUpAccountResponse(
      firstName: json['data']['first_name'] as String?,
      lastName: json['data']['last_name'] as String?,
      id: json['data']['id'] as int?,
      phoneNumber: json['data']['phone_number'] as String?,
      createdAt: json['data']['created_at'] != null
          ? DateTime.parse(json['data']['created_at'] as String)
          : null,
      updatedAt: json['data']['updated_at'] != null
          ? DateTime.parse(json['data']['updated_at'] as String)
          : null,
      email: json['data']['email'] as String?,
      address: json['data']['address'] as String?,
      dob: json['data']['dob'] as String?,
      kycStatus: json['data']['kyc_status'] as String?,
      message: json['message'] as String?,
      isEmailVerified: json['data']['is_email_verified'] as bool?,
    );
  }
}
