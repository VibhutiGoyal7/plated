import 'package:floor/floor.dart';

class ProductsListResponse {
  String? message;
  int? status;
  List<ProductDetails>? productDetails;
  PagyDetails? pagy;

  ProductsListResponse({
    required this.message,
    required this.status,
    required this.productDetails,
    required this.pagy,
  });

  factory ProductsListResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<ProductDetails>? productDetailsList;
    if (list is List) {
      productDetailsList = list.map((i) => ProductDetails.fromJson(i)).toList();
    } else {
      productDetailsList = []; // or handle it another way if needed
    }
    return ProductsListResponse(
      message: json['message'] as String?,
      status: json['status'] as int?,
      productDetails: productDetailsList,
      pagy:
          json['pagy'] != null ? new PagyDetails.fromJson(json['pagy']) : null,
    );
  }
}

@entity
class ProductDetails {
  @primaryKey
  int? id;
  String? name;
  String? description;
  String? price;
  String? foodCategoryName;
  String? vendor;
  String? itemImage;

  ProductDetails(
      {required this.id,
      required this.name,
      required this.description,
      required this.price,
      required this.foodCategoryName,
      required this.vendor,
      required this.itemImage});

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      id: json["id"] as int?,
      name: json["name"] as String?,
      description: json["description"] as String?,
      price: json["price"] as String?,
      foodCategoryName: json["food_category_name"] as String?,
      vendor: json["vendor"] as String?,
      itemImage: json["item_image"] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "price": price,
      "food_category_name": foodCategoryName,
      "vendor": vendor,
      "item_image": itemImage,
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
