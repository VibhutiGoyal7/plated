class ExistingUserResponse{
  bool? userFound;
  String? message;
  int? status;
  bool? isProfileSetupDone;

  ExistingUserResponse({
    this.message,
    this.status,
    this.userFound,
    this.isProfileSetupDone
  });

  factory ExistingUserResponse.fromJson(Map<String, dynamic> json) {
    return ExistingUserResponse(
      message: json['message'] as String?,
      status: json['status'] as int?,
      userFound: json['data']?['user_found'] as bool?,
      isProfileSetupDone: json['data']?['is_profile_setup_done'] as bool?,
    );
  }
}