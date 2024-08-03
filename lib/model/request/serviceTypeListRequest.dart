class ServiceTypeListRequest {
  int? countryId;

  ServiceTypeListRequest({
    required this.countryId,
  });

  Map<String, dynamic> toJson() {
    return {
      'country_id': countryId,
    };
  }
}