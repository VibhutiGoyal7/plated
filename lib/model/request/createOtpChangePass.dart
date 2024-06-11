class CreateOtpChangePassRequest {
  CustomerGetOtpPassDetail customer;

  CreateOtpChangePassRequest({required this.customer});

  Map<String, dynamic> toJson() {
    return {
      'customer': customer.toJson(), // Convert the customer object to JSON
    };
  }
}

class CustomerGetOtpPassDetail {
  String phoneNumber;

  CustomerGetOtpPassDetail({
    required this.phoneNumber,
  });
  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
    };
  }
}
