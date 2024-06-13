import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';
//part 'profile_response.g.dart';


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
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      userId: json['id'] as int?,
      imageUrl: json['image_url'] as String?,
      phoneNumber: json['phone_number'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      dob: json['dob'] as String?,
      isEmailVerified: json['is_email_verified'] as bool?,
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
    return data;
  }

}
