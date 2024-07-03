
class OfferResponse {
  String image;
  String title;
  String description;
  String daysLeft;

  OfferResponse({
    required this.image,
    required this.title,
    required this.description,
    required this.daysLeft,
  });

  factory OfferResponse.fromJson(Map<String, dynamic> json) {
    return OfferResponse(
      image: json['image'] as String,
      title: json["title"] as String,
      description: json["description"] as String,
      daysLeft: json["daysLeft"] as String,
    );
  }
}
