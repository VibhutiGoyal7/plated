class VerifyOtpEmailVerifyRequest {
  CustomerVerifyOtpEmail customer;

  VerifyOtpEmailVerifyRequest({required this.customer});

  Map<String, dynamic> toJson() {
    return {
      'customer': customer.toJson(), // Convert the customer object to JSON
    };
  }
}

class CustomerVerifyOtpEmail {
  String email;
  String phoneNumber;
  String emailOtp;


  CustomerVerifyOtpEmail({
    required this.email,
    required this.phoneNumber,
    required this.emailOtp
  });
  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'email': email,
      'email_otp': emailOtp

    };
  }
}
