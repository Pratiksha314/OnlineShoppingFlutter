import 'package:flutter/material.dart';
import 'package:onlineshopapp/auth/getProduct.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class YourOrders extends StatefulWidget {
  static const routeName = '/yourOrder';
  // final String orderId;
  final String profileName;
  
  const YourOrders({ this.profileName });

  @override
  _YourOrdersState createState() => _YourOrdersState();
}

class _YourOrdersState extends State<YourOrders> {
    Product item;
  List orderList = [];
  @override
  void initState() {
    getOrderIds();
    getOrderItems();
    super.initState();
  }

  Future getOrderIds() async {
    var res = await http
        .get("http://localhost:4200/apis/getOrder/${widget.profileName}");
    setState(() {
      var data = json.decode(res.body)['order']['orderIds'];
      for (var i in data) {
        orderList.add(i);
      }
      return orderList;
    });
  }

  Future getOrderItems() async {
    List<Product> products = [];
    for (var x in orderList) {
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
              child: Text("Your Orders",
                  style: TextStyle(fontSize: 22, fontFamily: "Times New Roman")),
            ),
            SizedBox( width: 205 ),
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
                  future: getOrderItems(),
                  builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Text("No item in the cart !!");
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (ctx, index) => Card(
                          elevation: 5,
                          shadowColor: Colors.green[600],
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
                                          child: Text("Purchased"),
                                          color: Colors.amber),
                                    ],
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
          ),),
      ),
    );
  }
}