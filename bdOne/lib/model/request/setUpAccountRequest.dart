class SetUpAccountRequest {
  CustomerDetail customer;

  SetUpAccountRequest({required this.customer});

  Map<String, dynamic> toJson() {
    return {
      'customer': customer.toJson(), // Convert the customer object to JSON
    };
  }
}

class CustomerDetail {
  String email;
  String password;
  String firstName;
  String lastName;
  String dob;
  String latitude;
  String longitude;

  CustomerDetail({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
      'dob': dob,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
