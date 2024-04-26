import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tipot/models/products_model.dart';

class Product extends StatelessWidget {
  final ProductModel product;

  const Product({Key? key, required this.product}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    Uint8List? decodedBytes;
    try {
      final decodedImage = product.productImage;
      decodedBytes = base64Decode(decodedImage as String);
    } catch (e) {
      product.productImage = null;
    }

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
        leading:  product.productImage == null
         ? const Icon(Icons.shopping_bag) :  Image.memory(decodedBytes!),
        title: Text(product.productName),
        subtitle: Text(
          'Selling Price: \$${product.sellingPrice} - \nQuantity: ${product.remainingQuantity} ${product.measurementUnit}',
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
