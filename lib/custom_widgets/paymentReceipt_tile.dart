import 'package:flutter/material.dart';
import 'package:tipot/models/paymentReceipt_model.dart';

class PaymentReceipt extends StatelessWidget {
  final PaymentReceiptModel paymentReceipt;

  const PaymentReceipt({Key? key, required this.paymentReceipt}) : super(key: key);

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
        title: Text(paymentReceipt.partnerName),
        subtitle: Text(
          'Created Time: \$${paymentReceipt.createdTime} - \nAmount Cost: ${paymentReceipt.amount} - \nRecord Type: ${paymentReceipt.recordType}',
        ),
      ),
    );
  }
}
