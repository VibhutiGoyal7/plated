class InitiateP2PRequest {
  String? tpin;
  String? amount;
  String? receiverUsername;
  String? receiverPhoneNumber;

  InitiateP2PRequest({
    required this.tpin,
    required this.amount,
    required this.receiverUsername,
    required this.receiverPhoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'tpin': tpin,
      'amount': amount,
      'receiver_username': receiverUsername,
      'receiver_phone_number': receiverPhoneNumber,
    };
  }
}