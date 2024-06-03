import 'package:flutter/material.dart';
import 'package:tipot/models/ledgers_model.dart';
import 'package:tipot/models/partners_model.dart';

class Partner extends StatelessWidget {
  final PartnerModel partner;

  const Partner({Key? key, required this.partner}) : super(key: key);

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
        title: Text(partner.partnerName),
        subtitle: Text(
          'Partner Name: ${partner.partnerName} - \nEmail: ${partner.email} - \nContact: ${partner.contactNumber}',
        ),
      ),
    );
  }
}
