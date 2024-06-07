class PhoneRequest {
  Customer customer;

  PhoneRequest({required this.customer});

  Map<String, dynamic> toJson() {
    return {
      'temp_customer': customer.toJson(), // Convert the customer object to JSON
    };
  }
}

class Customer {
  String phoneNumber;
  String mobileOtp;

  Customer({required this.phoneNumber, required this.mobileOtp});

  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'mobile_otp': mobileOtp,
    };
  }
}