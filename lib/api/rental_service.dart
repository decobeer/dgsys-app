import 'dart:convert';
import 'dart:io';

import 'package:dgsys_app/api/api_service.dart';
import 'package:dgsys_app/models/app_states.dart';
import 'package:dgsys_app/models/rental_model.dart';

class RentalService{
  static getOpenRentals() async {
    final response = await ApiService().get('rental/open/');
    var parsedResponse = json.decode(response.body);
    var rawList = parsedResponse['data'];
    List<Rental> openRental = List<Rental>();
    for(var item in rawList){
      openRental.add(Rental.fromJson(item));
    }
    return openRental;
  }

  static Future<Rental> returnRental(Rental rental) async {
    final response = await ApiService().put(
        'rental',
        rental.id.toString(),
        {'end_date': ApiService().formatDate(rental.endTime)});

    if(ApiService().isSuccess(response.statusCode)){
      var parsedResponse = json.decode(response.body)['data'];
      Rental result = Rental.fromJson(parsedResponse);
      AppState().updateUserInfo();
      return result;
    }
    else {
      throw HttpException(json.decode(response.body));
    }
  }
}