class DeleteCartResponse {
  final String message;
  final CartData data;
  final int status;

  DeleteCartResponse({required this.message, required this.data, required this.status});

  factory DeleteCartResponse.fromJson(Map<String, dynamic> json) {
    return DeleteCartResponse(
      message: json['message'],
      data: CartData.fromJson(json['data']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.toJson(),
      'status': status,
    };
  }
}

class CartData {
  final int cartId;
  final int customerId;
  final List<dynamic> items;
  final int grandTotal;

  CartData({required this.cartId, required this.customerId, required this.items, required this.grandTotal});

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      cartId: json['cart_id'],
      customerId: json['customer_id'],
      items: json['items'] ?? [],
      grandTotal: json['grand_total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cart_id': cartId,
      'customer_id': customerId,
      'items': items,
      'grand_total': grandTotal,
    };
  }
}
