import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class UploadKycDocResponse {
  final int? customerId;
  final String? documentType;
  final int? userId;
  final String? verificationStatus;
  final String? rejectionReason;
  final String? pendingReason;
  final String? idNumber;
  final String? kycDocsImageUrl;
  final String? kycVidFile;
  final String? message;
  final int? status;

  UploadKycDocResponse({
    this.customerId,
    this.documentType,
    this.userId,
    this.verificationStatus,
    this.rejectionReason,
    this.pendingReason,
    this.idNumber,
    this.kycDocsImageUrl,
    this.kycVidFile,
    this.message,
    this.status,
  });

  factory UploadKycDocResponse.fromJson(Map<String, dynamic> json) {
    return UploadKycDocResponse(
      message: json['message'] as String?,
      status: json['status'] as int?,
      customerId: json['data']?['customer_id'] as int?,
      documentType: json['data']?['document_type'] as String?,
      userId: json['data']?['id'] as int?,
      verificationStatus: json['data']?['verification_status'] as String?,
      rejectionReason: json['data']?['rejection_reason'] as String?,
      pendingReason: json['data']?['pending_reason'] as String?,
      idNumber: json['data']?['id_number'] as String?,
      kycDocsImageUrl: json['data']?['kyc_file_url'] as String?,
      kycVidFile: json['data']?['kyc_video_url'] as String?,
    );
  }
}