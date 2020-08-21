import 'dart:convert';

import 'package:dgsys_app/api/api_service.dart';
import 'package:dgsys_app/api/equipment_service.dart';
import 'package:dgsys_app/models/equipment_model.dart';
import 'package:flutter/cupertino.dart';

class ReservationState extends ChangeNotifier{
  List<String> eqCategories;
  List<Equipment> equipmentArticles;
  Reservation workingReservation;
  bool hasLoaded;
  String error_message;

  ReservationState(){
    this.workingReservation = Reservation();
    this.initialize();
  }

  void initialize(){
    this.hasLoaded = true;
    this.hasLoaded = false;
  }

  void setWorkingReservationStartDate(DateTime time){
    this.workingReservation.startTime = time;
    this.loadIfReady();
    notifyListeners();
  }

  void setWorkingReservationEndDate(DateTime time){
    DateTime adjustedTime = DateTime(
      time.year,
      time.month,
      time.day,
      23,
      59,
      59,
    );
    this.workingReservation.endTime = adjustedTime;
    this.loadIfReady();
    notifyListeners();
  }

  void addEquipment(Equipment equipment){
    this.workingReservation.selectedEquipment.add(equipment);
    notifyListeners();
  }

  void removeEquipment(Equipment equipment){
    this.workingReservation.selectedEquipment.remove(equipment);
    notifyListeners();
  }

  bool hasDates(){
    return this.workingReservation.startTime != null
        && this.workingReservation.endTime != null;
  }

  Future<bool> submitReservation() async {
    ApiService apiService = ApiService();
    String parsedStartDate = apiService.formatDate(workingReservation.startTime);
    String parsedEndDate = apiService.formatDate(workingReservation.endTime);
    List<int> equipmentIds = workingReservation.selectedEquipment.map((e) => e.id).toList();

    Map<String, dynamic> data = {
      "equipment_articles": equipmentIds,
      "start_date": parsedStartDate,
      "end_date": parsedEndDate
    }; 
    
    final response = await apiService.apiPost('reservation/', data);


    if (apiService.isSuccess(response.statusCode)) {
      this.workingReservation = Reservation();
      notifyListeners();
      return true;
    }
    else{
       this.error_message = json.decode(response.body)['error'];
       this.workingReservation = Reservation();
       notifyListeners();
       return false;
    }
  }

  String getStartDateFormatted(){
    return this.workingReservation.startTime == null ?
    "Start date" :
    workingReservation.startTime.toString();
  }

  String getEndDateFormatted(){
    return this.workingReservation.endTime == null ?
    "End date" :
    workingReservation.endTime.toString();
  }

  void setStartTime(DateTime time){
   this.workingReservation.startTime =  time;
   this.loadIfReady();
  }

  void loadIfReady(){
    if (this.hasDates()){
      this.loadEquipment();
    }
  }

  void loadEquipment() async {
    this.hasLoaded = false;
    this.equipmentArticles =
        await EquipmentService.getEquipment(
          from: this.workingReservation.startTime,
          to: this.workingReservation.endTime);

    this.hasLoaded = true;
    notifyListeners();
  }
}

class Reservation{
  List<Equipment> selectedEquipment;
  DateTime startTime;
  DateTime endTime;

  Reservation(){
    this.selectedEquipment = List<Equipment>();
  }
}