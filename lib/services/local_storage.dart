import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _tokenKey = 'auth_token';

  /// SAVE TOKEN
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// GET TOKEN
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// REMOVE TOKEN (Logout)
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  /// CHECK LOGIN
  // static Future<bool> isLoggedIn() async {
  //   return (await getToken()) != null;
  // }

  // Save require signup

  static const _isRequireSignupKey = 'isRequireSignup';
  static Future<void> saveRequireSignup(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isRequireSignupKey, value);
  }

  static Future<bool?> getRequireSignup() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isRequireSignupKey);
  }

  static const userIdKey = 'user_id';

  // Save require signup
  static Future<void> saveUserId(String value) async {
    print('setting  userid $value');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userIdKey, value);
    String? setedUserId =  prefs.getString(userIdKey);
    print('=============+++++++++===============');
    print(setedUserId);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  static Future<bool> isLoggedIn() async {
    return (await getUserId()) != null;
  }

 static clearLocalStorate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_isRequireSignupKey);
    await prefs.remove(userIdKey);
  }
}
