class ExistingUserResponse{
  bool? userFound;
  String? message;
  bool? isProfileSetupDone;

  ExistingUserResponse({
    this.message,
    this.userFound,
    this.isProfileSetupDone
  });

  factory ExistingUserResponse.fromJson(Map<String, dynamic> json) {
    return ExistingUserResponse(
      message: json['message'] as String?,
      userFound: json['data']?['user_found'] as bool?,
      isProfileSetupDone: json['data']?['is_profile_setup_done'] as bool?,
    );
  }
}