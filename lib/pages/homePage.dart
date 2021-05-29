import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:onlineshopapp/auth/getProduct.dart';
import 'package:onlineshopapp/pages/AboutUs.dart';
import 'package:onlineshopapp/pages/CartPage.dart';
import 'package:onlineshopapp/pages/ProductDetail.dart';
import 'package:onlineshopapp/pages/YourOrders.dart';
import 'package:onlineshopapp/pages/account.dart';
import 'package:onlineshopapp/widgets/button.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/homePage';
  final String name;
  final int counting;
  const HomePage({this.name, this.counting});
  @override
  _HomePageState createState() => _HomePageState();
}

@override
class _HomePageState extends State<HomePage> {
    final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
    int count = 0;
  int role = 0;
  String profileName = '';
  void initState() {
    getUserDetail();
    getProducts();
    super.initState();
  }

  getUserDetail() {
    http.post("http://localhost:4200/apis/getUserInfo", body: {
      "username": widget.name,
    }).then((response) {
      // print(json.decode(response.body).toString());
      var data = json.decode(response.body);
      setState(() {
        role = data['user']['role'];
        profileName = data['user']['profileName'];
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    var s = SizedBox(
      height: 10,
    );
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          actions: [
            IconButton(
              icon: Icon(Icons.shopping_basket,color: Colors.pinkAccent,),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute( builder: (BuildContext context) => CartPage(
                            profileName: profileName),),);             
                 },
            ),
            // badge(
            //   count
            // ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        drawer: Drawer(
          elevation: 19,
          child: Center(
            child: Column(
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  height: 200,
                ),
                s,
                Text(
                  "Welcome",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Times New Roman"),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '${profileName.toUpperCase()}',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[900],
                      fontStyle: FontStyle.italic,
                      fontFamily: "Times New Roman"),
                ),
                SizedBox(
                  height: 35,
                ),
                role == 1
                    ? flatbutton(context, "All Users", () {
                        Navigator.pushNamed(context, '/allUsers');
                      })
                    : Text(''),
                    s,
                                    role == 1
                    ? flatbutton(context, "Add Product", () {
                        Navigator.pushNamed(context, "/addProduct");
                      }) : Text(''),s,
                flatbutton(context, "Account Setting", () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => AccountSetting(
                            name: widget.name,
                          )));
                }),
                s,

                     flatbutton(context, "Your Orders", () {
                       Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => YourOrders(
                            profileName: profileName,
                          )));
                     }),
                s,
                // flatbutton(context, "Any Issue ?", () {}),
                // s,
                flatbutton(context, "Logout", () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (route) => false);
                }),
                s,
                flatbutton(context, "About Us", () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => AboutUs(
                            role: role,
                          )));
                }),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 8),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: FutureBuilder(
                    future: getProducts(),
                    builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.pink[500],
                          ),
                        );
                      } else {
                        return GridView.builder(
                          itemCount: snapshot.data.length,
                          physics: NeverScrollableScrollPhysics(),   // to make grid view scrollable
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 8,
                          ),
                          itemBuilder: (ctx, index) => ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                              child: GridTile(
                                child: GestureDetector(
                                    onTap: (){
                                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>ProductDetail(
                                        profileName: profileName,
                                        userName: widget.name,
                                        typeOfUser:role,
                                        productId: snapshot.data[index].id),),);
                                    },
                                    child: Image.memory(
                                      base64Decode(snapshot.data[index].image,),
                                      height: 100,
                                       // database main img ki string to vapas se image karna
                                      fit: BoxFit.cover,
                                    ),
                                    ),
                                footer: GridTileBar(
                                  backgroundColor: Colors.black38,
                                  title: Text(snapshot.data[index].productName, textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                  subtitle: Text("Rs. ${snapshot.data[index].price}",textAlign: TextAlign.center,
                                  style: TextStyle(color:Colors.white,fontSize: 15,fontWeight: FontWeight.bold),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.shopping_basket,
                                      color: Colors.pinkAccent, size: 25,
                                    ),
                                    onPressed: () {
                                      http.post("http://localhost:4200/apis/addCart",body: {
                                        "profileName": profileName,
                                        "productIds": snapshot.data[index].id,
                                      }).then((value) => print(value.body));
                                      scaffoldKey.currentState.showSnackBar(
                                        SnackBar( content: Text('Added item to the cart!'),
                                          duration: Duration(seconds: 2),
                                        ),
                                     );
                                    //  setState(() {
                                    //    count++;
                                    //  });
                                    },
                                  ),
                                ),
                              ),
                            ),
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
