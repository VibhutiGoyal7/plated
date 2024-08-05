
import 'package:floor/floor.dart';

@entity
class SendMessageResponse {
  @primaryKey
  final int? id;
  final int? status;
  final String? content;
  final String? message;
  final int? userId;
  final String? userType;
  final String? name;
  final List<dynamic>? attachments;
  final int? payorioSupportTicketId;
  final String? createdAt;
  final String? updatedAt;

  SendMessageResponse({
    this.id,
    this.content,
    this.message,
    this.status,
    this.userId,
    this.userType,
    this.name,
    this.attachments,
    this.payorioSupportTicketId,
    this.createdAt,
    this.updatedAt,
  });

  factory SendMessageResponse.fromJson(Map<String, dynamic> json) {
    return SendMessageResponse(
      message: json['message'] as String?,
      status: json['status'] as int?,
      id: json['id'] as int?,
      content: json['data']?['content'] as String?,
      userId: json['data']?['user_id'] as int?,
      userType: json['data']?['user_type'] as String?,
      name: json['data']?['name'] as String?,
      attachments: json['data']?['attachments'] as List<dynamic>?,
      payorioSupportTicketId: json['data']?['payorio_support_ticket_id'] as int?,
      createdAt: json['data']?['created_at'] as String?,
      updatedAt: json['data']?['updated_at'] as String?,
    );
  }
}