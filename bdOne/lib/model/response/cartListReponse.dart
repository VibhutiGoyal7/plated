class CartListResponse {
  final String? message;
  final CartData? data;
  final int? status;

  CartListResponse({this.message, this.data, this.status});

  factory CartListResponse.fromJson(Map<String, dynamic> json) {
    return CartListResponse(
      message: json['message'] as String?,
      data: json['data'] != null ? CartData.fromJson(json['data']) : null,
      status: json['status'] as int?,
    );
  }
}

class CartData {
  final int? cartId;
  final int? customerId;
  final List<CartItem>? items;
  final String? grandTotal;

  CartData({this.cartId, this.customerId, this.items, this.grandTotal});

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      cartId: json['cart_id'] as int?,
      customerId: json['customer_id'] as int?,
      items: (json['items'] as List?)
          ?.map((item) => CartItem.fromJson(item))
          .toList(),
      grandTotal: json['grand_total'] as String?,
    );
  }
}

class CartItem {
  final int? foodCartItemId;
  final int? foodItemId;
  final String? foodItemName;
  final String? price;
  final int? quantity;
  final String? totalPrice;

  CartItem({
    this.foodCartItemId,
    this.foodItemId,
    this.foodItemName,
    this.price,
    this.quantity,
    this.totalPrice,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      foodCartItemId: json['food_cart_item_id'] as int?,
      foodItemId: json['food_item_id'] as int?,
      foodItemName: json['food_item_name'] as String?,
      price: json['price'] as String?,
      quantity: json['quantity'] as int?,
      totalPrice: json['total_price'] as String?,
    );
  }
}
