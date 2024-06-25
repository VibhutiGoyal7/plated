class FetchKycDocResponse {
  DocumentData? drivingLicenseImage;
  DocumentData? nationalIdImage;
  DocumentData? videoClipUrl;
  DocumentData? passportImage;
  String? message;

  FetchKycDocResponse({
     this.drivingLicenseImage,
     this.nationalIdImage,
     this.passportImage,
     this.videoClipUrl,
    this.message,

  });
  factory FetchKycDocResponse.fromJson(Map<String, dynamic> json) {
    return FetchKycDocResponse(
        nationalIdImage : json["data"]['national_id'] != null
            ? new DocumentData.fromJson(json["data"]['national_id'])
            : null,
        passportImage : json["data"]['passport'] != null
    ? new DocumentData.fromJson(json["data"]['passport'])
        : null,
    drivingLicenseImage : json["data"]['driving_licence'] != null
    ? new DocumentData.fromJson(json["data"]['driving_licence'])
        : null,
    videoClipUrl : json["data"]['video_kyc_clip'] != null
    ? new DocumentData.fromJson(json["data"]['video_kyc_clip'])
        : null,
    message : json["message"] as String?,
    );

  }
}

class DocumentData {
  final int? customerId;
  final String? documentType;
  final int? userId;
  final String? verificationStatus;
  final String? rejectionReason;
  final String? idNumber;
  final String? kycDocsImageUrl;
  final String? pendingReason;

  DocumentData({
    this.customerId,
    this.documentType,
    this.userId,
    this.verificationStatus,
    this.rejectionReason,
    this.idNumber,
    this.kycDocsImageUrl,
    this.pendingReason,
  });

  factory DocumentData.fromJson(Map<String, dynamic> json) {
    return DocumentData(
      customerId: json['customer_id'] as int?,
      documentType: json['document_type'] as String?,
      userId: json['id'] as int?,
      verificationStatus: json['verification_status'] as String?,
      rejectionReason: json['rejection_reason'] as String?,
      idNumber: json['id_number'] as String?,
        pendingReason: json['pending_reason'] as String?,
      kycDocsImageUrl: json['kyc_docs_image_url'] as String?
    );
  }
}
