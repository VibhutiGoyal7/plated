class SignInRequest {
  CustomerSignIn customer;

  SignInRequest({required this.customer});

  Map<String, dynamic> toJson() {
    return {
      'customer': customer.toJson(), // Convert the customer object to JSON
    };
  }
}

class CustomerSignIn {
  String phoneNumber;
  String password;
  String? deviceToken;

  CustomerSignIn({required this.phoneNumber, required this.password, required this.deviceToken});

  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'password': password,
      'device_token': deviceToken,
    };
  }
}