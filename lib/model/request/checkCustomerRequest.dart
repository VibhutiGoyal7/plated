class CheckCustomerRequest {
  String? username;

  CheckCustomerRequest({
    required this.username,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
    };
  }
}
