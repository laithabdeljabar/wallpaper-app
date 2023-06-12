import 'package:flutter/material.dart';

class StateWidget {
  void showLoadingWidget(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: const Center(child: CircularProgressIndicator()),
            ));
  }

  void showSnackBarMessage(
      {required String message,
      required Color color,
      required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: color,
    ));
  }
}
