import 'package:flutter/material.dart';

import '../Utilits/colors.dart';

class ContentDialog extends StatelessWidget {
  final String content;
  final VoidCallback callback;

  const ContentDialog(
      {super.key, required this.content, required this.callback});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        height: 130.0,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(content,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                )),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: callback,
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all<Color>(weevoPrimaryOrangeColor),
              ),
              child: const Text(
                'حسناً',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
