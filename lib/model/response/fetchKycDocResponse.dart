class FetchKycDocResponse {
  DocumentData? drivingLicenseImage;
  DocumentData? nationalIdImage;
  DocumentData? videoClipUrl;
  DocumentData? passportImage;
  DocumentData? addressKycData;
  DocumentData? bankStatement;
  DocumentData? geolocation;
  String? message;

  FetchKycDocResponse({
     this.drivingLicenseImage,
     this.nationalIdImage,
     this.passportImage,
     this.videoClipUrl,
     this.addressKycData,
     this.bankStatement,
     this.geolocation,
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
      addressKycData : json["data"]['address_kyc'] != null
          ? new DocumentData.fromJson(json["data"]['address_kyc'])
          : null,
      bankStatement : json["data"]['bank_statement'] != null
          ? new DocumentData.fromJson(json["data"]['bank_statement'])
          : null,
      geolocation : json["data"]['geolocation_kyc'] != null
          ? new DocumentData.fromJson(json["data"]['geolocation_kyc'])
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
  final bool? availableInCountry;

  DocumentData({
    this.customerId,
    this.documentType,
    this.userId,
    this.verificationStatus,
    this.rejectionReason,
    this.idNumber,
    this.kycDocsImageUrl,
    this.pendingReason,
    this.availableInCountry
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
        availableInCountry: json['available_in_your_country'] as bool?,
      kycDocsImageUrl: json['kyc_attachment_url'] as String?
    );
  }
}
