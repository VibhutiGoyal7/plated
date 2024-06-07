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
  });

  factory SetUpAccountResponse.fromJson(Map<String, dynamic> json) {
    return SetUpAccountResponse(
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      id: json['id'] as int?,
      phoneNumber: json['phone_number'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      email: json['email'] as String?,
      address: json['address'] as String?,
      dob: json['dob'] as String?,
      isEmailVerified: json['is_email_verified'] as bool?,
    );
  }
}
