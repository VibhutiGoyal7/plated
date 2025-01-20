import 'dart:ui';

class ServiceTypeResponse {
  String? serviceName;
  String? icon;
  Color? iconBgColor;

  ServiceTypeResponse({
    required this.serviceName,
    required this.icon,
    required this.iconBgColor,
  });

  Map<String, dynamic> toJson() {
    return {
      'service_name': serviceName,
      'icon': icon,
      'icon_bg_color': iconBgColor,
    };
  }
}
