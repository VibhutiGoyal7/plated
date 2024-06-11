class CreateOtpEmailVerifyRequest {
  CustomerGetOtpEmailDetail customer;

  CreateOtpEmailVerifyRequest({required this.customer});

  Map<String, dynamic> toJson() {
    return {
      'customer': customer.toJson(), // Convert the customer object to JSON
    };
  }
}

class CustomerGetOtpEmailDetail {
  String phoneNumber;
  String email;


  CustomerGetOtpEmailDetail({
    required this.phoneNumber,
    required this.email
  });
  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'email': email
    };
  }
}
