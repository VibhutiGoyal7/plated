class UpdateCartRequest {
  int? foodItemId;
  int? quantity;
  String? type;

  UpdateCartRequest(
      {required this.foodItemId, required this.quantity, required this.type});

  Map<String, dynamic> toJson() {
    return {
      'food_item_id': foodItemId,
      'quantity': quantity,
      'type': type,
    };
  }
}
