import 'package:cloud_firestore/cloud_firestore.dart';

class LiveChatUserDetailsResponse {
  final Timestamp? date;
  final String? first_name;
  final String? last_name;
  final String? lastMessage;
  final int? unReadByAdmin;
  final int? unReadByMerchant;

  LiveChatUserDetailsResponse({
    this.date,
    this.first_name,
    this.last_name,
    this.lastMessage,
    this.unReadByAdmin,
    this.unReadByMerchant,
  });

  factory LiveChatUserDetailsResponse.fromJson(Map<String, dynamic> json) {
    return LiveChatUserDetailsResponse(
      date: json['date'] as Timestamp?,
      first_name: json['first_name'] as String?,
      last_name: json['last_name'] as String?,
      lastMessage: json['lastMessage'] as String?,
      unReadByAdmin: json['unReadByAdmin'] as int?,
      unReadByMerchant: json['unReadByMerchant'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date ?? FieldValue.serverTimestamp(),
      'first_name': first_name,
      'last_name': first_name,
      'lastMessage': lastMessage,
      'unReadByAdmin': unReadByAdmin,
      'unReadByMerchant': unReadByMerchant,
    };
  }
}
