import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tipot/models/products_model.dart';
import 'package:tipot/models/purchases_model.dart';

class Purchase extends StatelessWidget {
  final PurchaseModel purchase;

  const Purchase({Key? key, required this.purchase}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1.0,
        ),
      ),
      child: ListTile(
        leading: const SizedBox(
          width: 50,
          height: 50,
          child: Icon(Icons.shopping_bag),
        ),
        title: Text(purchase.productName!),
        subtitle: Text(
          'Units Purchases: \$${purchase.units} - \nUnits Cost: ${purchase.unitPurchasePrice} - \nSupplier: ${purchase.supplier}',
        ),
      ),
    );
  }
}
