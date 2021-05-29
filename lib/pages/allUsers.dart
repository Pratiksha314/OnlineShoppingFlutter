import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onlineshopapp/auth/getUsers.dart';
import 'package:onlineshopapp/widgets/alertDialog.dart';

class AllUsers extends StatefulWidget {
  static const routeName = '/allUsers';
  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  @override
  void initState() {
    getAllUsersInfo();
    super.initState();
  }


  Future<List<User>> getAllUsersInfo() async {
    var response = await http.get("http://localhost:4200/apis/getAllUsersInfo");
    // print(json.decode(response.body)["detail"]);
    var responseData = json.decode(response.body)["detail"];
    // create a list to store Users details:
    List<User> usersList = [];
    for (var i in responseData) {
      User user =
          User(role: i["role"], pName: i["profileName"], uName: i["username"]);
      usersList.add(user);
    }
    return usersList;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          actions: [
            Center(
              child: Text("Details of Users",
                  style:
                      TextStyle(fontSize: 22, fontFamily: "Times New Roman")),
            ),
            SizedBox(
              width: 165,
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 5),
              Container(
                child: FutureBuilder(
                  future: getAllUsersInfo(),
                  builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Center(
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.pink[500],
                        ),
                      //     child: Container(
                      //         child: Text(
                      //   'No data found',
                      //   style: TextStyle(color: Colors.black),
                      // )),
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (ctx, index) => Card(
                          elevation: 4,
                          shadowColor: snapshot.data[index].role == 0
                              ? Colors.blue[400]
                              : Colors.red[400],
                          child: ListTile(
                            title: Text(
                              (snapshot.data[index].pName).toUpperCase(),
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  snapshot.data[index].role == 0
                                      ? "User"
                                      : "Admin",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete_forever,
                                    color: Colors.red[900],
                                  ),
                                  onPressed: () {
                                    showConfirmDialog(
                                        context, 'Want to delete?', () {
                                      http.delete(
                                          "http://localhost:4200/apis/deleteUser/${snapshot.data[index].uName}").then((value) {
                                            http.delete("http://localhost:4200/apis/deleteOrder/${snapshot.data[index].pName}").then((value) {
                                             http.delete("http://localhost:4200/apis/deleteCart/${snapshot.data[index].pName}").then((value) {
                                              http.post("http://localhost:4200/apis/deleteMail",body:{
                                               "username":snapshot.data[index].uName,
                                               "profileName":snapshot.data[index].pName
                                           });
                                      });
                                      var res = json.decode(value.body);
                                        if(res['success'] == true){
                                        setState(() {
                                          
                                        });
                                        Navigator.of(context, rootNavigator: true).pop();
                                      }else{
                                        showErrorDialog(context, "Falied to delete!!");
                                      }
                                      });
                                          
                                      // var res = json.decode(response.body);
                                      // print(res);
                                      // print(res['success']);

                                    }  );                                   
                                  },
                                );
                                  })
                              ],
                            ),
                            trailing: Text(snapshot.data[index].uName,
                                style: TextStyle(fontSize: 15)),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
