import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:onlineshopapp/auth/getProduct.dart';
import 'package:onlineshopapp/pages/EditProduct.dart';
import 'package:onlineshopapp/pages/YourOrders.dart';
import 'package:onlineshopapp/pages/homePage.dart';
import 'package:onlineshopapp/widgets/alertDialog.dart';
import 'package:onlineshopapp/widgets/lineContainer.dart';
import 'package:onlineshopapp/widgets/style.dart';

class ProductDetail extends StatefulWidget {
  static const routeName = '/productDetail';
  final String productId, userName,profileName;
  final int typeOfUser;
  const ProductDetail({this.productId, this.typeOfUser, this.userName, this.profileName});

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  Product item = Product();

  @override
  void initState() {
    getSingleProduct(widget.productId);
    super.initState();
  }

  Future<Product> getSingleProduct(String id) async {
    var response = await http.get("http://localhost:4200/apis/getProduct/$id");
    var responseData = json.decode(response.body)["item"];
    // print(responseData);
    setState(() {
      item = Product(
          id: id,
          productName: responseData["title"],
          description: responseData["description"],
          price: responseData["price"],
          image: responseData["img"]);
      return item;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          actions: [
            widget.typeOfUser == 0
                ? Text('')
                : IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => EditProduct(
                            productId: item.id,nameUser: widget.userName,
                          ),
                        ),
                      );
                    }),
            widget.typeOfUser == 0
                ? Text('')
                : IconButton(
                    icon: Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      showConfirmDialog(context, "Want to delete?", () {
                        http
                            .delete(
                                "http://localhost:4200/apis/deleteProduct/${item.id}")
                            .then((value) {
                          var res = json.decode(value.body);
                          if (res['success'] == true) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(
                                        name: widget.userName,
                                      )),
                            ).then((value) => setState(() {}));
                          } else {
                            showErrorDialog(context, "Falied to delete!!");
                          }
                        });
                      });
                    })
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(item.productName.toString(),
                    style: TextStyle(
                        fontSize: 35,
                        fontFamily: "Times New Roman",
                        fontWeight: FontWeight.w500)),
                        FlatButton(
                          color: Colors.amber,
                          onPressed: (){
                            showChoiceDialog(context,"Payment Mode", "Online", "Cash on Delivery", (){
                              showSuccessDialog(context, "Your order has been placed",(){
                                http.post("http://localhost:4200/apis/addOrder",body: {
                                  "profileName": widget.profileName,
                                  "orderIds": item.id,
                                }).then((value) {
                               Navigator.of(context).push(MaterialPageRoute(
                             builder: (BuildContext context) => HomePage(
                            name: widget.userName
                          ))); 
                                });

                              });
                            });
                          }, 
                          child: Text("Buy",style: textFieldStyle(),),),
                  ],
                ),
                if (item.image == null)
                  CircularProgressIndicator(backgroundColor: Colors.pink[400])
                else
                  Image.memory(base64Decode(item.image)),
                SizedBox(height: 10),
                Text(item.description.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        fontFamily: "Times New Roman")),
                SizedBox(height: 10),
                linecontainer(context),
                SizedBox(height: 10),
                Text(
                  "Rs. ${item.price.toString()}",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
