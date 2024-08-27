import 'package:flutter/material.dart';

class WelcomeButtons extends StatelessWidget {
  const WelcomeButtons({super.key, this.buttonText, this.onTap, this.color, this.textColor});

  final String? buttonText;
  final VoidCallback? onTap;
  final Color? color;
  final Color? textColor;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20.0),
            decoration:  BoxDecoration(
                color: color!,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50)
                )
            ),
            child:  Text(
              buttonText!,
              textAlign: TextAlign.center,
              style:   TextStyle(
                color: textColor!,
                fontSize:  24.0,
                fontWeight: FontWeight.bold,
              ),
            )),
      ),
    );
  }
}
