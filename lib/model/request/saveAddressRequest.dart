class SaveAddressRequest {
  SaveAddressDetails addressParams;

  SaveAddressRequest({required this.addressParams});

  Map<String, dynamic> toJson() {
    return {
      'address_params': addressParams.toJson(),
    };
  }
}

class SaveAddressDetails {
  String line1;
  String line2;
  String city;
  String state;
  String? postalCode;

  SaveAddressDetails({required this.line1, required this.line2, required this.city, required this.state, required this.postalCode});

  Map<String, dynamic> toJson() {
    return {
      'line1': line1,
      'line2': line2,
      'city': city,
      'state': state,
      'postal_code': postalCode,
    };
  }
}