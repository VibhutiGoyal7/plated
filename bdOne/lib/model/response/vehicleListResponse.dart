
class VehicleListResponse {
  final int? status;
  final String? pickup_latitude;
  final String? pickup_longitude;
  final String? destination_latitude;
  final String? destination_longitude;
  final String? estimated_distance;
  final String? fare;
  final String? pickup_address;
  final String? message;
  final String? destination_address;
  final List<VehicleDetails>? vehicles;

  VehicleListResponse(
      {
      this.destination_latitude,
      this.status,
      this.destination_longitude,
      this.estimated_distance,
      this.fare,
      this.pickup_address,
      this.pickup_latitude,
      this.message,
      this.pickup_longitude,
      this.vehicles,
      this.destination_address,});

  factory VehicleListResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data']?['vehicles'] as List;
    List<VehicleDetails>? vehicleList = list.map((i) => VehicleDetails.fromJson(i)).toList();

    return VehicleListResponse(
      message: json['message'] as String?,
      status: json['status'] as int?,
      pickup_longitude: json['data']?['pickup_longitude'] as String?,
      pickup_latitude: json['data']?['pickup_latitude'] as String?,
      pickup_address: json['data']?['pickup_address'] as String?,
      fare: json['data']?['fare'] as String?,
      destination_longitude: json['data']?['destination_longitude'] as String?,
      destination_latitude: json['data']?['destination_latitude'] as String?,
      destination_address: json['data']?['destination_address'] as String?,
      vehicles: vehicleList
    );
  }
}


class VehicleDetails {
  final int? id;
  final String? categoryName;
  final String? farePerKm;
  final String? estimatedDistance;
  final String? vehicleIcon;
  final String? estimatedFare;

  VehicleDetails(
      {
      this.id,
      this.categoryName,
      this.farePerKm,
      this.estimatedDistance,
      this.vehicleIcon,
      this.estimatedFare,});

  factory VehicleDetails.fromJson(Map<String, dynamic> json) {
    return VehicleDetails(
      id: json['id'] as int?,
      categoryName: json['category_name'] as String?,
      farePerKm: json['fare_per_km'] as String?,
      estimatedDistance: json['estimated_distance'] as String?,
      vehicleIcon: json['vehicle_icon'] as String?,
      estimatedFare: json['estimated_fare'] as String?,
    );
  }
}
