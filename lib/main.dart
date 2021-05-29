import 'package:flutter/material.dart';
import 'package:onlineshopapp/pages/AboutUs.dart';
import 'package:onlineshopapp/pages/CartPage.dart';
import 'package:onlineshopapp/pages/EditProduct.dart';
import 'package:onlineshopapp/pages/ProductDetail.dart';
import 'package:onlineshopapp/pages/YourOrders.dart';
import 'package:onlineshopapp/pages/account.dart';
import 'package:onlineshopapp/pages/addProduct.dart';
import 'package:onlineshopapp/pages/allUsers.dart';
import 'package:onlineshopapp/pages/homePage.dart';
import 'package:onlineshopapp/pages/login.dart';
import 'package:onlineshopapp/pages/signup.dart';
import 'package:onlineshopapp/pages/verify.dart';

void main() =>  runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Commerce',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SignUpPage(),
      routes: {
        VerifyOTP.routeName:(ctx) => VerifyOTP(),
        SignUpPage.routeName:(ctx) => SignUpPage(),
        LoginPage.routeName:(ctx) => LoginPage(),
        HomePage.routeName:(ctx) =>  HomePage(),
        AllUsers.routeName:(ctx) => AllUsers(),
        AboutUs.routeName:(ctx) => AboutUs(),
        AccountSetting.routeName:(ctx) => AccountSetting(),
        AddProduct.routeName:(ctx) => AddProduct(),
        ProductDetail.routeName:(ctx) => ProductDetail(),
        EditProduct.routeName:(ctx) => EditProduct(),
        CartPage.routeName:(ctx) => CartPage(),
        YourOrders.routeName:(ctx) => YourOrders(),
      },
    );
  }
}
