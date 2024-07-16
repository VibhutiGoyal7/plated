class VerifyOtpTPinChange {
  String otp;
  String tpin;


  VerifyOtpTPinChange({
    required this.otp,
    required this.tpin
  });
  Map<String, dynamic> toJson() {
    return {
      'otp': otp,
      'tpin': tpin
    };
  }
}