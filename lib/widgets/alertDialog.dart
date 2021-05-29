import 'package:flutter/material.dart';

void showErrorDialog(BuildContext context, String textInfo) {
  showDialog(
    context: context,
      builder: (ctx) => AlertDialog(
        title: Text(textInfo),
        // content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay', style: (TextStyle(
              fontSize: 18
            )),),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
       ],
     ),
  );
}

void showConfirmDialog(BuildContext context,String textInfo, Function delFunc){
  showDialog(
    context: context,
      builder: (ctx) => AlertDialog(
        title: Text(textInfo),
        // content: Text(message),
        actions: <Widget>[
                    FlatButton(
            child: Text('Yes', style: (TextStyle(
              fontSize: 18
            )),),
            onPressed: delFunc,
          ),
          FlatButton(
            child: Text('No', style: (TextStyle(
              fontSize: 18
            )),),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
       ],
     ),
  );
}

void showSuccessDialog(BuildContext context, String textInfo,Function fun){
  showDialog(
    context: context,
      builder: (ctx) => AlertDialog(
        title: Text(textInfo,style: TextStyle(color: Colors.green[500]),),
        // content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay', style: (TextStyle(
              fontSize: 18
            )),),
            onPressed: fun
          ),
       ],
     ),
  );
}

void showChoiceDialog(BuildContext context,String textInfo, String pay1, String pay2, Function delFunc){
  showDialog(
    context: context,
      builder: (ctx) => AlertDialog(
        title: Text(textInfo),
        // content: Text(message),
        actions: <Widget>[
                    FlatButton(
            child: Text(pay1, style: (TextStyle(
              fontSize: 18
            )),),
            onPressed: delFunc,
          ),
          FlatButton(
            child: Text(pay2, style: (TextStyle(
              fontSize: 18
            )),),
            onPressed: delFunc,
          ),
       ],
     ),
  );
}