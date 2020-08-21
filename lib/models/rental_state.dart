

import 'dart:convert';

import 'package:dgsys_app/api/api_service.dart';
import 'package:dgsys_app/api/equipment_service.dart';
import 'package:dgsys_app/api/rental_service.dart';
import 'package:dgsys_app/models/equipment_model.dart';
import 'package:dgsys_app/models/rental_model.dart';
import 'package:dgsys_app/models/reservation_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RentalState extends ChangeNotifier{
  List<String> eqCategories;
  List<Equipment> equipmentArticles;
  List<Rental> openRentals;
  List<Rental> closedRentals;
  Rental workingRental;
  bool hasLoaded;
  String errorMessage;

  void initialize() async {
    this.hasLoaded = false;
    this.workingRental = Rental.workingRental();
  }

  RentalState({loadOpenRentals = false}){
    this.workingRental = Rental.workingRental();
    if(loadOpenRentals){
      this.getOpenRentals();
    }
  }

  void getOpenRentals()async{
    this.hasLoaded = false;
    notifyListeners();
    this.openRentals = await RentalService.getOpenRentals();
    this.hasLoaded = true;
    notifyListeners();
  }

  void resetRental(){
    this.workingRental = Rental();
    notifyListeners();
  }

  void refresh(){
    this.getOpenRentals();
    this.loadIfReady();
  }

  void setEstimatedReturn(DateTime selectedDate) {
    DateTime adjustedTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      23,
      59,
      59,
    );
    this.workingRental.estimatedEndTime = adjustedTime;
    this.loadIfReady();
  }

  Future<void> loadIfReady() async {
    this.hasLoaded = false;
    this.equipmentArticles =
        await EquipmentService.getEquipment(
        from: this.workingRental.startTime,
        to: this.workingRental.estimatedEndTime);

    this.hasLoaded = true;
    notifyListeners();
  }

  void removeEquipment(Equipment e) {
    this.workingRental.equipment.remove(e);
    notifyListeners();
  }

  void addEquipment(Equipment e) {
    if (e.isAvailable(includeReservation: false)){
      this.workingRental.equipment.add(e);
      notifyListeners();
    }
  }

  Future<bool> submitRental() async {
    ApiService apiService = ApiService();
    String parsedStartDate = apiService.formatDate(workingRental.startTime);
    String parsedEndDate = apiService.formatDate(workingRental.estimatedEndTime);
    List<int> equipmentIds = workingRental.equipment.map((e) => e.id).toList();

    Map<String, dynamic> data = {
      "equipment_articles": equipmentIds,
      "start_date": parsedStartDate,
      "estimated_end": parsedEndDate
    };

    final response = await apiService.apiPost('rental/', data);

    if (apiService.isSuccess(response.statusCode)) {
      this.resetRental();
      return true;
    }
    else{
      this.errorMessage = json.decode(response.body)['error'];
      this.workingRental = Rental();
      notifyListeners();
      return false;
    }
  }
}
