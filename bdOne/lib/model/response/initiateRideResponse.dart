
class InitiateRideResponse {
  final int? id;
  final String? customer_name;
  final String? cust_phone;
  final String? customer_email;
  final String? service_type;
  final String? intStatus;
  final int? status;
  final String? pickup_latitude;
  final String? pickup_longitude;
  final String? destination_latitude;
  final String? destination_longitude;
  final bool? notification_sent;
  final String? auto_cancel_at;
  final String? unique_id;
  final String? fare;
  final String? driver_id;
  final String? pickup_address;
  final String? message;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  InitiateRideResponse(
      {this.customer_name,
      this.cust_phone,
      this.id,
      this.unique_id,
      this.createdAt,
      this.updatedAt,
      this.auto_cancel_at,
      this.customer_email,
      this.destination_latitude,
      this.status,
      this.intStatus,
      this.destination_longitude,
      this.driver_id,
      this.fare,
      this.notification_sent,
      this.pickup_address,
      this.pickup_latitude,
      this.message,
      this.pickup_longitude,
      this.service_type});

  factory InitiateRideResponse.fromJson(Map<String, dynamic> json) {
    return InitiateRideResponse(
      message: json['message'] as String?,
      status: json['status'] as int?,
      service_type: json['data']?['service_type'] as String?,
      pickup_longitude: json['data']?['pickup_longitude'] as String?,
      id: json['data']?['id'] as int?,
      intStatus: json['data']?['status'] as String?,
      createdAt: json['data']?['created_at'] != null
          ? DateTime.parse(json['data']?['created_at'] as String)
          : null,
      updatedAt: json['data']?['updated_at'] != null
          ? DateTime.parse(json['data']?['updated_at'] as String)
          : null,
      pickup_latitude: json['data']?['pickup_latitude'] as String?,
      pickup_address: json['data']?['pickup_address'] as String?,
      notification_sent: json['data']?['notification_sent'] as bool?,
      fare: json['data']?['fare'] as String?,
      driver_id:
          json['data']?['driver_id'] as String?,
      destination_longitude: json['data']?['destination_longitude'] as String?,
      destination_latitude: json['data']?['destination_latitude'] as String?,
       customer_email: json['data']?['customer_email'] as String?,
      auto_cancel_at: json['data']?['auto_cancel_at'] as String?,
      cust_phone: json['data']?['cust_phone'] as String?,
      customer_name: json['data']?['customer_name'] as String?,
      unique_id: json['data']?['unique_id'] as String?,
    );
  }
}
