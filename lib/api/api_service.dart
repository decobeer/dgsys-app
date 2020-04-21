import 'dart:convert';
import 'package:dgsys_app/util/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  final AppConfig config = AppConfig();
  int a;
  AccessTokens tokens;
  List<String> equipmentCategories;

  ApiService._internal(){
    a = 3;
  }

  factory ApiService(){
    return _instance;
  }

  Future<bool> authenticate(String username, String password) async {
    final response = await http.post(config.apiBaseUrl + "token/",
      headers: {'content-type': 'application/json'},
      body: '{"email": "$username", "password": "$password"}'
      );

    if(response.statusCode == 200){
      this.tokens = AccessTokens.fromJson(json.decode(response.body));
      return true;
    }
    else{
      return false;
    }
  }

  Future<bool> refreshAuth() async {
    final response = await http.post(
      config.apiBaseUrl + '/token/refresh/',
      body: '{"refresh": "' + this.tokens.refreshToken + '"}'
    );
    return (response.statusCode == 200);
  }

  Future<http.Response> get(String path, [Map<String, dynamic> query]) async {
    final uri = Uri(
      scheme: 'http',
      host: config.host,
      port: config.port,
      path: (config.basePath + path),
      queryParameters: query
    );

    var response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer ' + this.tokens.accessToken}
    );
    if (isSuccess(response.statusCode)){
      return response;
    }
    else if (response.statusCode == 401){
      await this.refreshAuth();
      response = await http.get(
          uri,
          headers: {'Authorization': 'Bearer ' + this.tokens.accessToken}
      );
      return response;
    }
    return response;
  }

  Future<http.Response> apiPost(String uri, Map data) async {
    var response = await http.post(
      config.apiBaseUrl + uri,
      headers: {'Authorization': 'Bearer ' + this.tokens.accessToken,
        "Content-Type": "application/json"},
      body: jsonEncode(data)
    );
    if (response.statusCode >= 200 && response.statusCode <= 299){
      return response;
    }

    else if (response.statusCode == 401){
      await this.refreshAuth();
      response = await http.post(
          config.apiBaseUrl + uri,
          headers: {'Authorization': 'Bearer ' + this.tokens.accessToken},
          body: utf8.encode(json.encode(data))
      );
      return response;
    }

    else{
      print(response.body);
      return response;
    }
  }

  void logOut(){
    this.tokens = null;
  }

  bool isSuccess(int statusCode){
    return 200 <= statusCode && statusCode <= 299;
  }

  String formatDate(DateTime time){
    final dateFormat = new DateFormat('y-M-dTH:m');
    return dateFormat.format(time);
  }

}

class AccessTokens{
  final String accessToken;
  final String refreshToken;

  AccessTokens({this.accessToken, this.refreshToken});

  factory AccessTokens.fromJson(Map<String, dynamic> json){
    return AccessTokens(
      accessToken: json['access'],
      refreshToken: json['refresh']
    );
  }
}
