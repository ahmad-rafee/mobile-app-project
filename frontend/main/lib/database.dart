import 'package:shared_preferences/shared_preferences.dart';

class Database {
  static const String Log = "IsLogin";
  static const String FirstT = "FirstTime";
  static const String AccType = "AccountType";
  static const String Token = "AuthToken";

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(Token, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(Token);
  }

  Future<void> saveAccountType(String type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AccType, type);
  }


  Future<String?> getAccountType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AccType);
  }

  Future<void> login() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Log, true);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Log, false);
    await prefs.remove(Token);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(Log) ?? false;
  }

  Future<bool> isFirst() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(FirstT) ?? true;
  }

  Future<void> setFirstTime(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(FirstT, value);
  }

  Future<void> isNotFirst() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(FirstT, false);
  }
}
