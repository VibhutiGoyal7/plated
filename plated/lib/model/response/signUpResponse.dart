class SignUpResponse {
  final String? email;
  final String? phone_number;
  final bool? success;
  final String? message;
  final int? status;

  SignUpResponse({
    this.email,
    this.phone_number,
    this.success,
    this.message,
    this.status,
  });

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      message: json['message'] as String?,
      email: json['data']?['email'] as String?,
      phone_number: json['data']?['phone_number'] as String?,
      status: json['status'] as int?,
      success: json['success'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['message'] = this.message;
    data['email'] = this.email;
    data['phone_number'] = this.phone_number;
    data['status'] = this.status;
    data['success'] = this.success;
    return data;
  }

  factory SignUpResponse.fromPref(Map<String, dynamic> json) {
    return SignUpResponse(
      message: json['message'] as String?,
      email: json['email'] as String?,
      phone_number: json['phone_number'] as String?,
      status: json['status'] as int?,
      success: json['success'] as bool?,
    );
  }
}
