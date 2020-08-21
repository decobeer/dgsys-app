import 'package:dgsys_app/models/purchase_state.dart';
import 'package:dgsys_app/widgets/itemListView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:provider/provider.dart';

class PurchaseScreenArgs {
    bool rentalRelatedOnly;
    PurchaseScreenArgs({this.rentalRelatedOnly});
}

class PurchaseScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final PurchaseScreenArgs args = ModalRoute.of(context).settings.arguments;
    bool rentalRelatedOnly = args.rentalRelatedOnly;

    return ChangeNotifierProvider(
      create: (context) => PurchaseState(rentalRelatedOnly),
      child: PurchaseBody(),
    );
  }


}

class PurchaseBody extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    var purchaseState = Provider.of<PurchaseState>(context);
    return Scaffold(
      appBar: AppBar(
        title: purchaseState.rentalRelatedOnly ?
            Text("Gas fills after rental?") :
            Text("Purchases")
      ),
      body: SafeArea(
      child:
          purchaseState.hasLoaded ?
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                        child:ItemListView()
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total: " + purchaseState.totalPrice().toString()),
                      RaisedButton(
                        child: Text("Done"),
                          onPressed: () => this.onSubmit(context)
                          )
                      /* ProgressButton(
                          defaultWidget: Text("Done"),
                          progressWidget: CircularProgressIndicator(),
                          onPressed: () async {
                            bool success = await purchaseState.submit();
                            showDialog(context: context, builder: (context){
                              return AlertDialog(
                                title: success ? Text("Thanks bro") : Text("Purchase failed"),
                                actions: [
                                  FlatButton(
                                      onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/')),
                                      child: Text("OK"))
                                ],
                              );
                            });
                            },
                      )*/
                    ])]
              )
             :
            CircularProgressIndicator()
      )
    );
  }

  onSubmit(BuildContext context) async {
    var purchaseState = Provider.of<PurchaseState>(context, listen: false);

    bool success = await purchaseState.submit();

    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: success ? Text("Thanks bro") : Text("Purchase failed"),
        actions: [
          FlatButton(
              onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/')),
              child: Text("OK"))
        ],
      );
    });
  }

}