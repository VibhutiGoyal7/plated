class DriverCurrentLocRequest {
  String? uniqueId;

  DriverCurrentLocRequest({
    required this.uniqueId,
  });

  Map<String, dynamic> toJson() {
    return {
      'unique_id': uniqueId,
    };
  }
}
