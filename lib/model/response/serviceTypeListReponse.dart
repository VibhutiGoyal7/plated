class ServiceTypeListResponse {
  String? message;
  int? status;
  List<ServiceTypeListDetails>? data;

  ServiceTypeListResponse({
    required this.message,
    required this.status,
    required this.data,
  });

  factory ServiceTypeListResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<ServiceTypeListDetails>? serviceTypeListDetails =
        list?.map((i) => ServiceTypeListDetails.fromJson(i)).toList();

    return ServiceTypeListResponse(
      message: json['message'] as String?,
      status: json['status'] as int?,
      data: serviceTypeListDetails,
    );
  }
}

class ServiceTypeListDetails {
  int? id;
  String? serviceName;
  String? payorioMethod;
  String? paymentMethod;
  String? countryId;
  String? status;
  String? createdAt;
  String? updatedAt;

  ServiceTypeListDetails({
    required this.id,
    required this.serviceName,
    required this.countryId,
    required this.payorioMethod,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceTypeListDetails.fromJson(Map<String, dynamic> json) {
    return ServiceTypeListDetails(
      id: json["id"] as int?,
      serviceName: json["service_name"] as String?,
      payorioMethod: json["payorio_method"] as String?,
      paymentMethod: json["payment_method"] as String?,
      countryId: json["country_id"] as String?,
      status: json["status"] as String?,
      createdAt: json["created_at"] as String?,
      updatedAt: json["updated_at"] as String?,
    );
  }
}