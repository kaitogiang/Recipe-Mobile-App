
import 'package:flutter/material.dart';

void showDialogForm(BuildContext context, Widget child) {
  showDialog(
    context: context,
    builder: (BuildContext context) => Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 10,),
            child,
            const SizedBox(height: 10,),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Thoát'),
            )
          ],
        ),
      ),
    )
  );
}