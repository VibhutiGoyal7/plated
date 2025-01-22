class RideRequest {
  String? customerName;
  String? custPhone;
  String? customerEmail;
  String? serviceType;
  String? pickupLatitude;
  String? pickupLongitude;
  String? destinationLatitude;
  String? destinationLongitude;
  String? fare;

  RideRequest({
    required this.customerName,
    required this.custPhone,
    required this.customerEmail,
    required this.serviceType,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.destinationLatitude,
    required this.destinationLongitude,
    required this.fare,
  });

  Map<String, dynamic> toJson() {
    return {
      'customer_name': customerName,
      'cust_phone': custPhone,
      'customer_email': customerEmail,
      'service_type': serviceType,
      'pickup_latitude': pickupLatitude,
      'pickup_longitude': pickupLongitude,
      'destination_latitude': destinationLatitude,
      'destination_longitude': destinationLongitude,
      'fare': fare,
    };
  }
}
