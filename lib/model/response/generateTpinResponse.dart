class GenerateTpinResponse {
  final String? tpin;
  final String? message;

  GenerateTpinResponse({
    this.tpin,
    this.message,
  });

  factory GenerateTpinResponse.fromJson(Map<String, dynamic> json) {
    return GenerateTpinResponse(
      message: json['message'] as String?,
      tpin: json['data']?['tpin'] as String?,
    );
  }
}
