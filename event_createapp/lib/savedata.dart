import 'package:shared_preferences/shared_preferences.dart';

class SavedData {
  static SharedPreferences? sharedPreferences;

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

//save user ID on device
  static Future<void> saveUserId(String id) async {
    await sharedPreferences!.setString("userId", id);
  }
  //get the user id
  static String getUserId() {
    return sharedPreferences!.getString("userId") ?? "";
  }


//save name on device
   static Future<void> saveUserName(String name) async {
    await sharedPreferences!.setString("name", name);
  }
//get the name
  static String getUserName() {
    return sharedPreferences!.getString("name") ?? "";
  }


  //save email on device
   static Future<void> saveUserEmail(String email) async {
    await sharedPreferences!.setString("email", email);
  }
//get the email
  static String getUserEmail() {
    return sharedPreferences!.getString("email") ?? "";
  }
}
