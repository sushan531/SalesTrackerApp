import 'package:flutter/material.dart';
import 'package:tipot/models/products_model.dart';
import 'package:tipot/models/sales_model.dart';

class Sale extends StatelessWidget {
  final SalesModel sale;

  const Sale({Key? key, required this.sale}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access properties using dot notation (assuming Product class)
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
        leading: const Icon(Icons.shopping_bag),
        title: Text(sale.productName),
        subtitle: Text(
          'Sold Date: ${sale.soldDate} - \nSold Price: \$${sale.salesPrice} - \nProfit: \$${sale.profit}',
        ),
        trailing: TextButton.icon(
          icon: const Icon(Icons.add),
          onPressed: () {},
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              textStyle: const TextStyle(color: Colors.greenAccent),
              backgroundColor: Colors.white),
          label: const Text("Add Sales"),
        ),
      ),
    );
  }
}
