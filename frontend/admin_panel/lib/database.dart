import 'package:shared_preferences/shared_preferences.dart';

class Database {
  static const String Log = "IsLogin";
  static const String FirstT = "FirstTime";
  static const String AccType = "AccountType";
  static const String IsApproved = "IsApproved";

  Future<void> setApprovalStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(IsApproved, status);
  }
  Future<bool> checkApproval() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(IsApproved) ?? false;
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
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(Log) ?? false;
  }

  Future<bool> isFirst() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(FirstT) ?? true;
  }

  Future<void> isNotFirst() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(FirstT, false);
  }
}
