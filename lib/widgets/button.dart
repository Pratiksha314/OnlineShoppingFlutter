import 'package:flutter/material.dart';
import 'package:onlineshopapp/widgets/style.dart';

Widget submitButton(String text, Function func, BuildContext context) {
  return GestureDetector(
    onTap: func,
    child: Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width / 3.5,
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
          color: Colors.blue[900],
          borderRadius: BorderRadius.circular(32)),
      child: Text(
        text,
        style: styleText(),
      ),
    ),
  );
}
Widget txtRow(String text, Function func, String txt) {
  return Row(
    children: <Widget>[
      SizedBox(
        width: 18,
      ),
      Text(
        text,
        style: TextStyle(color: Colors.black),
      ),
      FlatButton(
          onPressed: func,
          child: Text(
            txt,
        style: TextStyle(color: Colors.blue[900]),
          )),
    ],
  );
}

Widget flatbutton(BuildContext context, String text, Function fn) {
  return FlatButton(
    child: Text(text,
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w400,
        color: Colors.black,
        fontFamily: "Times New Roman"
      ),
    ),
    onPressed: fn,
  );
}