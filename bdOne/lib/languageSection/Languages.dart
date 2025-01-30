import 'package:flutter/cupertino.dart';

abstract class Languages {
  static Languages? of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages);
  }

  String get appName;

  String get labelWelcome;

  String get labelInfo;

  String get labelSelectLanguage;

  String get enterPhoneNumber;

  String get labelSubmit;

  String get labelSendOtp;

  String get labelConfirmOtp;

  String get labelNeedHelp;

  String get labelEnterCode;

  String get labelSentCode;

  String get labelAccessToAccount;

  String get labelResendCode;

  String get labelTandC;

  String get labelValidate;

  String get labelAlmostFinish;

  String get labelSetProfile;

  String get labelTellAbtYourself;

  String get labelPromoCode;

  String get labelRedeem;

  String get labelName;

  String get labelYourName;

  String get enterYourMobileNumber;

  String get labelLastname;

  String get labelUsername;

  String get labelEmail;

  String get labelEmailAddress;

  String get labelDOB;

  String get labelPassword;

  String get labelConfirmPass;

  String get labelConfirm;

  String get labelLogin;

  String get labelLogout;

  String get labelHi;

  String get labelStandard;

  String get labelTotalBalance;

  String get labelINR;

  String get labelUSD;

  String get labelZero;

  String get labelAddMoney;

  String get labelSend;

  String get labelExchange;

  String get labelNews;

  String get labelHome;

  String get labelShop;

  String get labelCart;

  String get labelFavourite;

  String get labelBookCab;

  String get labelServices;

  String get labelRideHistory;

  String get labelRideAccount;

  String get labelRewards;

  String get labelTransfer;

  String get labelTransaction;

  String get labelPayment;

  String get labelProfile;

  String get labelWallet;

  String get labelAccountDetails;

  String get labelPersonalInfo;

  String get labelEditPersonalInfo;

  String get labelSecurity;

  String get labelStepVerification;

  String get labelPaymentMethod;

  String get labelAddedCard;

  String get labelHelpSupport;

  String get labelSettings;

  String get labelVerifyEmail;

  String get labelVerifyEmailContent;

  String get labelUserId;

  String get labelChangePass;

  String get labelEmailVerified;

  String get labelEmailVerifiedContent;

  String get labelOldPass;

  String get labelNewPass;

  String get labelForgotPass;

  String get labelProceed;

  String get labelPersonalData;

  String get labelAddress;

  String get completeProfile;

  String get labelBirthdate;

  String get labelChooseDoc;

  String get labelDocNo;

  String get labelStreetName;

  String get labelStreetNo;

  String get labelCountry;

  String get labelIndia;

  String get labelState;

  String get labelCity;

  String get labelPostalCode;

  String get labelTransferContent;

  String get labelPaymentScreen;

  String get labelComingSoon;

  String get availablePayario;

  String get labelRedeemBal;

  String get labelPayarioPts;

  String get labelFirstname;

  String get labelAddressDetails;

  String get labelLanguage;

  String get labelEnterAmount;

  String get labelKYCVerification;

  String get labelVerifyYourEmail;

  String get verifyEmailSubTitle;

  String get labelEnterEmail;

  String get labelEnterOtpSentToEmail;

  String get labelMoneyTransfer;

  String get labelMoneyTransferOverview;

  String get labelBalance;

  String get labelTransferTo;

  String get labelChange;

  String get labelSelectOptions;

  String get labelUploadedDocs;

  String get labelPassport;

  String get labelDrivingLicence;

  String get labelNationalId;

  String get labelPhotoPage;

  String get labelFrontNBack;

  String get labelPending;

  String get labelInProgress;

  String get labelVerified;

  String get labelRejected;

  String get labelInComplete;

  String get labelVideoVerification;

  String get labelStatusPending;

  String get labelVerifyIdentity;

  String get labelAllowCamAccess;

  String get labelAllowAccessSubtitle;

  String get labelEnableCam;

  String get labelIssuingCountry;

  String get labelSuggestedCountry;

  String get labelSearch;

  String get labelTakeFewMinutes;

  String get labelUseDevice;

  String get labelTakePhoto;

  String get labelRecordVideo;

  String get labelLevelBenefit;

  String get labelAccumulated;

  String get labelPtsToSilver;

  String get labelSilver;

  String get labelGOld;

  String get labelLevelExclusives;

  String get labelExclusiveBenefits;

  String get labelMultipliers;

  String get labelOnlinePayments;

  String get labelEarnPayarioPts;

  String get labelLockedLvl;

  String get labelUnlockWith;

  String get labelPreviousBenefits;

  String get labelEarnPayarioPtsWithMin1670;

  String get label2xEarnPayarioPtsWithMin1670;

  String get labelNotification;

  String get labelEnterValidPhone;

  String get labelSelectCountryCode;

  String get labelWithdraw;

  String get labelNoTransaction;

  String get labelViewAll;

  String get labelMore;

  String get labelStars;

  String get labelKycNonVerified;

  String get labelPressBackToExit;

  String get labelDashboard;

  String get labelNoInternetConnection;

  String get labelSuccess;

  String get labelPay;

  String get labelMostFrequent;

  String get labelQuickAction;

  String get labelRequestQR;

  String get labelInvalidAccessToken;

  String get labelAdd;

  String get statusVerified;

  String get labelHintUserNameOrPhoneNo;

  String get labelRecents;

  String get labelNoRecentTransaction;

  String get labelEnterPhoneNoOrUsernameSub;

  String get labelPleaseEnterValidDetails;

  String get labelPaying;

  String get labelPleaseEnterAmt;

  String get labelLocalDistributors;

  String get labelPay2Local;

  String get labelPhoneNumber;

  String get labelSignup;

  String get labelSignin;

  String get labelAddMoneyAndManage;

  String get subHeadingApplicationForReachingGoal;

  String get labelMoneyStaysSafe;

  String get labelMoneyStaysSafeSubHeading;

  String get labelPasswordAlert;

  String get labelPasswordDoesntMatch;

  String get labelPleaseEnterAllDetails;

  String get labelOtpVerification;

  String get labelPleaseEnterValidPhoneNo;

  String get labelResendOtp;

  String get labelPhoneVerification;

  String get labelEnterPhoneNo;

  String get labelSendConfirmationCode;

  String get labelAlreadyHaveAnAcc;

  String get labelSelectDob;

  String get labelEnterValidDate;

  String get labelEnterDateInValidRange;

  String get labelNeedAcc;

  String get labelSignupHere;

  String get labelSaveId;

  String get labelTransactionPin;

  String get labelEnterPin;

  String get labelTPINUpdatedSuccessfully;

  String get labelVerifyPin;

  String get labelTransactionPinDoesntMatch;

  String get labelEnterOtpToCompleteTransaction;

  String get labelSending;

  String get labelPhoneNo;

  String get labelPayingTo;

  String get labelEnter4DigitPin;

  String get labelYouAreTransferringMoneyTo;

  String get labelYouCanOnlyWithdraw;

  String get labelMoveMoney;

  String get labelAwesome;

  String get labelYouWithdraw;

  String get labelHappySpending;

  String get labelPayBill;

  String get statusWithdraw;

  String get statusTransfer;

  String get labelPaidTo;

  String get labelAt;

  String get labelTransactionId;

  String get labelShareScreenshot;

  String get labelDone;

  String get labelGenerateQR;

  String get labelErrorLoadingQR;

  String get labelFilterPayment;

  String get labelStatus;

  String get labelRequestType;

  String get labelDeposit;

  String get labelClearAll;

  String get labelApply;

  String get labelWithdrawMethods;

  String get labelRegister;

  String get labelRegisterHere;

  String get statusInComplete;

  String get labelExit;

  String get labelTransactionOverview;

  String get labelCustomerId;

  String get labelPaymentId;

  String get labelReceiptCopy;

  String get labelRef;

  String get labelFrom;

  String get labelTo;

  String get labelTotalAmount;

  String get labelTransferAmount;

  String get labelServiceCharge;

  String get labelNoChargeApplicable;

  String get labelTransferType;

  String get labelDateTime;

  String get labelDownload;

  String get labelShare;

  String get labelDownloadedSuccessfully;

  String get labelClose;

  String get labelFundTransferSuccessful;

  String get labelTransferFrom;

  String get labelViewReceipt;

  String get labelPleaseEnterValidAmt;

  String get labelTransferScreen;

  String get labelAccountTransfer;

  String get labelNotes;

  String get labelWriteSomething;

  String get labelTPIN;

  String get labelEmailOtp;

  String get labelGeneral;

  String get labelTransactional;

  String get labelDepositOtp;

  String get labelWithdrawOtp;

  //Add Nnew
  String get labelVisitor;

  String get labelCitizenOrResident;

  String get labelMobileNumber;

  String get labelContinue;

  String get labelVerificationDetails;

  String get labelHistory;

  String get labelNoData;

  String get labelAllDocuments;

  String get labelIssued;

  String get labelUploaded;

  String get labelPersonal;

  String get labelProfessional;

  String get labelLegal;

  String get labelProperty;

  String get labelIssuedDocumentsUnder;

  String get labelRequestADocument;

  String get labelValidUntil;

  String get labelNoNotifications;

  String get labelAccount;

  String get labelShowProfile;

  String get labelChangePIN;

  String get labelManageDevices;

  String get labelResetSigninPassword;

  String get labelBiometrics;

  String get labelAccessibility;

  String get labelAboutBDOne;

  String get labelWalkthrough;

  String get labelAreYouSureYouWantToLogout;

  String get labelNO;

  String get labelYes;

  String get labelDocuments;

  String get labelVerifiedAccount;

  String get labelSignature;

  String get labelQualified;

  String get labelAvailable;

  String get labelSignDocuments;

  String get labelVerifySignature;

  String get labelAddDocuments;

  String get labelRequestOfficialDocuments;

  String get labelScanQRCode;

  String get labelUseYourCamera;

  String get labelReceiveMoney;

  String get labelAccountBenefits;

  String get labelBenefitsOfBasicAccount;

  String get labelAccessGovtServices;

  String get labelAdvancedSignatures;

  String get labelVerifyBDOneSignedSignatures;

  String get labelQualifiedSignatures;

  String get labelRequestAndAddDocuments;

  String get labelSharingDigitalDocuments;

  String get labelManagingDigitalDocuments;

  String get labelAccountRecovery;

  String get labelPleaseEnterMobileEmailEmirateID;

  String get labelEmailMobileEmiratesId;

  String get labelMobileNoEg;

  String get labelConfirmDetails;

  String get labelPleaseReviewAndConfirm;

  String get labelPersonalDetails;

  String get labelIDNumber;

  String get labelFirstName;

  String get labelNationality;

  String get labelGender;

  String get labelExpiryDate;

  String get labelEnterAllDetails;

  String get labelEnterValidEmail;

  String get labelCreateBDOneAccount;

  String get labelNationalDigitalIdentityAndSignatureSol;

  String get labelCreateNewAccount;

  String get labelHaveAnExistingAccount;

  String get labelStep;

  String get labelSignUpInEasySteps;

  String get labelNationalDigitalIdentityForAllCitizens;

  String get labelScanYourID;

  String get labelVerifyDetails;

  String get labelSecureAccount;

  String get labelVerifyYourMobileNumber;

  String get labelPleaseEnterOtp;

  String get labelDidntReceiveOtp;

  String get labelSendAgain;

  String get labelProvideMobileNoAndEmail;

  String get labelHoldingIdIssuedByGovernment;

  String get labelHoldingIdOrPassportIssuedByOtherCountries;

  String get labelProceedAs;

  String get labelMobileBasedSecureSignIn;

  String get labelLoginAndSignupToDigital;

  String get labelDigitalSignature;

  String get labelSignAndVerifyDigitally;

  String get labelDocumentSharing;

  String get labelRequestAndShareOfficialDocs;

  String get labelFirstNationalDigitalId;

  String get labelFirstDigitalID;

  String get labelScanBDID;

  String get labelUseDeviceCamToScan;

  String get labelScanNow;

  String get labelNationalIdentityForAll;

  String get labelEnglish;

  String get labelBangladesh;

  String get labelTermAndCondition;

  String get labelBDOneTermsOfUse;

  String get labelVersion;

  String get labelWelcomeToBDOne;

  String get labelReadAllTermsConditions;

  String get labelAccept;

  String get labelPasswordRequirement;
}
