class OtpVerifyResponse {
  final String? firstName;
  final String? lastName;
  final int? id;
  final String? phoneNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? email;
  final String? address;
  final String? dob;
  final String? token;
  final String? status;
  final bool? isEmailVerified;

  OtpVerifyResponse({
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
    this.token,
  });

  factory OtpVerifyResponse.fromJson(Map<String, dynamic> json) {
    return OtpVerifyResponse(
      firstName: json['customer']?['first_name'] as String?,
      lastName: json['customer']?['last_name'] as String?,
      id: json['customer']?['id'] as int?,
      phoneNumber: json['customer']?['phone_number'] as String?,
      createdAt: json['customer']?['created_at'] != null
          ? DateTime.parse(json['customer']?['created_at'] as String)
          : null,
      updatedAt: json['customer']?['updated_at'] != null
          ? DateTime.parse(json['customer']?['updated_at'] as String)
          : null,
      email: json['customer']?['email'] as String?,
      address:  json['customer']?['address'] as String?,
      dob:  json['customer']?['dob'] as String?,
      isEmailVerified:  json['customer']?['is_email_verified'] as bool?,
      token:  json['token'] as String?,
    );
  }
}
