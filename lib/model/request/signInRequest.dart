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

  CustomerSignIn({required this.phoneNumber, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'password': password,
    };
  }
}