
import 'package:dgsys_app/models/equipment_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EquipmentListItem extends StatelessWidget{
  final VoidCallback onPressed;
  Equipment item;
  bool isSelected;
  bool selectableOnOccupied;

  EquipmentListItem({this.onPressed, this.item, this.isSelected=false, this.selectableOnOccupied = false});

  @override
  Widget build(BuildContext context) {

    IconData selectedIcon = isSelected ?
        Icons.check_box : item.available ?
          Icons.check_box_outline_blank :
            selectableOnOccupied ?
                Icons.check_box_outline_blank : Icons.close;

    Color background = item.available ?
    isSelected ? Colors.lightBlueAccent : Colors.white
        : Color.fromRGBO(255, 105, 97, 1);

    Text statusLabel = item.available ?
    Text("Status: ") : Text("Occupied by: ");

    Text statusText = item.available ?
    Text("Avaiable", style: TextStyle(color: Colors.green),) :
    Text(item.occupants, style: TextStyle(color: Colors.black),);

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
  }}