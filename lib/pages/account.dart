import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onlineshopapp/pages/homePage.dart';
import 'package:onlineshopapp/widgets/alertDialog.dart';
import 'package:onlineshopapp/widgets/button.dart';
import 'package:onlineshopapp/widgets/style.dart';

class AccountSetting extends StatefulWidget {
  static const routeName = '/account';
  final String name;

  const AccountSetting({Key key, this.name}) : super(key: key);
  @override
  _AccountSettingState createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  TextEditingController profileC = TextEditingController();
  String profileName = '';
  String username = '';
  String createdAt = '';
  int flag = 1, role=0;
  void initState() {
    getUserDetail();
    super.initState();
  }

  getUserDetail() {
    http.post("http://localhost:4200/apis/getUserInfo", body: {
      "username": widget.name,
    }).then((response) {
      // print(json.decode(response.body).toString());
      var data = json.decode(response.body);
      setState(() {
        profileName = data['user']['profileName'];
        username = data['user']['username'];
        createdAt = data['user']['createdAt'];
        role = data['user']['role'];
        profileC.text = profileName;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          actions: [
            Center(
              child: Text("Account Settings",
                  style:
                      TextStyle(fontSize: 22, fontFamily: "Times New Roman")),
            ),
            SizedBox(
              width: 150,
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 10,
                color: role == 0 ?Colors.blue[100] : Colors.red[200],
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Profile Name: ${profileName}",
                        style: textFieldStyle(),
                      ),
                      Text(
                        "Email Id: ${username}",
                        style: textFieldStyle(),
                      ),
                      Text(
                        "Account Created At: ${createdAt}",
                        style: textFieldStyle(),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 35,),
              Card(
                elevation: 5,
                child: flatbutton(context, "Change Profile Name", () {
                  setState(() {
                    flag = 0;
                  });
                }),
              ),
              flag == 1 ? Text('') :
              Column(
                children: [
                         Padding(
                          padding: const EdgeInsets.all(35),
                          child: TextFormField(
                            controller: profileC,
                            decoration:
                                InputDecoration(labelText: 'Profile Name'),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a description.';
                              }
                              if (value.length < 10) {
                                return 'Should be at least 10 characters long.';
                              }
                              return null;
                            },
                          ),
                        ),
                        submitButton("Change", (){
                          http.patch("http://localhost:4200/apis/updateProfileName",body: {
                            "profileName": profileC.text,
                            "username": username,
                          }).then((value) {
                            print(value.body);
                            var val = json.decode(value.body);
                            if(val['success'] == true) {
                            showSuccessDialog(context, "Name has successfully changed!",(){
                          Navigator.push( context, MaterialPageRoute( builder: (context) => HomePage(name: username,)), ).then((value) => setState(() {}));              
                                                    setState(() {
                              flag = 1;
                            });
                            });

                            }
                            else showErrorDialog(context, "Name Already Exists");

                            // Navigator.pushReplacement( context, //refresh kardegi current page ko automatic
                            //     MaterialPageRoute( builder: (BuildContext context) => super.widget));             
                          });

                        }, context)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
