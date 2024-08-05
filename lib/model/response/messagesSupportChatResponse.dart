import 'package:floor/floor.dart';

class MessagesSupportChatResponse {
  String? message;
  int? status;
  List<SupportChatDetail>? messages;
  UserDetail? userDetails;

  MessagesSupportChatResponse({
    required this.message,
    required this.status,
    required this.messages,
    required this.userDetails,
  });

  factory MessagesSupportChatResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data']?['messages'] as List;
    List<SupportChatDetail>? chatList =
    list?.map((i) => SupportChatDetail.fromJson(i)).toList();

    return MessagesSupportChatResponse(
      message: json['message'] as String?,
      status: json['status'] as int?,
      messages: chatList,
      userDetails:
      json["data"]?['user_details'] != null ? new UserDetail.fromJson(json["data"]?['user_details']) : null,
    );
  }
}

@entity
class SupportChatDetail {
  @primaryKey
  final int? id;
  final String? content;
  final int? userId;
  final String? userType;
  final String? name;
  final List<dynamic>? attachments;
  final int? payorioSupportTicketId;
  final String? createdAt;
  final String? updatedAt;

  SupportChatDetail({
    this.id,
    this.content,
    this.userId,
    this.userType,
    this.name,
    this.attachments,
    this.payorioSupportTicketId,
    this.createdAt,
    this.updatedAt,
  });

  factory SupportChatDetail.fromJson(Map<String, dynamic> json) {
    return SupportChatDetail(
      id: json['id'] as int?,
      content: json['content'] as String?,
      userId: json['user_id'] as int?,
      userType: json['user_type'] as String?,
      name: json['name'] as String?,
      attachments: json['attachments'] as List<dynamic>?,
      payorioSupportTicketId: json['payorio_support_ticket_id'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
/*
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
      "customer_id": customerId,
    };
  }*/
}

class UserDetail {
  int? id;
  String? name;
  //int? pageSize;

  UserDetail({
    this.id,
    this.name,
    //this.pageSize,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      id: json["id"] as int?,
      name: json["name"] as String?,/*
      pageSize: json["page_size"] as int?,*/
    );
  }
}
