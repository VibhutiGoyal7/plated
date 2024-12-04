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
  int countryCode;

  CustomerGetOtpPassDetail({
    required this.phoneNumber,
    required this.countryCode,
  });
  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'country_id': countryCode,
    };
  }
}
