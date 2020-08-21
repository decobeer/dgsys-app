import 'dart:convert';

class Equipment{
  int id;
  String category;
  String label;
  String description;
  double price;
  String occupants;
  bool isReserved;
  bool isRented;

  Equipment({
    this.id,
    this.category,
    this.label,
    this.description,
    this.price,
    this.isRented = false,
  this.isReserved = false});

  static List<Equipment> fromJsonList(List<dynamic> jsonList){

    var result = List<Equipment>();
    for (var item in jsonList){
      result.add(Equipment.fromJson(item));
    }
    return result;
  }

  Equipment.fromJson(Map<String, dynamic> json){
      this.id =  json['id'];
      this.category =  json['category'];
      this.label =  json['label'];
      this.description = json['description'];
      this.price = json['price'];
      this.occupants = json['occupants'];
      this.isRented = json['is_rented'];
      this.isReserved = json['is_reserved'];
  }

  bool isAvailable({bool includeReservation = true}){
    if (this.isRented) return false;
    if (this.isReserved) return includeReservation ? false : true;
    return true;
  }

  int availabilityScore(){
    // Score: Rented (reserved or not) = 0, Reserved (not rented) = 1, available = 2
    if(this.isRented) return 0;
    if(this.isReserved) return 1;
    return 2;
  }
}

class EquipmentCategory{
  String label;
  int id;
}
