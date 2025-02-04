import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Shortcutitemlist {
  String title;
  IconData icon;
  bool selected;

  Shortcutitemlist(
      {required this.title, required this.icon, required this.selected});

  Map<String, dynamic> toJson() {
    return {'title': title, 'selected': selected};
  }
}
