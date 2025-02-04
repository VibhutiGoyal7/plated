import 'dart:ui';

class ServiceTypeResponse {
  String? serviceName;
  String? icon;
  String? description =
      "Diet Coke (250ml) is a low-calorie soft drink made by The Coca-Cola Company. It is a sugar-free alternative to the original Coca-Cola, offering the same refreshing taste with fewer calories, making it a popular choice for health-conscious consumers.";
  Color? iconBgColor;

  ServiceTypeResponse({
    required this.serviceName,
    required this.icon,
    this.description ="Diet Coke (250ml) is a low-calorie soft drink made by The Coca-Cola Company. It is a sugar-free alternative to the original Coca-Cola, offering the same refreshing taste with fewer calories, making it a popular choice for health-conscious consumers.",
    required this.iconBgColor,
  });

  Map<String, dynamic> toJson() {
    return {
      'service_name': serviceName,
      'icon': icon,
      'description': description,
      'icon_bg_color': iconBgColor,
    };
  }

  factory ServiceTypeResponse.fromJson(Map<String, dynamic> json) {
    return ServiceTypeResponse(
        serviceName: json['service_name'] as String?,
        icon: json['icon'] as String?,
        iconBgColor: json['icon_bg_color'] as Color?);
  }
}
