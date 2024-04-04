import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:tipot/custom_widgets/products_tile.dart';
import 'package:tipot/models/products_model.dart';
import 'package:tipot/rest_api/rest_api.dart';
import 'package:tipot/screens/private/products/products_add.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen(this.storage, {super.key});

  final FlutterSecureStorage storage;

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<ProductModel> products = [];
  var nextToken = "";
  var activeBranch = "";
  var accessToken = "";
  int limit = 7;
  int _page = 2;

  @override
  void initState() {
    super.initState();
    _fetchData(true);
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
        return ProductsAdd();
      case 2:
        return SmartRefresher(
          controller: _refreshController,
          enablePullDown: false,
          enablePullUp: true,
          onRefresh: () async {
            final status = await _fetchData(true);
            if (status) {
              _refreshController.refreshCompleted();
            } else {
              _refreshController.refreshFailed();
            }
          },
          onLoading: () async {
            final status = await _fetchData(false);
            if (status) {
              _refreshController.loadComplete();
            } else {
              _refreshController.loadNoData();
            }
          },
          child: products.isEmpty
              ? const Center(child: Text("No Products"))
              : ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Product(product: product);
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: products.length),
        );
      default:
        throw Exception('Invalid ActiveScreen value');
    }
  }

  Future<bool> _fetchData(bool? refresh) async {
    if (refresh == true) {
      products.clear();
      nextToken = "";
    } else {
      nextToken = await widget.storage.read(key: "next_token") ?? "";
    }
    accessToken = await widget.storage.read(key: "access_token") ?? "";
    activeBranch = await widget.storage.read(key: "active_branch_uuid") ?? "";
    var dio = Dio();
    var headers = {
      'Cache-Control': 'true',
      'Authorization': 'Bearer $accessToken',
    };
    try {
      var uri =
          '${ApiEndpoints.baseurl}/api/product/list?bid=$activeBranch&limit=$limit&token=$nextToken';
      var response = await dio.request(
        uri,
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );
      dio.close();
      if (response.statusCode == 200) {
        var records = response.data["data"] as List;
        _refreshController.loadComplete();
        if (records.isEmpty) {
          return true;
        }
        widget.storage
            .write(key: "next_token", value: response.data["next_token"]);
        List<ProductModel> _products =
            records.map((record) => ProductModel.fromJson(record)).toList();
        products.addAll(_products);
        setState(() {});
        return true;
      } else {
        // Handle error scenario
        print("Error fetching data: ${response.statusCode}");
        return false;
      }
    } catch (error) {
      // Handle network or other exceptions
      print("Error fetching data: $error");
      return false;
    } finally {
      dio.close();
    }
  }

  final RefreshController _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products',
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
          Icon(Icons.list_alt, size: 25, color: Colors.white),
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
