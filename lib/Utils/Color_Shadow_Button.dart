import 'package:flutter/material.dart';

class ColorShadowButton extends StatelessWidget {
  final String text;
  final double height;
  final double width;
  final Function onTap;
  final Color shadowColor, buttonColor;
  final TextStyle textStyle;

  ColorShadowButton(
      {this.text,
      this.height,
      this.width,
      this.onTap,
      this.shadowColor,
      this.buttonColor,
      this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,

      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 5.0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          child: InkWell(
            borderRadius: BorderRadius.circular(10.0),
            onTap: onTap,
            child: Center(
                child: Text(
              text,
              style: textStyle,
              textAlign: TextAlign.center,
            )),
          ),
        ),
      ),
    );
  }
}
