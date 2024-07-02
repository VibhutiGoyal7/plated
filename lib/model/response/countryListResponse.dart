
class CountryListResponse {
  List<CountryData>? countries;
  String message;

  CountryListResponse({
    required this.countries,
    required this.message,
  });

  factory CountryListResponse.fromJson(Map<String, dynamic> json) {

    var list = json['data'] as List;
    List<CountryData>? countriesList = list?.map((i) => CountryData.fromJson(i)).toList();

    return CountryListResponse(
      countries: countriesList,
      message: json["message"] as String,);

  }
}

class CountryData {
  int? id;
  String? name;
  String? code;
  String? phoneCode;
  String? flagImageUrl;

  CountryData({
    required this.id,
    required this.name,
    required this.code,
    required this.phoneCode,
    required this.flagImageUrl,
  });

  factory CountryData.fromJson(Map<String, dynamic> json) {
    return CountryData(
      id: json["id"] as int?,
      name: json["name"] as String?,
      code: json["code"] as String?,
      phoneCode: json["phone_code"] as String?,
      flagImageUrl: json["flag_image_url"] as String?,
    );
  }
}