import 'dart:math';

import 'package:dgsys_app/models/rental_model.dart';
import 'package:dgsys_app/models/rental_state.dart';
import 'package:dgsys_app/rentals/return_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReturnScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RentalState(loadOpenRentals: true),
      child: ReturnBody(),
    );
  }
}

class ReturnBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RentalState rentalState = Provider.of<RentalState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Return Equipment"),
      ),
      body: rentalState.hasLoaded
          ? RentalListView(
              rentals: rentalState.openRentals,
              onPressed: (Rental r) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => ReturnDetails(rental: r)
                )).then((value) => rentalState.refresh());
              },
            )
          : CircularProgressIndicator(),
    );
  }
}

class RentalListView extends StatelessWidget {
  List<Rental> rentals;
  Function(Rental) onPressed;
  RentalListView({this.rentals, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: rentals.length,
      itemBuilder: (BuildContext context, int i) {
        Rental rental = rentals[i];
        return GestureDetector(
            onTap: () {
              onPressed(rental);
            },
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              height: 96,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text("Collected: "),
                          Text(this.collectedText(rental)),
                        ],
                      ),
                      rental.isFinished()
                          ? Text("kr. " + rental.price.toString())
                          : Text("Not returned")
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: rental.equipment.length > 0
                        ? getItems(rental)
                        : <Widget>[Text("None")],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.chevron_right,
                        size: 48,
                      )
                    ],
                  )
                ],
              ),
            ));
      },
      padding: EdgeInsets.all(8),
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  String collectedText(Rental rental) {
    Duration difference = DateTime.now().difference(rental.startTime);
    if (difference.inDays == 0) {
      return "Today";
    } else {
      return difference.inDays.toString() + " days ago";
    }
  }

  List<Widget> getItems(Rental rental) {
    var texts = List<Widget>();
    texts.add(Text(
      "Items: ",
      style: TextStyle(fontWeight: FontWeight.bold),
    ));
    for (int i = 0; i < min(2, rental.equipment.length); i++) {
      texts.add(Text(rental.equipment[i].label));
    }
    if (rental.equipment.length > 2) {
      texts.add(Text("..."));
    }
    return texts;
  }
}
