import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:onlineshopapp/auth/constant.dart';
import 'package:onlineshopapp/widgets/alertDialog.dart';
import 'package:onlineshopapp/widgets/button.dart';
import 'package:onlineshopapp/widgets/style.dart';
import 'package:onlineshopapp/widgets/textfield.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  static const routeName = '/signUP';
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController profileC = TextEditingController();
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
            child: Column(
              children: <Widget>[
                Image.asset(
                  "assets/images/logo.png",
                  height: 200,
                ),
                Text(
                  "Create New Account!!",
                  style: textFieldStyle(),
                ),
                s,
                Container(
                  height: ds.height / 1.79,
                  width: ds.width / 1.4,
                  child: Card(
                    borderOnForeground: true,
                    color: Colors.grey[200],
                    shadowColor: Colors.blue[900],
                    elevation: 4,
                    child: Column(
                      children: [
                        s,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: TextFormField(
                            controller: profileC,
                            validator: (val) {
                              return val.isEmpty
                                  ? 'Enter correct Username'
                                  : null;
                            },
                            style: textFieldStyle(),
                            decoration: textDecoration("Username"),
                          ),
                        ),
                        textField(emailC, passC),
                        s,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: TextFormField(
                            style: textFieldStyle(),
                            decoration: textDecoration("Confirm Password"),
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'Enter confirm password';
                              }
                              if (val != passC.text)
                                return 'Password does not match';
                              return null;
                            },
                            obscureText: true,
                          ),
                        ),
                        s,
                        s,
                        s,
                        submitButton("Sign Up", () {
                          if (_formKey.currentState.validate()) {
                            http.post("http://localhost:4200/apis/sendOtp", body: {
                              "username": emailC.text,
                            }).then((response) {
                              var otpValue = json.decode(response.body);
                              if (otpValue['success'] == false) {
                                showErrorDialog(
                                    context, "User Already Exists!!");
                              } else {
                                Navigator.pushNamed(
                                  context,
                                  '/verifyOtp',
                                  arguments: Constant(
                                      username: emailC.text,
                                      otp: otpValue['otpSend'].toString(),
                                      profilename: profileC.text,
                                      password: passC.text),
                                );
                              }
                            });
                          }
                        }, context),
                        txtRow("Already have an account ?", () {
                        Navigator.pushNamed(context, '/login');
                        }, "Sign In"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
