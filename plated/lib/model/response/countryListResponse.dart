import 'dart:convert';

class CategoryListResponse {
  List<CategoryData>? categories;
  String message;
  int status;

  CategoryListResponse({
    required this.categories,
    required this.message,
    required this.status,
  });

  factory CategoryListResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<CategoryData>? categoryList =
        list.map((i) => CategoryData.fromJson(i)).toList();

    return CategoryListResponse(
      categories: categoryList,
      message: json["message"] as String,
      status: json["status"] as int,
    );
  }
}

class CategoryData {
  int? id;
  String? categoryName;
  String? categoryImage;

  CategoryData({
    this.id,
    this.categoryName,
    this.categoryImage,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      id: json["id"] as int?,
      categoryName: json["name"] as String?,
      categoryImage: json["category_image"] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = this.id;
    data['name'] = this.categoryName;
    data['category_image'] = this.categoryImage;
    return data;
  }

  String toJsonString() => json.encode(toJson());

  factory CategoryData.fromJsonString(String source) {
    final Map<String, dynamic> jsonMap = json.decode(source);
    return CategoryData(
      id: jsonMap["id"] as int?,
      categoryName: jsonMap["name"] as String?,
      categoryImage: jsonMap["category_image"] as String?,
    );
  }
}
