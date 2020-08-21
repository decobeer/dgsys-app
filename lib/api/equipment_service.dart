import 'dart:convert';

import 'package:dgsys_app/api/api_service.dart';
import 'package:dgsys_app/models/equipment_model.dart';

class EquipmentService {
  static Future<List<Equipment>> getEquipment({DateTime from, DateTime to}) async {
    ApiService apiService = ApiService();

    if(to != null &&  from != null){
      String formattedFromDate = apiService.formatDate(from);
      String formattedToDate = apiService.formatDate(to);
      final response = await apiService.get(
          'equipment/',
          {'from': formattedFromDate,
            'to': formattedToDate});
      var decodedResponse = json.decode(response.body)['data'];
      return Equipment.fromJsonList(decodedResponse);
    }

    final response = await apiService.get('equipment/');
    var parsedRespose = json.decode(response.body);
    var rawEquipmentList = parsedRespose['data'];
    var equipmentList = List<Equipment>();
    for(var equipment in rawEquipmentList){
      equipmentList.add(new Equipment.fromJson(equipment));
    }
    return equipmentList;
  }
}