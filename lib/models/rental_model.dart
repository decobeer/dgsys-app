
import 'equipment_model.dart';

class Rental{
  int id;
  List<Equipment> equipment;
  DateTime startTime;
  DateTime endTime;
  DateTime estimatedEndTime;
  double price;

  Rental.workingRental(){
    this.equipment = List<Equipment>();
    this.startTime = DateTime.now();
  }

  Rental({
    this.equipment,
    this.startTime,
  });

  Rental.fromJson(Map<String, dynamic> json) {
    /*
            "id": 4,
            "start_date": "2020-10-10T18:39:00Z",
            "end_date": null,
            "estimated_end": "2020-12-14T00:01:00Z",
            "amount": 0.0,
            "user": 2,
            "equipment_articles": [
                ...
            ]
     */
    var a = json['equipment_articles'];
    var b = json['amount'];

    this.id = json['id'];
    this.startTime = DateTime.parse(json['start_date']);
    this.endTime = this.endTime == null ? null : DateTime.parse(json['end_date']);
    this.estimatedEndTime = DateTime.parse(json['estimated_end']);
    this.price = json['amount'];
    this.equipment = Equipment.fromJsonList(json['equipment_articles']);
  }

  bool isFinished(){
    return this.endTime != null;
  }

  double estimatePrice(DateTime endTime){
    double pricePerDay = equipment.fold(0, (previousValue, equipment) => previousValue + equipment.price);
    int duration = 1 + endTime.difference(this.startTime).inDays;
    return pricePerDay * duration;
  }
}