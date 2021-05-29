import 'package:flutter/material.dart';

Widget badge(int count) {
 return Column(
   children: [
       Container(
         margin: EdgeInsets.only(bottom: 5,top:5),
         color: Colors.white,
         height: 20,width: 15,
        child: Center(
          child: Text(
            count.toString(),
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
  ),
   ],
 );
}
