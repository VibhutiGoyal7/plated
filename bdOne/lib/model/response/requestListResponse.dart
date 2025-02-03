import 'package:floor/floor.dart';

class RequestListResponse {
  String? message;
  int? status;
  List<RequestDetails>? data;

  RequestListResponse({
    required this.message,
    required this.status,
    required this.data,
  });

  factory RequestListResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List?; // Add a null check here
    List<RequestDetails>? requestList;

    if (list != null) {
      requestList = list.map((i) => RequestDetails.fromJson(i)).toList();
    } else {
      requestList = null; // Handle the case when data is null
    }

    return RequestListResponse(
      message: json['message'] as String?,
      status: json['status'] as int?,
      data: requestList,
    );
  }
}

@entity
class RequestDetails {
  @primaryKey
  int? id;
  String? pickUpLatitude;
  String? pickUpLongitude;
  String? uniqueId;
  String? dropLatitude;
  String? dropLongitude;
  String? distance;
  String? dropAddress;
  String? pickupAddress;
  String? serviceType;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? fare;
  String? estimatedFare;
  int? driverId;
  int? customerId;

  RequestDetails({
     this.id,
     this.distance,
     this.uniqueId,
     this.pickUpLatitude,
     this.pickUpLongitude,
     this.pickupAddress,
     this.status,
     this.serviceType,
     this.createdAt,
     this.updatedAt,
     this.dropLatitude,
     this.dropLongitude,
     this.dropAddress,
     this.estimatedFare,
     this.fare,
     this.driverId,
     this.customerId,
  });

  factory RequestDetails.fromJson(Map<String, dynamic> json) {
    return RequestDetails(
      id: json["id"] as int?,
      driverId: json["driver_id"] as int?,
      customerId: json["customer_id"] as int?,
      uniqueId: json["unique_id"] as String?,
      serviceType: json["service_type"] as String?,
      distance: json["distance"] as String?,
      pickUpLatitude: json["pickup_latitude"] as String?,
      estimatedFare: json["estimated_fare"] as String?,
      pickUpLongitude: json["pickup_longitude"] as String?,
      dropLatitude: json["destination_latitude"] as String?,
      status: json["status"] as String?,
      dropLongitude: json["destination_longitude"] as String?,
      pickupAddress: json["pickup_address"] as String?,
      dropAddress: json["destination_address"] as String?,
      fare: json["fare"] as String?,
      createdAt: json["created_at"] as String?,
      updatedAt: json["updated_at"] as String?,
    );
  }
}
