
import 'dart:convert';

import 'package:dgsys_app/api/api_service.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  UserInfo userInfo;

  UserService._internal();

  factory UserService(){
    return _instance;
  }

  void initialize(){
  }

  Future<UserInfo> getUserData() async {
    final response = await ApiService().get('user');
    if(response.statusCode == 200){
      return UserInfo.fromJson(json.decode(response.body));
    }
    else{
      return UserInfo.none();
    }
  }
}

class UserInfo{
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final double balance;
  final String membership;

  UserInfo({this.username, this.firstName, this.lastName, this.email, this.balance, this.membership});

  factory UserInfo.fromJson(Map<String, dynamic> json){
    return UserInfo(
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      balance: json['account_balance'],
      membership: json['membership_label'],
    );
  }

  factory UserInfo.none(){
    return UserInfo(
        username: "Anon",
        firstName: "Anonymous",
        lastName: "",
        email: "",
        balance: 0,
        membership: "Non-Existing"
    );
  }
}