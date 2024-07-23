import 'package:flutter/cupertino.dart';
import 'package:toastification/toastification.dart';

class ToastComponent {
  static void showToast({
    required BuildContext context,
    required String? message,
    Duration duration = const Duration(seconds: 5),
  }) {
    if(message != null && message != "null") {
      toastification.show(
        context: context,
        title: Text("${message}"),
        style: ToastificationStyle.flat,
        autoCloseDuration: duration,
        direction: TextDirection.ltr,
        closeOnClick: true,
        pauseOnHover: true,
      );
    }
  }
}