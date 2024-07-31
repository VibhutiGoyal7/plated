class GenerateTpinResponse {
  final String? tpin;
  final String? message;
  final int? status;

  GenerateTpinResponse({
    this.tpin,
    this.message,
    this.status,
  });

  factory GenerateTpinResponse.fromJson(Map<String, dynamic> json) {
    return GenerateTpinResponse(
      message: json['message'] as String?,
      status: json['status'] as int?,
      tpin: json['data']?['tpin'] as String?,
    );
  }
}
