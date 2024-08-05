class InitiateP2PRequest {
  String? amount;
  String? paymentValidateBy;
  String? tpin;
  String? receiverUsername;
  String? receiverPhoneNumber;
  String? notes;
  String? fullName;
  String? imageUrl;

  InitiateP2PRequest({
    required this.amount,
    required this.receiverUsername,
    required this.paymentValidateBy,
    required this.tpin,
    required this.receiverPhoneNumber,
    required this.notes,
    this.fullName,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'payment_validate_by': paymentValidateBy,
      'tpin': tpin,
      'receiver_username': receiverUsername,
      'receiver_phone_number': receiverPhoneNumber,
      'notes': notes,
      'full_name': fullName,
      'image_url': imageUrl,
    };
  }
}
