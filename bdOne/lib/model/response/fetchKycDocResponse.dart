class FetchKycDocResponse {
  DocumentData? drivingLicenseImage;
  DocumentData? nationalIdImage;
  DocumentData? passportImage;
  DocumentData? addressKycData;
  DocumentData? bankStatement;
  DocumentData? geolocation;
  String? message;

  FetchKycDocResponse({
    this.drivingLicenseImage,
    this.nationalIdImage,
    this.passportImage,
    this.addressKycData,
    this.bankStatement,
    this.geolocation,
    this.message,
  });

  factory FetchKycDocResponse.fromJson(Map<String, dynamic> json) {
    return FetchKycDocResponse(
      nationalIdImage: json["data"]?["national_id"] != null
          ? DocumentData.fromJson(json["data"]["national_id"])
          : null,
      passportImage: json["data"]?["passport"] != null
          ? DocumentData.fromJson(json["data"]["passport"])
          : null,
      drivingLicenseImage: json["data"]?["driving_license"] != null
          ? DocumentData.fromJson(json["data"]["driving_license"])
          : null,
      addressKycData: json["data"]?["address_kyc"] != null
          ? DocumentData.fromJson(json["data"]["address_kyc"])
          : null,
      bankStatement: json["data"]?["bank_statement"] != null
          ? DocumentData.fromJson(json["data"]["bank_statement"])
          : null,
      geolocation: json["data"]?["geolocation_kyc"] != null
          ? DocumentData.fromJson(json["data"]["geolocation_kyc"])
          : null,
      message: json["message"] as String?,
    );
  }
}

class DocumentData {
  final int? customerId;
  final String? documentType;
  final int? documentId;
  final String? verificationStatus;
  final String? rejectionReason;
  final String? idNumber;
  final String? kycDocsImageUrl;
  final String? kycVideoUrl;
  final String? pendingReason;
  final String? displayName;
  final bool? availableForYourOrganization;

  DocumentData({
    this.customerId,
    this.documentType,
    this.documentId,
    this.verificationStatus,
    this.rejectionReason,
    this.idNumber,
    this.kycDocsImageUrl,
    this.kycVideoUrl,
    this.pendingReason,
    this.displayName,
    this.availableForYourOrganization,
  });

  factory DocumentData.fromJson(Map<String, dynamic> json) {
    return DocumentData(
      customerId: json['customer_id'] as int?,
      documentType: json['document_type'] as String?,
      documentId: json['id'] as int?,
      verificationStatus: json['verification_status'] as String?,
      rejectionReason: json['rejection_reason'] as String?,
      idNumber: json['id_number'] as String?,
      pendingReason: json['pending_reason'] as String?,
      availableForYourOrganization: json['available_for_your_organization'] as bool?,
      kycVideoUrl: json['kyc_video_url'] as String?,
      kycDocsImageUrl: json['kyc_file_url'] as String?,
      displayName: json['display_name'] as String?,
    );
  }
}
