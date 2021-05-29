import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:onlineshopapp/pages/homePage.dart';
import 'package:onlineshopapp/widgets/alertDialog.dart';
import 'package:onlineshopapp/widgets/button.dart';
import 'package:onlineshopapp/widgets/style.dart';
import 'package:onlineshopapp/widgets/textfield.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  @override
  Widget build(BuildContext context) {

    var ds = MediaQuery.of(context).size;
    SizedBox s = SizedBox(height: 10);

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(children: [
                Image.asset(
                    "assets/images/logo.png",
                    height: 220,
                  ),
                  Text(
                    "SIGN IN",
                    style: textFieldStyle(),
                  ),
                  s,
                  Container(
                    height: ds.height / 2.7, width: ds.width / 1.4,
                    child: Card(
                      borderOnForeground: true,
                      color: Colors.grey[200],
                      shadowColor: Colors.blue[900],
                      elevation: 4,
                      child: Column(
                        children: [
                          s,s,
                          textField(emailC, passC),
                          s, s, s,
                          submitButton("Login", ()async{
                            if(_formKey.currentState.validate()){
                            var val =  await http.post("http://localhost:4200/apis/login",body:{
                                "username": emailC.text,
                                "password": passC.text
                              });
                                //print(val.body);
                                if( (val.body).toString() == 'Unauthorized' ) 
                                {
                                  return showErrorDialog(context,'Unauthorized User');
                                }
                                else{
                                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>HomePage(name: emailC.text,)));
                                }                            
                            }
                          }, context),
                          txtRow("Dont' have an account ?", () {
                    Navigator.pushNamed(context, '/signUP',);
                  }, "Sign Up"),
                        ],
                      ),
                    ),
                  ),
              ],),
              ),
          ),
        ),
      ),
    );
  }
}