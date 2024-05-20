import 'package:flutter/material.dart';
import 'package:tipot/models/ledgers_model.dart';

class Ledger extends StatelessWidget {
  final LedgerModel ledger;

  const Ledger({Key? key, required this.ledger}) : super(key: key);

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
        title: Text(ledger.partnerName),
        subtitle: Text(
          'Created Time: \$${ledger.createdTime} - \nAmount Cost: ${ledger.amount} - \nRecord Type: ${ledger.recordType}',
        ),
      ),
    );
  }
}
