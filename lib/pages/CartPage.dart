import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:onlineshopapp/auth/getProduct.dart';
import 'package:onlineshopapp/pages/YourOrders.dart';
import 'package:onlineshopapp/pages/homePage.dart';
import 'package:onlineshopapp/widgets/alertDialog.dart';

class CartPage extends StatefulWidget {
  static const routeName = '/cartPage';

  final String profileName;
  // final int sendCount ;
  const CartPage({this.profileName});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Product item; int countValue;
  List cartList = [];
  @override
  void initState() {
    getCartIds();
    getCartItems();
    super.initState();
  }

  Future getCartIds() async {
    var res = await http
        .get("http://localhost:4200/apis/getCart/${widget.profileName}");
    setState(() {
      var data = json.decode(res.body)['cart']['productIds'];
      for (var i in data) {
        cartList.add(i);
      }
      return cartList;
    });
  }

  Future getCartItems() async {
    List<Product> products = [];
    for (var x in cartList) {
      var response = await http.get("http://localhost:4200/apis/getProduct/$x");
      var responseData = json.decode(response.body)["item"];
      // print(responseData);

      item = Product(
          id: responseData["_id"],
          productName: responseData["title"],
          description: responseData["description"],
          price: responseData["price"],
          image: responseData["img"]);

      products.add(item);
    }
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          actions: [
            Center(
              child: Text("Your Cart",
                  style:
                      TextStyle(fontSize: 22, fontFamily: "Times New Roman")),
            ),
            SizedBox(width: 225),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 5),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: FutureBuilder(
                  future: getCartItems(),
                  builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Text("No item in the cart !!");
                    } else {
                     // countValue = snapshot.data.length;
                   
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (ctx, index) => Card(
                          elevation: 4,
                          shadowColor: Colors.pink[500],
                          child: Column(
                            children: [
                              SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.memory(
                                    base64Decode(snapshot.data[index].image),
                                    height: 100,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        snapshot.data[index].productName,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      FlatButton(
                          onPressed: (){
                            showChoiceDialog(context,"Payment Mode", "Online", "Cash on Delivery", (){
                              showSuccessDialog(context, "Your order has been placed",(){
                                http.post("http://localhost:4200/apis/addOrder",body: {
                                  "profileName": widget.profileName,
                                  "orderIds": item.id,
                                }).then((value) {
                               Navigator.of(context).push(MaterialPageRoute(
                             builder: (BuildContext context) => YourOrders(
                            profileName: widget.profileName
                          ))); 
                                });

                              });
                            });
                          }, 
                                          child: Text("Buy"),
                                          color: Colors.amber),
                                    ],
                                  ),
                                  IconButton(
                                    icon: IconButton(
                                        icon: Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                         http.delete("http://localhost:4200/apis/removeCart/${widget.profileName}/${snapshot.data[index].id}").then((value) {
                                           print(value.body);
                                          Navigator.of(context).pushReplacement(MaterialPageRoute( builder: (BuildContext context) => CartPage(
                            profileName: widget.profileName),),); 
                                         });
                                          // setState(() {
                                          //   countValue--;
                                          // });
                                        }),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 12,
                              ),
                            ],
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
