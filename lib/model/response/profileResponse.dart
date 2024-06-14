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
    return data;
  }

}
