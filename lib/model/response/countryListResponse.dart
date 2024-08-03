
import 'dart:convert';

class CountryListResponse {
  List<CountryData>? countries;
  String message;
  int status;

  CountryListResponse({
    required this.countries,
    required this.message,
    required this.status,
  });

  factory CountryListResponse.fromJson(Map<String, dynamic> json) {

    var list = json['data'] as List;
    List<CountryData>? countriesList = list?.map((i) => CountryData.fromJson(i)).toList();

    return CountryListResponse(
      countries: countriesList,
      message: json["message"] as String,
      status: json["status"] as int,
    );

  }
}

class CountryData {
  int? id;
  String? name;
  String? code;
  String? phoneCode;
  String? flagImageUrl;

  CountryData({
     this.id,
     this.name,
     this.code,
     this.phoneCode,
     this.flagImageUrl,
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


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['phone_code'] = this.phoneCode;
    data['flag_image_url'] = this.flagImageUrl;
    return data;
  }

  String toJsonString() => json.encode(toJson());

  factory CountryData.fromJsonString(String source) {
    final Map<String, dynamic> jsonMap = json.decode(source);
    return CountryData(
      id: jsonMap["id"] as int?,
      name: jsonMap["name"] as String?,
      code: jsonMap["code"] as String?,
      phoneCode: jsonMap["phone_code"] as String?,
      flagImageUrl: jsonMap["flag_image_url"] as String?,
    );
  }
}