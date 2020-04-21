import 'package:dgsys_app/models/equipment_model.dart';
import 'package:dgsys_app/models/reservation_state.dart';
import 'package:dgsys_app/widgets/equipmentListItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:provider/provider.dart';

class ReservationScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ReservationState(),
      child:
        ReservationBody()
    );
  }
}

class ReservationBody extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var reservation = Provider.of<ReservationState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Reservation"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children:
              buildContent(context)
            ),
          ProgressButton(
            defaultWidget: Text("Submit reservation"),
            progressWidget: CircularProgressIndicator(),
            onPressed: () async {
              await this.submitReservation(context);
            },
          )
        ]
      ),
    );
  }

  Future<bool> submitReservation(BuildContext context) async {
    ReservationState reservation = Provider.of<ReservationState>(context, listen: false);
    bool success = await reservation.submitReservation();

    if (success){
      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text("Reservation made"),
              content: Row(
                children: <Widget>[
                  Icon(Icons.check, color: Colors.green, size: 48,),
                  Text("Reservation successfully done. ")
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                   }
                )]
            );
          }
      );
      return true;
    }
    else {
      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context){
            return AlertDialog(
                title: Text("Error making reservation"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("Error occured while submitting reservation."),
                    Text("Message: " + reservation.error_message)
                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      reservation.loadIfReady();
                      Navigator.pop(context);
                    },
                  ),]
            );
          }
      );
      return false;
    }
  }

  List<Widget> buildContent(context){
    var reservation = Provider.of<ReservationState>(context);

    var content =  <Widget>[
      Row(
        children: <Widget>[
          Text("From date: "),
          OutlineButton(
            child: Text(
                reservation.getStartDateFormatted()
            ),
            onPressed: () async {
              DateTime selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2018),
                lastDate: DateTime(2030),
                builder: (BuildContext context, Widget child) {
                  return Theme(
                    data: ThemeData.dark(),
                    child: child,
                  );
                },
              );
              reservation.setWorkingReservationStartDate(selectedDate);
            },
          ),
        ],
      ),
      Row(
        children: <Widget>[
          Text("To date: "),
          OutlineButton(
            child: Text(
                reservation.getEndDateFormatted()
            ),
            onPressed: () async {
              DateTime selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2018),
                lastDate: DateTime(2030),
                builder: (BuildContext context, Widget child) {
                  return Theme(
                    data: ThemeData.dark(),
                    child: child,
                  );
                },
              );
              reservation.setWorkingReservationEndDate(selectedDate);
            },
          ),
        ],
      )
    ];

    if(reservation.sortedEquipment != null && reservation.hasLoaded){
      for (String mapKey in reservation.sortedEquipment.keys){
        var articles = List<Equipment>();
        if(reservation.sortedEquipment[mapKey]['available'] != null){
          articles.addAll(reservation.sortedEquipment[mapKey]['available']);
        }
        if(reservation.sortedEquipment[mapKey]['occupied'] != null) {
          articles.addAll(reservation.sortedEquipment[mapKey]['occupied']);
        }
        content.add(
          ExpansionTile(
              title: Text(mapKey),
              children: articles.map((e) =>
                  EquipmentListItem(
                    item: e,
                    onPressed: (){toggleSelection(e, context);},
                    isSelected: reservation.workingReservation.selectedEquipment.contains(e),
                    selectableOnOccupied: false,
                  )
              ).toList()
          )
        );
      } //
    }

    return content;
  }

  void toggleSelection(Equipment e, BuildContext ctx){
    ReservationState reservation = Provider.of<ReservationState>(ctx, listen: false);
    if (reservation.workingReservation.selectedEquipment.contains(e)){
      reservation.removeEquipment(e);
    }
    else if(e.available){
      reservation.addEquipment(e);
    }
  }
}