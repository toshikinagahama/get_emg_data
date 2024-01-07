import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton(
      {required this.onPressed,
      required this.text,
      required this.width,
      Key? key})
      : super(key: key);
  final String text;
  final double? width;
  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: SizedBox(
        width: width,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Color.fromARGB(255, 9, 55, 96),
            backgroundColor: Color.fromARGB(255, 226, 226, 226),
            elevation: 8,
            padding: EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          onPressed: onPressed,
          child: Text(text),
        ),
      ),
    );
  }
}
