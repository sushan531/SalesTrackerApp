import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tipot/models/products_model.dart';
import 'package:tipot/screens/private/purchases/purchases_add.dart';
import 'package:tipot/screens/private/purchases/purchases_list.dart';
import 'package:tipot/screens/private/tipot_drawer/tipot_drawer.dart';


class PurchasesScreen extends StatefulWidget {
  const PurchasesScreen({super.key});

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  State<PurchasesScreen> createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> {
  List<ProductModel> products = [];
  int _page = 2;

  @override
  void initState() {
    super.initState();
  }

  Widget getActivePage(int page) {
    switch (page) {
      case 0:
        return Center(
          child: Text(
            "Dashboard Page\n$_page",
            style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
          ),
        );
      case 1:
        return const PurchasesAdd();
      case 2:
        return const PurchaseListPage();
      default:
        throw Exception('Invalid ActiveScreen value');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:const TipotDrawer(),
      appBar: AppBar(
        title: const Text('Purchases',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: getActivePage(_page),
      bottomNavigationBar: CurvedNavigationBar(
        height: 60,
        backgroundColor: Colors.white,
        buttonBackgroundColor: Colors.greenAccent,
        color: Colors.green,
        animationDuration: const Duration(milliseconds: 200),
        items: const [
          Icon(Icons.dashboard_rounded, size: 25, color: Colors.white),
          Icon(Icons.add, size: 25, color: Colors.white),
          Icon(Icons.shopping_bag, size: 25, color: Colors.white),
        ],
        index: _page,
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
    );
  }
}
