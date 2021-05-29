import 'package:flutter/material.dart';
import 'package:onlineshopapp/auth/constant.dart';
import 'package:onlineshopapp/auth/sharedPrefrence.dart';
import 'package:onlineshopapp/widgets/alertDialog.dart';
import 'package:onlineshopapp/widgets/button.dart';
import 'package:onlineshopapp/widgets/style.dart';
import 'package:http/http.dart' as http;

class VerifyOTP extends StatefulWidget {
  static const routeName = '/verifyOtp';
  @override
  _VerifyOTPState createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController otpC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Constant args = ModalRoute.of(context).settings.arguments;

    var ds = MediaQuery.of(context).size;
    SizedBox s = SizedBox(height: 10);
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset("assets/images/logo.png",
                  height: 220,),
                   Text(
                  "Verify your Email ID!!",
                  style: textFieldStyle(),
                ),
                s,
                Container(
                  height: ds.height / 4.4, width: ds.width / 1.5,
                  child: Card(
                    borderOnForeground: true,
                    color: Colors.grey[200],
                    shadowColor: Colors.blue[900],
                    elevation: 4,
                    child: Column(
                      children: [
                        s,s,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            style: textFieldStyle(),
                            decoration: textDecoration("Enter OTP"),
                            controller: otpC,
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'Please enter a valid OTP';
                              }
                              return null;
                            },
                          ),
                        ),
                        s, s, s,
                        submitButton("Verify", (){
                          if(_formKey.currentState.validate()){
                            if(args.otp == otpC.text){
                                // SharedFunctions.saveUserEmailSP(args.username);
                                // SharedFunctions.saveUserProfileSP(args.profilename);
                                // SharedFunctions.saveUserPasswordSP(args.password);
                              http.post('http://localhost:4200/apis/signup',body: {
                                "username": args.username,
                                "profileName": args.profilename,
                                "password": args.password,
                              }).then((value){
                                // SharedFunctions.saveUserLoggedInSP(true);
                                http.post("http://localhost:4200/apis/thankMail",body: {
                                  "username": args.username,
                                  "profileName":args.profilename
                                }).then((value) {
                                Navigator.pushNamed(context, '/login'); 
                                });
                              });
                            }
                            else{
                              showErrorDialog(context, "Please Enter Correct OTP!!");
                            }
                          }
                        }, context)
                      ],
                    ),
                  ),
                ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}