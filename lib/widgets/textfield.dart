import 'package:flutter/material.dart';
import 'package:onlineshopapp/widgets/style.dart';

Widget textField(
    TextEditingController eControl, TextEditingController pControl) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Column(
      children: <Widget>[
        TextFormField(
          controller: eControl,
          style: textFieldStyle(),
          decoration: textDecoration("E-mail"),
          validator: (val) {
            if (val.isEmpty || !val.contains('@')) {
              return 'Enter valid Email Id';
            }
            return null;
          },
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: pControl,
          style: textFieldStyle(),
          decoration: textDecoration("Password"),
          validator: (val) {
            if (val.isEmpty) {
              return 'Enter password';
            }
            return null;
          },
          obscureText: true,
        ),
      ],
    ),
  );
}