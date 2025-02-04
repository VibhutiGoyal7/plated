class EmptyResponse {
  final String? message;
  final int? status;

  EmptyResponse({
    this.message,
    this.status,
  });

  factory EmptyResponse.fromJson(Map<String, dynamic> json) {
    return EmptyResponse(
      message: json['message'] as String?,
      status: json['status'] as int?,
    );
  }
}
