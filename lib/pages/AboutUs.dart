import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:onlineshopapp/widgets/button.dart';
import 'package:http/http.dart' as http;

class AboutUs extends StatefulWidget {
  static const routeName = '/about';

  final int role;

  const AboutUs({this.role});

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  TextEditingController desC = TextEditingController();
  String descrip = '';
  int flag = 1;
  @override
  void initState() {
    getAboutUs();
    super.initState();
  }

  Future getAboutUs() async {
    var result = await http.get("http://localhost:4200/apis/getAboutUs");
    descrip = json.decode(result.body)['des']['description'];
    setState(() {
      desC.text = descrip;
    });
    // print(descrip);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          actions: [
            Center(
              child: Text("About Us",
                  style:
                      TextStyle(fontSize: 22, fontFamily: "Times New Roman")),
            ),
            SizedBox(
              width: 225,
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Center(
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    height: 200,
                  ),
                  Column(
                    children: [
                      widget.role == 1 ? submitButton("Edit", () {
                              setState(() {
                                flag = 0;
                              });
                            }, context) : Text(''),
                      SizedBox(  height: 20,),
                    flag == 1 ?  Text(descrip, style: TextStyle(fontSize: 20)) : Text(''),
                    ],),
                  flag == 1  ? SizedBox(  height: 10, )
                      : Padding(
                          padding: const EdgeInsets.all(25),
                          child: TextFormField(
                            controller: desC,
                            decoration:
                                InputDecoration(labelText: 'Description'),
                            maxLines: 3,
                            keyboardType: TextInputType.multiline,
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
                  flag == 1 ? Text('')
                      : submitButton("Done", () {
                          http.patch("http://localhost:4200/apis/editAboutUs",
                              body: {"description": desC.text}).then((value) {
                            setState(() {
                              flag = 1;
                            });
                            Navigator.pushReplacement( context, //refresh kardegi current page ko automatic
                                MaterialPageRoute( builder: (BuildContext context) => super.widget));
                          }); }, context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}