import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tipot/models/ledgers_model.dart';
import 'package:tipot/screens/private/ledgers/ledgers_add.dart';
import 'package:tipot/screens/private/ledgers/ledgers_list.dart';
import 'package:tipot/screens/private/tipot_drawer/tipot_drawer.dart';

class LedgersScreen extends StatefulWidget {
  const LedgersScreen({super.key});

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  State<LedgersScreen> createState() => _LedgersScreenState();
}

class _LedgersScreenState extends State<LedgersScreen> {
  List<LedgerModel> ledgers = [];
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
        return const LedgersAdd();
      case 2:
        return const LedgerListPage();
      default:
        throw Exception('Invalid ActiveScreen value');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const TipotDrawer(),
      appBar: AppBar(
        title: const Text('Ledgers',
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
