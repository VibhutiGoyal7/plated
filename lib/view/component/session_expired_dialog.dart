import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../../utils/Helper.dart';

class SessionExpiredDialog{
  static Future<void> showDialogBox({
    required BuildContext context,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: Border.all(),
          title: Text("Session Expired"),
          content: SingleChildScrollView(
              child: Text("You need to login again.")),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Helper.clearAllSharedPreferences();
                Navigator.pushReplacementNamed(context, '/MoneySafeScreen',
                    arguments: "");
              },
            ),
          ],
        );
      },
    );
  }
}