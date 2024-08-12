import 'package:floor/floor.dart';

class P2PTransactionListResponse {
  String? message;
  int? status;
  List<P2PTransactionDetails>? data;
  PagyDetails? pagy;

  P2PTransactionListResponse({
    required this.message,
    required this.status,
    required this.data,
    required this.pagy,
  });

  factory P2PTransactionListResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<P2PTransactionDetails>? transactionList =
        list?.map((i) => P2PTransactionDetails.fromJson(i)).toList();

    return P2PTransactionListResponse(
      message: json['message'] as String?,
      status: json['status'] as int?,
      data: transactionList,
      pagy:
          json['pagy'] != null ? new PagyDetails.fromJson(json['pagy']) : null,
    );
  }
}

@entity
class P2PTransactionDetails {
  @primaryKey
  int? id;
  String? amount;
  String? transactionType;
  String? transactionMethod;
  String? transactionProvider;
  String? uniqueId;
  String? notes;
  String? status;
  int? senderId;
  String? senderUsername;
  String? senderPhoneNumber;
  int? receiverId;
  String? receiverUsername;
  String? receiverPhoneNumber;
  String? createdAt;
  P2PTrxDetails? trxDetails;

  P2PTransactionDetails({
    required this.id,
    required this.amount,
    required this.transactionType,
    required this.transactionMethod,
    required this.transactionProvider,
    required this.uniqueId,
    required this.notes,
    required this.status,
    required this.senderId,
    required this.senderUsername,
    required this.senderPhoneNumber,
    required this.receiverId,
    required this.receiverUsername,
    required this.receiverPhoneNumber,
    required this.createdAt,
    required this.trxDetails,
  });

  factory P2PTransactionDetails.fromJson(Map<String, dynamic> json) {
    return P2PTransactionDetails(
      id: json["id"] as int?,
      amount: json["amount"] as String?,
      transactionType: json["transaction_type"] as String?,
      transactionMethod: json["transaction_method"] as String?,
      transactionProvider: json["transaction_provider"] as String?,
      uniqueId: json["unique_id"] as String?,
      notes: json["notes"] as String?,
      status: json["status"] as String?,
      senderId: json["sender_id"] as int?,
      senderUsername: json["sender_username"] as String?,
      senderPhoneNumber: json["sender_phone_number"] as String?,
      receiverId: json["receiver_id"] as int?,
      receiverUsername: json["receiver_username"] as String?,
      receiverPhoneNumber: json["receiver_phone_number"] as String?,
      createdAt: json["created_at"] as String?,
      trxDetails: json['trx_details']  != null ? new P2PTrxDetails.fromJson(json['trx_details']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "amount": amount,
      "transaction_type": transactionType,
      "transaction_method": transactionMethod,
      "transaction_provider": transactionProvider,
      "unique_id": uniqueId,
      "notes": notes,
      "status": status,
      "sender_id": senderId,
      "sender_username": senderUsername,
      "sender_phone_number": senderPhoneNumber,
      "receiver_id": receiverId,
      "receiver_username": receiverUsername,
      "receiver_phone_number": receiverPhoneNumber,
      "created_at": createdAt,
      "trx_details": trxDetails,
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

class P2PTrxDetails {
  final String? otp;
  final String? unique_id;

  P2PTrxDetails({
    this.otp,
    this.unique_id,
  });

  factory P2PTrxDetails.fromJson(Map<String, dynamic> json) {
    return P2PTrxDetails(
      otp: json['otp'] as String?,
      unique_id: json['unique_id'] as String?,
    );
  }
}
