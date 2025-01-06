class SignUpRequest {
  CustomerSignUp customer;

  SignUpRequest({required this.customer});

  Map<String, dynamic> toJson() {
    return {
      'customer': customer.toJson(), // Convert the customer object to JSON
    };
  }
}

class CustomerSignUp {
  String phoneNumber;
  String email;

  CustomerSignUp({required this.phoneNumber, required this.email});

  Map<String, dynamic> toJson() {
    return {'phone_number': phoneNumber, 'email': email};
  }
}
