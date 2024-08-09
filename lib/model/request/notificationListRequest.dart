class NotificationListRequest {
  int? pageNo;
  int? pageSize;
  String? notificationType;
  SortingDetail? sorting;

  NotificationListRequest({
    required this.pageNo,
    required this.pageSize,
    required this.notificationType,
    required this.sorting,
  });

  Map<String, dynamic> toJson() {
    return {
      'page_number': pageNo,
      'page_size': pageSize,
      'notification_type': notificationType,
      'sorting': sorting?.toJson(),
    };
  }
}
class SortingDetail {
  String? createdAt;

  SortingDetail({
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'created_at': createdAt,
    };
  }
}

