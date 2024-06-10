class VerifyOtChangePassRequest {
  CustomerVerifyOtpPass customer;

  VerifyOtChangePassRequest({required this.customer});

  Map<String, dynamic> toJson() {
    return {
      'customer': customer.toJson(), // Convert the customer object to JSON
    };
  }
}

class CustomerVerifyOtpPass {
  String password;
  String phoneNumber;
  String mobileOtp;


  CustomerVerifyOtpPass({
    required this.password,
    required this.phoneNumber,
    required this.mobileOtp
  });
  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'password': password,
      'mobile_otp': mobileOtp

    };
  }
}
