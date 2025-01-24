class VehicleListRequest {
  String? pickupLatitude;
  String? pickupLongitude;
  String? destinationLatitude;
  String? destinationLongitude;

  VehicleListRequest({
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.destinationLatitude,
    required this.destinationLongitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'pickup_latitude': pickupLatitude,
      'pickup_longitude': pickupLongitude,
      'destination_latitude': destinationLatitude,
      'destination_longitude': destinationLongitude,
    };
  }
}
