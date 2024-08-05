
class AddMoneyResponse {
  final String? message;
  final int? status;
  final String? msg;
  final String? requestId;
  final String? redirectUrl;
  final String? uniqueId;
  final String? currency;

  AddMoneyResponse({
     this.message,
     this.status,
     this.msg,
     this.requestId,
     this.redirectUrl,
     this.uniqueId,
     this.currency,

  });

  factory AddMoneyResponse.fromJson(Map<String, dynamic> json){
    return AddMoneyResponse(
      message : json['message'] as String?,
      status : json['data']?['status'] as int?,
      msg : json['data']?['message'] as String?,
      requestId : json['data']?['request_id'] as String?,
      redirectUrl : json['data']?['redirect_url'] as String?,
      uniqueId : json['data']?['unique_id'] as String?,
      currency : json['data']?['currency'] as String?,
    );
  }
}

