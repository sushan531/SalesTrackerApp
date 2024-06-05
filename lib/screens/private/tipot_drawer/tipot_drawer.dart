import 'package:flutter/material.dart';
import 'package:tipot/screens/private/branches/branches.dart';
import 'package:tipot/screens/private/paymentReceipt/paymentReceipt.dart';
import 'package:tipot/screens/private/partners/partners.dart';
import 'package:tipot/screens/private/products/products.dart';
import 'package:tipot/screens/private/purchases/purchases.dart';
import 'package:tipot/screens/private/sales/sales.dart';

class HeaderDrawer extends StatefulWidget {
  const HeaderDrawer({super.key});

  @override
  State<HeaderDrawer> createState() => _HeaderDrawerState();
}

class _HeaderDrawerState extends State<HeaderDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[700],
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 70,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage("image/user.png"),
              ),
            ),
          ),
          Text(
            "User Email!",
            style: TextStyle(color: Colors.white, fontSize: 30),
          )
        ],
      ),
    );
  }
}

class DrawerList extends StatefulWidget {
  const DrawerList({super.key});

  @override
  State<DrawerList> createState() => _DrawerListState();
}

class _DrawerListState extends State<DrawerList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        ListTile(
          leading: const Icon(Icons.account_tree),
          title: const Text("Branches"),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const BranchesScreen()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.shopping_bag),
          title: const Text("Products"),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const ProductsScreen()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.input_outlined),
          title: const Text("Purchases"),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const PurchasesScreen()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.add_shopping_cart),
          title: const Text("Sales"),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const SalesScreen()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.person_outline_outlined),
          title: const Text("Partners"),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const PartnersScreen()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.account_balance_sharp),
          title: const Text("PaymentReceipt"),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const PaymentReceiptScreen()));
          },
        ),
      ],
    );
  }
}

class TipotDrawer extends StatefulWidget {
  const TipotDrawer({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TipotDrawerState();
  }
}

class _TipotDrawerState extends State<TipotDrawer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: const Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeaderDrawer(),
              DrawerList(),
            ],
          ),
        ),
      ),
    );
  }
}
