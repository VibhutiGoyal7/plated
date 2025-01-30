class ProductListRequest {
  int? pageNo;
  int? pageSize;
  String? name;
  String? description;
  String? foodCategoryId;

  ProductListRequest({
    required this.pageNo,
    required this.pageSize,
    required this.name,
    required this.description,
    required this.foodCategoryId,
  });

  Map<String, dynamic> toJson() {
    return {
      'page_number': pageNo,
      'page_size': pageSize,
      'name': name,
      'description': description,
      'food_category_id': foodCategoryId,
    };
  }
}
