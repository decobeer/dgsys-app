import 'package:dgsys_app/models/item_model.dart';
import 'package:dgsys_app/models/purchase_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_input/flutter_input.dart';
import 'package:provider/provider.dart';

class ItemListView extends StatelessWidget {
  final bool rentalRelatedOnly;

  const ItemListView({Key key, this.rentalRelatedOnly}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var purchaseState = Provider.of<PurchaseState>(context);
    return ListView.builder(
      itemCount: purchaseState.items.length,
      itemBuilder: (BuildContext context, int index) {
        Item item = purchaseState.items[index];

        return ListTile(
            title: Text(item.label),
            trailing: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    border: Border.all(color: Colors.blueGrey)
                ),
              width: 80,
              child: InputKeyboard<int>(
                  validators: [(v) => min(v, 0, message: "Value cannot be negative")],
                  onSaved: (v) => purchaseState.updateItemQtty(item, v),
                )
            )
            );
      },
    );
  }

}