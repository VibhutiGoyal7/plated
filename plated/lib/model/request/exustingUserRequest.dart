class ExistingUserRequest {
  ExistingCustomer customer;

  ExistingUserRequest({required this.customer});

  Map<String, dynamic> toJson() {
    return {
      'customer': customer.toJson(), // Convert the customer object to JSON
    };
  }
}

class ExistingCustomer {
  String phoneNumber;

  ExistingCustomer({required this.phoneNumber});

  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
    };
  }
}