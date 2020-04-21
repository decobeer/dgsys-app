import 'package:dgsys_app/api/api_service.dart';
import 'package:dgsys_app/api/user_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  bool isAuthenticated;
  UserInfo userInfo = UserInfo.none();
  final ApiService apiService = ApiService();

  factory AppState(){
    return _instance;
  }

  AppState._internal(){
    this.isAuthenticated = false;
  }

  Future authenticate(String username, String password) async {
    this.isAuthenticated = await apiService.authenticate(username, password);
    if (this.isAuthenticated) {
      this.userInfo = await UserService().getUserData();
    }
    notifyListeners();
  }

  void logOut() {
    apiService.logOut();
    this.isAuthenticated = false;
    this.userInfo = UserInfo.none();
    notifyListeners();
  }

  void makePayment(double amount, {String explanation = "Blank"}) {
    Map data = {
      "amount": amount,
      "date": datetimeNowAsString(),
      "explanation": explanation
    };
    apiService.apiPost(
        '/api/payment/',
      data
    );
    notifyListeners();
  }

  String datetimeNowAsString() {
    final today = DateTime.now();
    final dateFormat = new DateFormat('y-M-dTH:m');
    return dateFormat.format(today);
  }
}