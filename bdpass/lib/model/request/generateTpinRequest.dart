class GenerateTpinrequest {
  String tpin;

  GenerateTpinrequest({
    required this.tpin,
  });

  Map<String, dynamic> toJson() {
    return {
      'tpin': tpin,
    };
  }
}
