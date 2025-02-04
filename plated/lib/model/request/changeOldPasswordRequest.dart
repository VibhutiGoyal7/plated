class ChangeOldPassRequest {
  CustomerChangePassDetail customer;

  ChangeOldPassRequest({required this.customer});

  Map<String, dynamic> toJson() {
    return {
      'customer': customer.toJson(), // Convert the customer object to JSON
    };
  }
}

class CustomerChangePassDetail {
  String password;
  String newPassword;

  CustomerChangePassDetail({
    required this.password,
    required this.newPassword
  });
  Map<String, dynamic> toJson() {
    return {
      'new_password': newPassword,
      'password': password
    };
  }
}
