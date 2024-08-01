

import 'dart:convert';

class CheckCustomerResponse {
  String? username;
  String? fullName;
  String? phoneNumber;
  String? imageUrl;
  String? message;
  int? status;

  CheckCustomerResponse({
     this.username,
     this.fullName,
     this.phoneNumber,
     this.imageUrl,
    this.message,
    this.status,
  });

  factory CheckCustomerResponse.fromJson(Map<String, dynamic> json) {
    return CheckCustomerResponse(
      message: json["message"] as String?,
      status: json["status"] as int?,
      username: json['data']?["username"] as String?,
      fullName: json['data']?["full_name"] as String?,
      phoneNumber: json['data']?["phone_number"] as String?,
      imageUrl: json['data']?["image_url"] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['full_name'] = this.fullName;
    data['image_url'] = this.imageUrl;
    data['phone_number'] = this.phoneNumber;
    //data['message'] = this.message;
    data['username'] = this.username;
    return data;
  }
  factory CheckCustomerResponse.fromPref(Map<String, dynamic> json) {
    return CheckCustomerResponse(
      fullName: json['full_name'] as String?,
      imageUrl: json['image_url'] as String?,
      phoneNumber: json['phone_number'] as String?,
      username: json['username'] as String?,
    );
  }
  // Convert to JSON String
  String toJsonString() => json.encode(toJson());

  factory CheckCustomerResponse.fromJsonString(String source) {
    final Map<String, dynamic> jsonMap = json.decode(source);
    return CheckCustomerResponse(
      fullName: jsonMap['full_name'] as String?,
      imageUrl: jsonMap['image_url'] as String?,
      phoneNumber: jsonMap['phone_number'] as String?,
      username: jsonMap['username'] as String?,
    );
  }

  // Convert a JSON string to a CheckUser object
  factory CheckCustomerResponse.fromJsonPref(String source) =>
      CheckCustomerResponse.fromPref(json.decode(source));
}
