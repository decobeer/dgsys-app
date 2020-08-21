
import 'package:dgsys_app/models/equipment_model.dart';
import 'package:dgsys_app/models/rental_state.dart';
import 'package:dgsys_app/util/string_formatter.dart';
import 'package:dgsys_app/widgets/equipmentListItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:provider/provider.dart';

class CollectionScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RentalState(),
      child:
        CollectionBody(),
    );
  }
}

class CollectionBody extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    RentalState rentalState = Provider.of<RentalState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Collect equipment"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: buildContent(context),
          ),
          ProgressButton(
            defaultWidget: Text("Collect equipment"),
            progressWidget: CircularProgressIndicator(),
            onPressed: () async {
                await this.submitRental(context);
            },
          )
        ],

      ),
    );
  }

  List<Widget> buildContent(BuildContext context){
    var rentalState = Provider.of<RentalState>(context);
    var content =  <Widget>[
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text("Time collected: "),
              OutlineButton(
                child: Text(
                  uiDateFormat(rentalState.workingRental.startTime, defaultString: "Start"),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text("Excpted return date: "),
              OutlineButton(
                child: Text(
                    uiDateFormat(rentalState.workingRental.estimatedEndTime)
                ),
                onPressed: () async {
                  DateTime selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2069),
                    builder: (BuildContext context, Widget child) {
                      return Theme(
                        data: ThemeData.dark(),
                        child: child,
                      );
                    },
                  );
                  rentalState.setEstimatedReturn(selectedDate);
                },
              ),
            ],
          )
        ],
      )
    ];

    if(rentalState.equipmentArticles != null && rentalState.hasLoaded){
      content.add(EquipmentList(
        equipmentArticles: rentalState.equipmentArticles,
        selectedItems: rentalState.workingRental.equipment,
        onItemPressed: this.toggleSelection,
        selectableOnReserved: true,
      ));
    }



    return content;
  }

  void toggleSelection(Equipment e, BuildContext context) {
    var rentalState = Provider.of<RentalState>(context, listen: false);
    if (rentalState.workingRental.equipment.contains(e)){
      rentalState.removeEquipment(e);
    }
    else if(e.isAvailable(includeReservation: false)){
      rentalState.addEquipment(e);
    }
  }

  Future<bool> confirmSubmit(BuildContext context) async {
    bool confirmed = false;
    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Collect this equipment?"),
            content:
            Container(
              child: Text("Once collected, you cannot change the items you´re renting."),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Ok"),
                onPressed: (){
                  confirmed = true;
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Cancel"),
                onPressed: (){},
              )
            ],
          );
        }
    );
    return confirmed;
  }

  submitRental(BuildContext context) async {
    RentalState rentalState = Provider.of<RentalState>(context, listen: false);
    bool success = await rentalState.submitRental();

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
    }
    else{
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
                    Text("Message: " + rentalState.errorMessage)
                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      rentalState.loadIfReady();
                      Navigator.pop(context);
                    },
                  ),]
            );
          }
      );
    }
  }
}