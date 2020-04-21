import 'dart:convert';

import 'package:dgsys_app/api/api_service.dart';
import 'package:dgsys_app/models/equipment_model.dart';

class EquipmentService {
  static Future<List<Equipment>> getEquipment() async {
    final response = await ApiService().get('equipment');
    var parsedRespose = json.decode(response.body);
    print(parsedRespose);
    var rawEquipmentList = parsedRespose['data'];
    var equipmentList = List<Equipment>();
    for(var equipment in rawEquipmentList){
      equipmentList.add(new Equipment.fromJson(equipment));
    }
    return equipmentList;
  }

  static Future<Map<String, Map<String, List<Equipment>>>>
  getEquipmentByCategoryAndAvaiability(DateTime from, DateTime to) async {

    ApiService apiService = ApiService();
    String formattedFromDate = apiService.formatDate(from);
    String formattedToDate = apiService.formatDate(to);
    final response = await apiService.get(
        'equipment',
        {'from': formattedFromDate,
          'to': formattedToDate});
    var parsedResponse = json.decode(response.body)['data'];

    var result = Map<String, Map<String, List<Equipment>>>();

    if(parsedResponse['available'] != null && parsedResponse['occupied'] != null){
      for (var unparsedEquipment in parsedResponse['available']){
        Equipment equipment = Equipment.fromJson(unparsedEquipment);
        equipment.available = true;

        if(result.containsKey(equipment.category)){
          result[equipment.category]['available'].add(equipment);
        }
        else {
          result[equipment.category] = {
            'available': List<Equipment>(),
            'occupied': List<Equipment>()
          };
          result[equipment.category]['available'].add(equipment);
        }
      }

      for (var unparsedEquipment in parsedResponse['occupied']){
        Equipment equipment = Equipment.fromJson(unparsedEquipment);
        equipment.available = false;

        if(result.containsKey(equipment.category)){
          result[equipment.category]['occupied'].add(equipment);
        }
        else {
          result[equipment.category] = {
            'available': List<Equipment>(),
            'occupied': List<Equipment>()
          };
          result[equipment.category]['occupied'].add(equipment);
        }
      }
      return result;
    }

    else {
      return null;
    }

  }
}