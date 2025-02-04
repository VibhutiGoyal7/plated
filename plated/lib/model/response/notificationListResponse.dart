import 'package:floor/floor.dart';

class NotificationListResponse {
  String? message;
  int? status;
  List<NotificationDetail>? data;
  PagyDetails? pagy;

  NotificationListResponse({
    required this.message,
    required this.status,
    required this.data,
    required this.pagy,
  });

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<NotificationDetail>? transactionList =
    list.map((i) => NotificationDetail.fromJson(i)).toList();

    return NotificationListResponse(
      message: json['message'] as String?,
      status: json['status'] as int?,
      data: transactionList,
      pagy:
      json['pagy'] != null ? new PagyDetails.fromJson(json['pagy']) : null,
    );
  }
}

@entity
class NotificationDetail {
  @primaryKey
  int? id;
  String? title;
  String? message;
  String? notificationType;
  bool? isRead;
  String? createdAt;
  int? customerId;

  NotificationDetail({
    required this.id,
    required this.title,
    required this.message,
    required this.notificationType,
    required this.isRead,
    required this.customerId,
    required this.createdAt,
  });

  factory NotificationDetail.fromJson(Map<String, dynamic> json) {
    return NotificationDetail(
      id: json["id"] as int?,
      title: json["title"] as String?,
      message: json["message"] as String?,
      notificationType: json["notification_type"] as String?,
      isRead: json["is_read"] as bool?,
      createdAt: json["created_at"] as String?,
      customerId: json["customer_id"] as int?
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "message": message,
      "notification_type": notificationType,
      "is_read": isRead,
      "created_at": createdAt,
      "customer_id": customerId,
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
