class TransactionProviderListResponse {
  String? message;
  int? status;
  List<TransactionProvidersListDetails>? data;

  TransactionProviderListResponse({
    required this.message,
    required this.status,
    required this.data,
  });

  factory TransactionProviderListResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<TransactionProvidersListDetails>? serviceTypeListDetails =
    list.map((i) => TransactionProvidersListDetails.fromJson(i)).toList();

    return TransactionProviderListResponse(
      message: json['message'] as String?,
      status: json['status'] as int?,
      data: serviceTypeListDetails,
    );
  }
}

class TransactionProvidersListDetails {
  int? id;
  String? serviceName;
  int? transactionMethodId;
  String? status;
  String? createdAt;
  String? updatedAt;

  TransactionProvidersListDetails({
    required this.id,
    required this.serviceName,
    required this.transactionMethodId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionProvidersListDetails.fromJson(Map<String, dynamic> json) {
    return TransactionProvidersListDetails(
      id: json["id"] as int?,
      serviceName: json["name"] as String?,
      transactionMethodId: json["transaction_method_id"] as int?,
      status: json["status"] as String?,
      createdAt: json["created_at"] as String?,
      updatedAt: json["updated_at"] as String?,
    );
  }
}