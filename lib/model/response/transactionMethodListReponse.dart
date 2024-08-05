class TransactionMethodListResponse {
  String? message;
  int? status;
  List<TransactionMethodListDetails>? data;

  TransactionMethodListResponse({
    required this.message,
    required this.status,
    required this.data,
  });

  factory TransactionMethodListResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<TransactionMethodListDetails>? serviceTypeListDetails =
    list?.map((i) => TransactionMethodListDetails.fromJson(i)).toList();

    return TransactionMethodListResponse(
      message: json['message'] as String?,
      status: json['status'] as int?,
      data: serviceTypeListDetails,
    );
  }
}

class TransactionMethodListDetails {
  int? id;
  String? serviceName;
  int? transactionTypeId;
  String? status;
  String? createdAt;
  String? updatedAt;

  TransactionMethodListDetails({
    required this.id,
    required this.serviceName,
    required this.transactionTypeId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionMethodListDetails.fromJson(Map<String, dynamic> json) {
    return TransactionMethodListDetails(
      id: json["id"] as int?,
      serviceName: json["name"] as String?,
      transactionTypeId: json["transaction_type_id"] as int?,
      status: json["status"] as String?,
      createdAt: json["created_at"] as String?,
      updatedAt: json["updated_at"] as String?,
    );
  }
}