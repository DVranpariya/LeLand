
import 'package:flutter/material.dart';

import 'Constant.dart';

class AnimatedInputField extends StatelessWidget {
  final String hintText;

  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final bool readOnly;

  AnimatedInputField({this.hintText, this.onChanged, this.controller, this.readOnly});

  @override
  Widget build(BuildContext context) {
    var focusNode = new FocusNode();

    Size size = MediaQuery
        .of(context)
        .size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.9,
      height: 50,
      child: TextFormField(
        maxLines: 5,
        onEditingComplete: () => FocusScope.of(context).unfocus(),
        onFieldSubmitted: (v) {
          FocusScope.of(context).unfocus();
        },
        keyboardType: TextInputType.text,
        style: kTextTitle,
        controller: controller,
        autofocus: false,
        onChanged: onChanged,
        readOnly: readOnly,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          isDense: true,

          labelText: hintText,
          labelStyle: TextStyle(color: Color(0xff999999), fontSize: 12.0),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide( color: Color(0xFF7286A1))),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide( color: Color(0xFF7286A1),)),

        ),
      ),
    );
  }
}
