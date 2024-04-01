import 'package:flutter/material.dart';
import 'package:tipot/models/products_model.dart';

class ProductList extends StatelessWidget {
  final List<ProductModel> products;

  const ProductList({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];

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
            title: Text(product.productName),
            subtitle: Text(
              'Selling Price: \$${product.sellingPrice} - \nQuantity: ${product.remainingQuantity} ${product.measurementUnit}',
            ),
            trailing: TextButton.icon(
              icon: const Icon(Icons.add),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  textStyle: const TextStyle(color: Colors.greenAccent),
                  backgroundColor: Colors.white),
              label: const Text("Add Sales"),
            ),
          ),
        );
      },
    );
  }
}
