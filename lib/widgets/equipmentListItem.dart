
import 'package:dgsys_app/models/equipment_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EquipmentListItem extends StatelessWidget{
  final VoidCallback onPressed;
  Equipment item;
  bool isSelected;
  bool selectableOnReserved;

  EquipmentListItem({this.onPressed, this.item, this.isSelected=false, this.selectableOnReserved = false});

  @override
  Widget build(BuildContext context) {
    Color background = selectBacground();
    IconData selectedIcon = selectIcon();
    Text statusLabel = selectStatusLabel();
    Text statusText = selectStatusText();
    
    return GestureDetector(
        onTap: this.onPressed,
        child: Container(
          color: background,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(selectedIcon, size: 32,),
                  Text(item.label),
                ],
              ),
              Text(item.description),
              Column(
                children: <Widget>[
                  statusLabel,
                  statusText
                ],
              )
            ],
          ),
        )
    );
  }

  IconData selectIcon(){
    if (this.isSelected){
      return Icons.check_box;
    }
    else if(item.isAvailable(includeReservation: ! selectableOnReserved)){
      return Icons.check_box_outline_blank;
    }
    else{
      return Icons.close;
    }
  }

  Color selectBacground(){
    if(item.isAvailable(includeReservation: ! selectableOnReserved)){
      return item.isReserved ? Colors.yellowAccent :
          this.isSelected ? Colors.lightBlueAccent : Colors.white;
    } else{
      return Colors.redAccent;
    }
  }

  Text selectStatusLabel(){
    if(item.isAvailable(includeReservation: ! selectableOnReserved)){
      return item.isReserved ?
        Text("Reserved by: ") : Text("Status: ");
    }
    else{
      return Text("Occupied by: ");
    }
  }

  Text selectStatusText(){
    if(item.isReserved || item.isRented){
      return Text(item.occupants);
    }
    else{
      return Text("Available", style: TextStyle(color: Colors.green),);
    }
  }
}
  
class EquipmentList extends StatelessWidget{
  List<Equipment> equipmentArticles;
  List<Equipment> selectedItems; 
  Function onItemPressed;
  bool selectableOnReserved;
  
  EquipmentList({
    @required this.equipmentArticles,
    @required this.selectedItems,
    @required this.onItemPressed,
    @required this.selectableOnReserved
  });
  
  @override
  Widget build(BuildContext context) {
    var content = List<Widget>();

    equipmentArticles.sort((a, b) => b.availabilityScore() - a.availabilityScore());
    List<String> categories = equipmentArticles.map((e) => e.category).toSet().toList();

    for (String category in categories){
      content.add(
          ExpansionTile(
              title: Text(category),
              children: equipmentArticles
                  .where((e) => e.category == category)
                  .map((e) =>
                  EquipmentListItem(
                    item: e,
                    onPressed: (){onItemPressed(e, context);},
                    isSelected: selectedItems.contains(e),
                    selectableOnReserved: this.selectableOnReserved,
                  )
              ).toList()
          )
      );
    }

    return  Column(
        children: content,
      );
  }
}
