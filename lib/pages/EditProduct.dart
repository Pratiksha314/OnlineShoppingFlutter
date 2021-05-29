import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onlineshopapp/auth/getProduct.dart';
import 'package:onlineshopapp/pages/homePage.dart';
import 'package:onlineshopapp/widgets/alertDialog.dart';
import 'package:onlineshopapp/widgets/button.dart';
import 'package:onlineshopapp/widgets/imageProduct.dart';
import 'package:onlineshopapp/widgets/product.dart';

class EditProduct extends StatefulWidget {
  static const routeName = '/editProduct';

  final String productId, nameUser;
  const EditProduct({this.productId, this.nameUser});

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController prodNameC = TextEditingController();
  TextEditingController prodDesC = TextEditingController();
  TextEditingController priceC = TextEditingController();
  File imageFile;
  Product item = Product();
  String pic, img64;
  captureImageWithCamera() async {
    Navigator.pop(context);
    final file = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxHeight: 680,
      maxWidth: 970,
    );
    setState(() {
      this.imageFile = File(file.path);
    });
  }

  pickImageFromGallery() async {
    Navigator.pop(context);
    final file = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxHeight: 680,
      maxWidth: 970,
    );
    setState(() {
      this.imageFile = File(file.path);
    });
  }

  void initState() {
    getSingleProduct(widget.productId);
    super.initState();
  }

  Future<Product> getSingleProduct(String id) async {
    var response = await http
        .get("http://localhost:4200/apis/getProduct/${widget.productId}");
    var responseData = json.decode(response.body)["item"];
    // print(responseData);
    setState(() {
      item = Product(
          id: widget.productId,
          productName: responseData["title"],
          description: responseData["description"],
          price: responseData["price"],
          image: responseData["img"]);

      prodNameC.text = item.productName;
      prodDesC.text = item.description;
      priceC.text = item.price;
      pic = item.image;

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
            Center(
              child: Text("Edit Product",
                  style:
                      TextStyle(fontSize: 22, fontFamily: "Times New Roman")),
            ),
            SizedBox(width: 205),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text("Previous Photo!!"),
                  pic == null
                      ? CircularProgressIndicator(
                          backgroundColor: Colors.pink[400])
                      : Image.memory(base64Decode(pic),
                          height: MediaQuery.of(context).size.height / 3),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Card(
                      elevation: 4,
                      child: Column(
                        children: [
                          productField(prodNameC, prodDesC, priceC),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                  icon: Icon(
                                    Icons.add_a_photo,
                                    color: Colors.blue[900],
                                  ),
                                  iconSize: 45,
                                  onPressed: () {
                                    takeImage(context, () {
                                      captureImageWithCamera();
                                    }, () {
                                      pickImageFromGallery();
                                    }, () {
                                      Navigator.pop(context);
                                    });
                                  }),
                              Text('New Photo: ',
                                  style: TextStyle(color: Colors.black)),
                              imageFile != null
                                  ? Image.file(
                                      imageFile,
                                      width: 150,
                                      height: 200,
                                      fit: BoxFit.fitHeight,
                                    )
                                  : Text(''),
                            ],
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  submitButton("Edit", () {
                    if (_formKey.currentState.validate()) {
                      if (imageFile != null) {
                        final bytes = File(imageFile.path).readAsBytesSync();
                        img64 = base64Encode(bytes);
                      }
                      http.patch(
                          "http://localhost:4200/apis/editProduct/${widget.productId}",
                          body: {
                            "title": prodNameC.text,
                            "description": prodDesC.text,
                            "price": priceC.text,
                            "img": imageFile != null ? img64.toString() : pic
                          }).then((value) {
                        // print(value.body);
                        var res = json.decode(value.body);
                        if (res['success'] == true) {
                          showSuccessDialog(context, "Successfully Edit", () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(
                                        name: widget.nameUser,
                                      )),
                            ).then((value) => setState(() {}));
                          });
                        } else {
                          showErrorDialog(context, "Fail to Edit");
                        }
                      });
                    }
                  }, context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}