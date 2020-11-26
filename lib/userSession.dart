import 'package:shared_preferences/shared_preferences.dart';

class UserSession {

  void setAccessKey(String accessKey) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('access_key', accessKey);
  }

  Future<String> getAccessKey() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('access_key') ?? '';
  }

  void setAccessKeySecret(String accessKeySecret) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('access_key_secret', accessKeySecret);
  }

  Future<String> getAccessKeySecret() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('access_key_secret') ?? '';
  }

  void setUserId(int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt('user_id', id);
  }

  Future<int> getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt('user_id') ?? '';
  }
}