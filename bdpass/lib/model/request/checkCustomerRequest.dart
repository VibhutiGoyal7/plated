class CheckCustomerRequest {
  String? username;
  String? phoneNo;

  CheckCustomerRequest({
    required this.username,
    required this.phoneNo,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'phone_number': phoneNo,
    };
  }
}
