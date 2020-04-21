class Equipment{
  int id;
  String category;
  String label;
  String description;
  double price;
  bool available;
  String occupants;

  Equipment({
    this.id,
    this.category,
    this.label,
    this.description,
    this.price,
    this.available = true});

  Equipment.fromJson(Map<String, dynamic> json){
      this.id =  json['id'];
      this.category =  json['category'];
      this.label =  json['label'];
      this.description = json['description'];
      this.price = json['price'];
      this.occupants = json['occupants'];
      this.available = json['isAvailable'] != null ? json['isAvailable'] : true;
  }
}

class EquipmentCategory{
  String label;
  int id;
}
