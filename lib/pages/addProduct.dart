import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onlineshopapp/widgets/alertDialog.dart';
import 'package:onlineshopapp/widgets/button.dart';
import 'package:onlineshopapp/widgets/imageProduct.dart';
import 'package:onlineshopapp/widgets/product.dart';
import 'package:http/http.dart' as http;

class AddProduct extends StatefulWidget {
  static const routeName = "/addProduct";
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController prodNameC = TextEditingController();
  TextEditingController prodDesC = TextEditingController();
  TextEditingController priceC = TextEditingController();
  File imageFile;
    captureImageWithCamera() async {
    Navigator.pop(context);
    final file = await ImagePicker().getImage (
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
    final file = await ImagePicker().getImage (
      source: ImageSource.gallery,
      maxHeight: 680,
      maxWidth: 970,
    );
      setState(() {
        this.imageFile = File(file.path);
      });
  }

 clearProductInfo() {
    prodNameC.clear();
    prodDesC.clear();
    priceC.clear();
    setState(() {
      imageFile = null;
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
              child: Text("Add Product",
                  style: TextStyle(fontSize: 22, fontFamily: "Times New Roman")),
            ),
            SizedBox( width: 205 ),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox( height: 40, ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Card(
                      elevation: 4,
                      child: Column(
                        children: [
                          productField(prodNameC, prodDesC, priceC), Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                            IconButton(icon: Icon(Icons.add_a_photo,color: Colors.blue[900],),
                            iconSize: 45, onPressed: (){
                              takeImage(context,(){captureImageWithCamera();},(){pickImageFromGallery();},(){
                                Navigator.pop(context);
                              });
                            }),
                        Text('Selected Photo: ',
                          style: TextStyle(color: Colors.black)),
                          imageFile != null ?
                             Image.file(imageFile,width: 150,
                        height: 200,
                        fit: BoxFit.fitHeight,) : Text(''),
                            ],
                          ),
                            SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                  SizedBox( height: 20,),
                  submitButton("Add", () {
                    if (_formKey.currentState.validate()) {
                      final bytes = File(imageFile.path).readAsBytesSync();
                      String img64 = base64Encode(bytes);
                      http.post("http://localhost:4200/apis/addProduct",body:{
                        "title": prodNameC.text,
                        "description": prodDesC.text,
                        "price": priceC.text,
                        "img": img64.toString(),
                      }).then((value){ 
                        print(value.body);
                        var res = json.decode(value.body);
                        if(res['success'] == true){
                          showSuccessDialog(context,"Successfully Added",(){
                            Navigator.pop(context);
                            clearProductInfo();
                          });
                        }else{
                          showErrorDialog(context,"Failed to Add");
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
