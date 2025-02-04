import 'package:cloud_firestore/cloud_firestore.dart';

class LiveChatResponse {
  final Timestamp? createdAt;
  final bool? isRead;
  final String? text;
  final int? user;

  LiveChatResponse({
    this.createdAt,
    this.isRead,
    this.text,
    this.user,
  });

  factory LiveChatResponse.fromJson(Map<String, dynamic> json) {
    return LiveChatResponse(
      createdAt: json['createdAt'] as Timestamp?,
      isRead: json['isRead'] as bool?,
      text: json['text'] as String?,
      user: json['user'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'isRead': isRead,
      'text': text,
      'user': user,
    };
  }
}
