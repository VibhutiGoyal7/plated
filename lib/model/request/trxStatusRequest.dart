class TrxStatusRequest {
  String uniqueId;

  TrxStatusRequest({required this.uniqueId});

  Map<String, dynamic> toJson() {
    return {
      'unique_id': uniqueId, // Convert the customer object to JSON
    };
  }
}
