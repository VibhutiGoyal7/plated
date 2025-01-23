
class DriverStatusResponse {
  final int? status;
  final String? pickup_latitude;
  final String? pickup_longitude;
  final String? destination_latitude;
  final String? destination_longitude;
  final String? estimatedDistance;
  final String? estimatedFare;
  final String? pickup_address;
  final String? rideStatus;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? driverCurrentLat;
  final String? driverCurrentLong;
  final String? message;
  final String? destination_address;

  DriverStatusResponse(
      {
      this.destination_latitude,
      this.status,
      this.destination_longitude,
      this.estimatedDistance,
      this.estimatedFare,
      this.pickup_address,
      this.pickup_latitude,
      this.rideStatus,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.driverCurrentLat,
      this.driverCurrentLong,
      this.message,
      this.pickup_longitude,
      this.destination_address,});

  factory DriverStatusResponse.fromJson(Map<String, dynamic> json) {

    return DriverStatusResponse(
      message: json['message'] as String?,
      status: json['status'] as int?,
      pickup_longitude: json['data']?['pickup_longitude'] as String?,
      pickup_latitude: json['data']?['pickup_latitude'] as String?,
      pickup_address: json['data']?['pickup_address'] as String?,
      estimatedFare: json['data']?['estimated_fare'] as String?,
      rideStatus: json['data']?['status'] as String?,
      firstName: json['data']?['first_name'] as String?,
      lastName: json['data']?['last_name'] as String?,
      phoneNumber: json['data']?['phone_number'] as String?,
      driverCurrentLat: json['data']?['driver_current_lat'] as String?,
      driverCurrentLong: json['data']?['driver_current_long'] as String?,
      estimatedDistance: json['data']?['estimated_distance'] as String?,
      destination_longitude: json['data']?['destination_longitude'] as String?,
      destination_latitude: json['data']?['destination_latitude'] as String?,
      destination_address: json['data']?['destination_address'] as String?,
    );
  }
}
