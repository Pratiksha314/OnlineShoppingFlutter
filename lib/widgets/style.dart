import 'package:flutter/material.dart';

TextStyle styleText() {
  return TextStyle(
    color: Colors.white,
    fontSize: 17,
  );
}

InputDecoration textDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(color: Colors.blue[900], fontSize: 18),
    focusedBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
    enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
  );
}

TextStyle textFieldStyle() {
  return TextStyle(
    color: Color(0xff1F1F1F),
    fontSize: 18, fontWeight: FontWeight.w400
  );
}