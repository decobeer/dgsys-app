import 'dart:convert';

import 'package:dgsys_app/api/api_service.dart';
import 'package:dgsys_app/models/item_model.dart';
import 'package:flutter/material.dart';

class PurchaseState extends ChangeNotifier{
  bool hasLoaded;
  final bool rentalRelatedOnly;
  List<Item> items;
  Map<Item, int> purchases;
  String errorMessage;

  PurchaseState(this.rentalRelatedOnly){
    this.hasLoaded = false;
    this.purchases = Map();
    loadItems();
  }

  bool itemIsSelected(Item item){
    return purchases.containsKey(item);
  }

  int quantityOfItem(Item item){
    return purchases.containsKey(item) ?
        purchases[item] : 0;
  }

  updateItemQtty(Item item, quantity){
      if(quantity > 0){
        purchases[item] = quantity;
      }
      else {
        purchases.remove(item);
      }
  }

  toggleNonQttyItem(Item item){
    if (purchases.containsKey(item)){
      purchases.remove(item);
    }
    else {
      purchases[item] = 1;
    }
  }

  loadItems() async {
    ApiService apiService = ApiService(); 
    final decodedResponse = await apiService.get('items/').then((response) => json.decode(response.body)['data']);
    this.items = Item.fromJsonList(decodedResponse);

    if(this.rentalRelatedOnly){
      this.items = items.where((item) => item.rental_related).toList();
      this.hasLoaded = true;
    }
    else {
      this.items = items;
      this.hasLoaded = true;
    }

    notifyListeners();
  }

  totalPrice() {
    double total = 0;
    purchases.forEach((item, quantity) {
      total += item.price * quantity;
    });
    return total;
  }

  Future<bool> submit() async {
    ApiService apiService = ApiService();

    List<Map<String, dynamic>> apiPurchases = List();
    purchases.forEach((item, quantity) {
      apiPurchases.add({
        'item': item.id,
        'quantity': quantity,
      });
    });

    final response = await apiService.apiPost('purchase/', {
      'data': apiPurchases
    });

    return apiService.isSuccess(response.statusCode);
  }
}