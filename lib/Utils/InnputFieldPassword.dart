import 'package:flutter/material.dart';

import 'Constant.dart';

class InputFieldPassword extends StatefulWidget {

  final TextEditingController controller;
  final String hintText;
  final String prefix;
  final TextInputType type;
  final bool readonly;
  final double height;
  final  bool obscureText ;

  InputFieldPassword({this.controller, this.hintText, this.prefix, this.type, this.readonly, this.height, this.obscureText});

  @override
  _InputFieldPasswordState createState() => _InputFieldPasswordState();
}

class _InputFieldPasswordState extends State<InputFieldPassword> {

  bool _obscureText = true;

  @override
  void _toggle() {
    setState(() {
      _obscureText =!_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white,width: 1 )
      ),
      width: size.width * 0.9,
      height: widget.height,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            obscureText: _obscureText,
            readOnly: widget.readonly == null ? false : widget.readonly,
            enabled:widget.readonly == null ?  true : false,
            keyboardType: widget.type,
            style: kTextTitleWhite,
            textAlignVertical: TextAlignVertical.center,
            controller: widget.controller,
            autofocus: false,
            cursorColor: Colors.black,
            decoration: widget.prefix == '' ? InputDecoration(
              contentPadding: EdgeInsets.zero,
              isDense: true,
              hintText:widget.hintText ,
              border: InputBorder.none,
              hintStyle: kTextTitleWhite1,
              labelStyle: kTextTitleWhite,
              suffixIcon: widget.obscureText == false
                  ? Tab(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Image.asset(
                    'assets/ic_eye.png',
                    height: 20,
                    width: 20,
                    color: Colors.white,
                  ),
                ),
              )
                  : GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _toggle();
                },
                child: Tab(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Image.asset(
                      'assets/ic_eye.png',
                      height: 20,
                      width: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ) : InputDecoration(
              contentPadding: EdgeInsets.zero,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 0),
                child: GestureDetector(
                  onTap: () {},
                  child: Tab(
                    icon: Image.asset(
                      widget.prefix,
                      height: 18,
                      fit: BoxFit.contain,
                      width: 18,
                    ),
                  ),
                ),
              ),
              isDense: true,
              hintText:widget.hintText ,
              hintStyle: kTextTitleWhite1,
              border: InputBorder.none,
              labelStyle: kTextTitleWhite,

            ),
          ),
        ),
      ),
    );
  }
}


