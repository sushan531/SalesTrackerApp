import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:tipot/custom_widgets/branches_oval_button.dart';
import 'package:tipot/custom_widgets/products_tile.dart';
import 'package:tipot/models/products_model.dart';
import 'package:tipot/providers/active_branch_providers.dart';
import 'package:tipot/rest_api/rest_api.dart';

class ProductsListPage extends StatefulWidget {
  const ProductsListPage({super.key});

  @override
  State<ProductsListPage> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsListPage> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ProductsBranchHorizontalList(),
        SizedBox(
          height: 5,
        ),
        ListOfProducts(),
      ],
    );
  }
}

class ProductsBranchHorizontalList extends ConsumerStatefulWidget {
  const ProductsBranchHorizontalList({super.key});

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  ConsumerState<ProductsBranchHorizontalList> createState() =>
      _ProductsBranchHorizontalListState();
}

class _ProductsBranchHorizontalListState
    extends ConsumerState<ProductsBranchHorizontalList> {
  // var nextToken = "";
  // var accessToken = "";
  // int limit = 7;
  // var previousActiveBranchUuid = "";
  var _activeBranchName = "";
  var _newActiveBranchName = "";
  var _activeBranchUuid = "";
  List<dynamic> _branches = [];

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Map<String, String> branchNameToUuidMap = {};

  // Future<bool> _fetchData(bool? refresh) async {
  //   if (refresh == true) {
  //     products.clear();
  //     nextToken = "";
  //   } else {
  //     nextToken = await widget.storage.read(key: "next_token") ?? "";
  //   }
  //   accessToken = await widget.storage.read(key: "access_token") ?? "";
  //   activeBranchUuid =
  //       await widget.storage.read(key: "active_branch_uuid") ?? "";
  //   var dio = Dio();
  //   var headers = {
  //     'Cache-Control': 'true',
  //     'Authorization': 'Bearer $accessToken',
  //   };
  //   try {
  //     var uri =
  //         '${ApiEndpoints.baseurl}/api/product/list?bid=$activeBranchUuid&limit=$limit&token=$nextToken';
  //     print(uri);
  //     var response = await dio.request(
  //       uri,
  //       options: Options(
  //         method: 'GET',
  //         headers: headers,
  //       ),
  //     );
  //     dio.close();
  //     if (response.statusCode == 200) {
  //       var records = response.data["data"] as List;
  //       _refreshController.loadComplete();
  //       if (records.isEmpty) {
  //         return true;
  //       }
  //       widget.storage
  //           .write(key: "next_token", value: response.data["next_token"]);
  //       List<ProductModel> _products =
  //           records.map((record) => ProductModel.fromJson(record)).toList();
  //       products.addAll(_products);
  //       setState(() {});
  //       return true;
  //     } else {
  //       // Handle error scenario
  //       print("Error fetching data: ${response.statusCode}");
  //       return false;
  //     }
  //   } catch (error) {
  //     // Handle network or other exceptions
  //     print("Error fetching data: $error");
  //     return false;
  //   } finally {
  //     dio.close();
  //   }
  // }
  //
  // final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    // Parse JSON data
    _getBranches();
  }

  Future<void> _getBranches() async {
    _activeBranchUuid = (await _storage.read(key: "active_branch_uuid"))!;
    _activeBranchName = (await _storage.read(key: "active_branch_name"))!;
    var localBranches = (await _storage.read(key: "branch_list"))!;
    _branches = jsonDecode(localBranches);
  }

  @override
  Widget build(BuildContext context) {
    final newActiveBranchName = ref.watch(activeBranchProvider).toString();
    if (newActiveBranchName.isNotEmpty) {
      _storage.write(key: "active_branch_name", value: newActiveBranchName);
      setState(() {});
    }

    return FutureBuilder(
      future: _getBranches(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text('Please wait its loading...'));
        } else {
          return SizedBox(
            height: 50,
            child: ListView.separated(
              padding: const EdgeInsets.only(left: 5),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: _branches.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final branchName = _branches[index];
                return OvalButton(
                  activeBranchName: _activeBranchName,
                  branchName: branchName,
                );
              },
            ),
          );
        }
      },
    );
  }
}

class ListOfProducts extends StatefulWidget {
  const ListOfProducts({super.key});

  @override
  State<ListOfProducts> createState() => _ListOfProductsState();
}

class _ListOfProductsState extends State<ListOfProducts> {
  List<ProductModel> _products = [];

  final RefreshController _refreshController = RefreshController();

  Future _fetchData() async {}

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SmartRefresher(
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
        child: _products.isEmpty
            ? const Center(child: Text("No Products"))
            : ListView.separated(
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return Product(product: product);
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: _products.length),
      ),
    );
  }
}
