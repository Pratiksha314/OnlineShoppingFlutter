import 'package:flutter/material.dart';

takeImage(BuildContext mContext, Function tap, Function press, Function popF) {
  return showDialog(
      context: mContext,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            " Add Product Image",
            style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold),
          ),
          children: <Widget>[
            SimpleDialogOption(
              child: Text ( 
                "Take Image with Camera",
                style: TextStyle(
                  color: Colors.black, fontSize: 16
                ),
              ),
              onPressed: tap,
            ),
            SimpleDialogOption(
              child: Text (
                "Take Image from Gallery",
                style: TextStyle(
                  color: Colors.black, fontSize: 16
                ),
              ),
              onPressed: press,
            ),
            SimpleDialogOption(
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.black,fontSize: 16
                ),
              ),
              onPressed: popF,
            ),
          ],
        );
      });
}