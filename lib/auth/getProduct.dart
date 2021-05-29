import 'dart:convert';
import 'package:http/http.dart' as http;

class Product{
  final String id;
  final String productName;
  final String description;
  final String price;
  final String image;

  Product({this.id, this.productName, this.description, this.price, this.image});
}

  Future<List<Product>> getProducts() async {
    var response = await http.get("http://localhost:4200/apis/getAllProduct");
    var responseData = json.decode(response.body)["item"];
    // print(responseData);
    List<Product> productList = [];
    for (var i in responseData) {
      Product item = Product(
          id: i["_id"],
          productName: i["title"],
          description: i["description"],
          price: i["price"],
          image: i["img"]);
      productList.add(item);
    }
    return productList;
  }

  
  Future<Product> getSingleProduct(String id) async {
  var response = await http.get("http://localhost:4200/apis/getProduct/$id");
  var responseData = json.decode(response.body)["item"];
  print(responseData);
   Product item = Product(
    id: id,
    productName: responseData["title"],
    description: responseData["description"],
    price: responseData["price"],
    image: responseData["image"]
  );
  return item;
}