class AddressDetails {
  String? line1;
  String? line2;
  String? city;
  String? state;
  String? postal_code;

  AddressDetails({
    this.line1,
    this.line2,
    this.city,
    this.state,
    this.postal_code,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['line1'] = this.line1;
    data['line2'] = this.line2;
    data['city'] = this.city;
    data['state'] = this.state;
    data['postal_code'] = this.postal_code;
    return data;
  }

  factory AddressDetails.fromJson(Map<String, dynamic> json) {
    return AddressDetails(
      line1: json["line1"] as String?,
      line2: json["line2"] as String?,
      city: json["city"] as String?,
      state: json["state"] as String?,
      postal_code: json["postal_code"] as String?,
    );
  }
}