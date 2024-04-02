import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:tipot/custom_widgets/products_tile.dart';
import 'package:tipot/models/products_model.dart';
import 'package:tipot/rest_api/rest_api.dart';

class BlankPage extends StatefulWidget {
  const BlankPage(this.storage, {super.key});

  final FlutterSecureStorage storage;
  @override
  State<BlankPage> createState() => _BlankPageState();
}

class _BlankPageState extends State<BlankPage> {
  List<ProductModel> products = [];
  var nextToken = "";
  var activeBranch = "";
  var accessToken = "";
  int limit = 7;
  @override
  void initState() {

    super.initState();
    _fetchData();
  }

  Future<bool> _fetchData() async {
    accessToken = accessToken.isNotEmpty
        ? accessToken
        : await widget.storage.read(key: "access_token") ?? "";
    activeBranch = activeBranch.isNotEmpty
        ? activeBranch
        : await widget.storage.read(key: "active_branch") ?? "";
    nextToken = await widget.storage.read(key: "next_token") ?? "";
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
        title: const Text('Product List'),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: false,
        enablePullUp: true,
        onRefresh: () async {
          final status = await _fetchData();
          if (status) {
            _refreshController.refreshCompleted();
          } else {
            _refreshController.refreshFailed();
          }
        },
        onLoading: () async {
          final status = await _fetchData();
          if (status) {
            _refreshController.loadComplete();
          } else {
            _refreshController.loadNoData();
          }
        },
        child: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final product = products[index];
              return Product(product: product);
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: products.length),
      ),
    );
  }
}
