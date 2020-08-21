import 'package:dgsys_app/api/rental_service.dart';
import 'package:dgsys_app/items/item_screen.dart';
import 'package:dgsys_app/models/rental_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';

class ReturnDetails extends StatefulWidget{
  final Rental rental;

  const ReturnDetails({Key key, this.rental}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ReturnDetailsState(rental);
  }

}

class ReturnDetailsState extends State<ReturnDetails>{
  final Rental rental;

  ReturnDetailsState(this.rental);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Confirm return"),),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text("Collected: "),
                  Text(rental.startTime.toString())
                ],
              ),
              Column(
                children: <Widget>[
                  Text("Returned: "),
                  Text(DateTime.now().toString())
                ],
              )
            ],
          ),
          Expanded(
            child: ListView.builder(itemCount: rental.equipment.length,
                itemBuilder: (BuildContext context, int i){
                return Text(rental.equipment[i].label);
            }
            ),
          ),
          Text(
            "kr. " + rental.estimatePrice(DateTime.now()).toString(), style: TextStyle(fontWeight: FontWeight.bold),),
          ProgressButton(
            defaultWidget: Text("Return equipment"),
            progressWidget: CircularProgressIndicator(),
            onPressed: () async {
              try{
                rental.endTime = DateTime.now();
                Rental result = await RentalService.returnRental(rental);
                showDialog(context: context,
                barrierDismissible: false,
                builder: (context){
                  return AlertDialog(
                    title: Text("Success!"),
                    content: Row(
                      children: [
                        Icon(Icons.check, color: Colors.green,),
                        Text("Equipment is now returned. \n Final price: kr. " + result.price.toString())
                      ],
                    ),
                    actions: [
                      FlatButton(
                          child: Text('Ok'),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.popAndPushNamed(context, '/itemPurchase', arguments: PurchaseScreenArgs(rentalRelatedOnly: true));
                          }
                      )
                    ],
                  );
                });
              } catch (e){
                showDialog(context: context,
                    builder: (context){
                      return AlertDialog(
                        title: Text("Failed!"),
                        content: Row(
                          children: [
                            Icon(Icons.close, color: Colors.red,),
                            Text("Please contact someone")
                          ],
                        ),
                        actions: [
                          FlatButton(
                              child: Text('Ok'),
                              onPressed: () {
                                Navigator.popUntil(context, ModalRoute.withName('/'));
                              }
                          )
                        ],
                      );
                    });
              }
            },
          ),
        ],
      ),
    );
  }


}