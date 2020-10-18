import 'package:shared_preferences/shared_preferences.dart';

class UserSession {

  static void setUserId(int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt('user_id', id);
  }

  static Future<int> getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt('user_id');
  }
}