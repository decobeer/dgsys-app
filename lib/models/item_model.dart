class Item {
  int id;
  String label;
  bool rental_related;
  bool prizePerUnit;
  double price;

  Item({this.label, this.rental_related, this.prizePerUnit, this.price});

  static List<Item> fromJsonList(List<dynamic> jsonList){
    var result = List<Item>();
    for (var item in jsonList){
      result.add(Item.fromJson(item));
    }
    return result;
  }

  Item.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.label = json['label'];
    this.rental_related = json['rental_related'];
    this.prizePerUnit = json['price_per_unit'];
    this.price = json['price'];
  }
}