import 'package:shared_preferences/shared_preferences.dart';

class UserSession {

  void setUserId(int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt('user_id', id);
  }

  Future<int> getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt('user_id');
  }
}