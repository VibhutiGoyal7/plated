import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class UploadKycDocResponse {
  final int? customerId;
  final String? documentType;
  final int? userId;
  final String? verificationStatus;
  final String? rejectionReason;
  final String? idNumber;
  final String? kycDocsImageUrl;
  final String? message;

  UploadKycDocResponse({
    this.customerId,
    this.documentType,
    this.userId,
    this.verificationStatus,
    this.rejectionReason,
    this.idNumber,
    this.kycDocsImageUrl,
    this.message,
  });

  factory UploadKycDocResponse.fromJson(Map<String, dynamic> json) {
    return UploadKycDocResponse(
      message: json['message'] as String?,
      customerId: json['data']?['customer_id'] as int?,
      documentType: json['data']?['document_type'] as String?,
      userId: json['data']?['id'] as int?,
      verificationStatus: json['data']?['verification_status'] as String?,
      rejectionReason: json['data']?['rejection_reason'] as String?,
      idNumber: json['data']?['id_number'] as String?,
      kycDocsImageUrl: json['data']?['kyc_docs_image_url'] as String?,
    );
  }
}