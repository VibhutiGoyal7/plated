class ExistingUserResponse{
  bool? userFound;
  String? message;

  ExistingUserResponse({
    this.message,
    this.userFound
  });

  factory ExistingUserResponse.fromJson(Map<String, dynamic> json) {
    return ExistingUserResponse(
      message: json['message'] as String?,
      userFound: json['data']['user_found'] as bool?,
    );
  }
}