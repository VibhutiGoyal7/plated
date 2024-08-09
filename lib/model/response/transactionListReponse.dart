import 'package:floor/floor.dart';

class TransactionListResponse {
  String? message;
  int? status;
  List<TransactionDetails>? data;
  PagyDetails? pagy;

  TransactionListResponse({
    required this.message,
    required this.status,
    required this.data,
    required this.pagy,
  });

  factory TransactionListResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<TransactionDetails>? transactionList =
        list?.map((i) => TransactionDetails.fromJson(i)).toList();

    return TransactionListResponse(
      message: json['message'] as String?,
      status: json['status'] as int?,
      data: transactionList,
      pagy:
          json['pagy'] != null ? new PagyDetails.fromJson(json['pagy']) : null,
    );
  }
}

@entity
class TransactionDetails {
  @primaryKey
  int? id;
  String? amount;
  String? email;
  String? fullName;
  String? transactionType;
  String? uniqueId;
  String? username;
  String? phoneNumber;
  String? status;
  String? createdAt;
  int? userId;
  int? senderId;
  int? receiverId;

  TransactionDetails({
    required this.id,
    required this.amount,
    required this.email,
    required this.fullName,
    required this.transactionType,
    required this.uniqueId,
    required this.username,
    required this.phoneNumber,
    required this.status,
    required this.createdAt,
    required this.userId,
    required this.senderId,
    required this.receiverId,
  });

  factory TransactionDetails.fromJson(Map<String, dynamic> json) {
    return TransactionDetails(
      id: json["id"] as int?,
      amount: json["amount"] as String?,
      transactionType: json["transaction_type"] as String?,
      fullName: json["full_name"] as String?,
      uniqueId: json["unique_id"] as String?,
      username: json["username"] as String?,
      phoneNumber: json["phone_number"] as String?,
      email: json["email"] as String?,
      status: json["status"] as String?,
      createdAt: json["created_at"] as String?,
      userId: json["customer_id"] as int?,
      senderId: json["sender_id"] as int?,
      receiverId: json["receiver_id"] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "amount": amount,
      "transaction_type": transactionType,
      "full_name": fullName,
      "unique_id": uniqueId,
      "username": username,
      "phone_number": phoneNumber,
      "email": email,
      "status": status,
      "created_at": createdAt,
      "customer_id": userId,
      "sender_id": senderId,
      "receiver_id": receiverId,
    };
  }
}

class PagyDetails {
  int? totalRow;
  int? pageNo;
  int? pageSize;

  PagyDetails({
    this.totalRow,
    this.pageNo,
    this.pageSize,
  });

  factory PagyDetails.fromJson(Map<String, dynamic> json) {
    return PagyDetails(
      totalRow: json["total_rows"] as int?,
      pageNo: json["page_number"] as int?,
      pageSize: json["page_size"] as int?,
    );
  }
}
