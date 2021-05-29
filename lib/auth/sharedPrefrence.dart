// import 'package:shared_preferences/shared_preferences.dart';

// class SharedFunctions {
// //sharedPreference User LoggedIn Key 
// static String sharedkey = "ISLOGGEDIN";
// //sharedPreference User Name Key
// static String  namekey = "USERNAMEKEY";
// //sharedPreference User Email Key
// static String  emailkey = "USEREMAILKEY";
// //sharedPreference User Password Key
// static String passwordkey = "PASSWORDKEY";
// //sharedPreference Type Login
// static String typeKey = "TYPELOGIN";

// // saving data to shared preference
// // static se we can use this function anywhere 
// static Future <bool> saveUserLoggedInSP(bool isuserLoggedIn) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return  prefs.setBool(sharedkey, isuserLoggedIn);
// }

// static Future <bool> saveUserEmailSP(String userEmail) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.setString(emailkey, userEmail);
// }

// static Future <bool> saveUserProfileSP(String userName) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.setString(namekey, userName);
// }

// static Future<bool> saveUserPasswordSP(String userPassword) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.setString(passwordkey, userPassword);
// }

// static Future<bool> saveUserTypeLogin(String typeLogin) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.setString(typeKey, typeLogin);
// }

// //getting data from shared preference
// static Future<bool> getUserLoggedInSP() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return  prefs.getBool(sharedkey);
// }

// static Future<String> getUserEmailSP() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getString(emailkey);
// }

// static Future<String> getUserProfileSP() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return  prefs.getString(namekey);
// }
// static Future<String> getUserPasswordSP() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getString(passwordkey);
// }
// static Future<String> getUserTypeLogin() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getString(typeKey);
// }
// }