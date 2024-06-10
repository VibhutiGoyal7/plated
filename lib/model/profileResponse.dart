import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';
//part 'profile_response.g.dart';


@JsonSerializable()
class ProfileResponse {
  final String? firstName;
  final String? lastName;
  final int? userId;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
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
    this.createdAt,
    this.updatedAt,
    this.email,
    this.address,
    this.dob,
    this.status,
    this.phoneNumber,
    this.isEmailVerified,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      firstName: json['data']['first_name'] as String?,
      lastName: json['data']['last_name'] as String?,
      userId: json['data']['id'] as int?,
      imageUrl: json['data']['image_url'] as String?,
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
      isEmailVerified: json['data']['is_email_verified'] as bool?,
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    final Map<String, dynamic> nestedData = {};

    nestedData['first_name'] = this.firstName;
    nestedData['last_name'] = this.lastName;
    nestedData['id'] = this.userId;
    nestedData['image_url'] = this.imageUrl;
    nestedData['phone_number'] = this.phoneNumber;
    nestedData['created_at'] = this.createdAt?.toIso8601String();
    nestedData['updated_at'] = this.updatedAt?.toIso8601String();
    nestedData['email'] = this.email;
    nestedData['address'] = this.address;
    nestedData['dob'] = this.dob;
    nestedData['is_email_verified'] = this.isEmailVerified;

    data['data'] = nestedData;
    return data;
  }

}
