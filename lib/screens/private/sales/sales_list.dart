import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:tipot/custom_widgets/branches_oval_button.dart';
import 'package:tipot/custom_widgets/products_tile.dart';
import 'package:tipot/custom_widgets/sales_tile.dart';
import 'package:tipot/models/products_model.dart';
import 'package:tipot/models/sales_model.dart';
import 'package:tipot/providers/active_branch_providers.dart';
import 'package:tipot/rest_api/rest_api.dart';

class SalesListPage extends ConsumerStatefulWidget {
  const SalesListPage({super.key});

  @override
  ConsumerState<SalesListPage> createState() => _SalesListState();
}

class _SalesListState extends ConsumerState<SalesListPage> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final RefreshController _refreshController = RefreshController();

  var _activeBranchName = "";
  var _activeBranchUuid = "";
  var _accessToken = "";
  List<dynamic> _branches = [];
  var nextToken = "";
  int limit = 10;
  List<SalesModel> _sales = [];

  @override
  void initState() {
    super.initState();
    _getBranches();
  }

  Future<void> _getBranches() async {
    _activeBranchName = (await _storage.read(key: "active_branch_name"))!;
    var localBranches = (await _storage.read(key: "branch_list"))!;
    _branches = jsonDecode(localBranches);
  }

  Future _getSales(bool newBranch) async {
    await Future.delayed(const Duration(seconds: 1));
    if (newBranch) {
      _sales.clear();
      nextToken = "";
    }
    _accessToken = (await _storage.read(key: "access_token"))!;
    _activeBranchUuid = (await _storage.read(key: _activeBranchName))!;

    var dio = Dio();
    var headers = {
      'Cache-Control': 'true',
      'Authorization': 'Bearer $_accessToken',
    };
    try {
      var uri =
          '${ApiEndpoints.baseurl}/api/sales/list?bid=$_activeBranchUuid&limit=$limit&token=$nextToken';
      print(uri);
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
        _storage.write(key: "next_token", value: response.data["next_token"]);
        List<SalesModel> sales =
            records.map((record) => SalesModel.fromJson(record)).toList();
        _sales.addAll(sales);
        return true;
      } else {
        // Handle error scenario
        debugPrint("Error fetching data: ${response.statusCode}");
        return false;
      }
    } catch (error) {
      // Handle network or other exceptions
      debugPrint("Error fetching data: $error");
      return false;
    } finally {
      dio.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    final newActiveBranchName = ref.watch(activeBranchProvider).toString();
    if (newActiveBranchName.isNotEmpty &&
        newActiveBranchName != _activeBranchName) {
      _storage.write(key: "active_branch_name", value: newActiveBranchName);
      setState(() {
        _activeBranchName = newActiveBranchName;
      });
    } else {}

    return Column(
      children: [
        FutureBuilder(
          future: _getBranches(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
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
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        const SizedBox(height: 10),
        FutureBuilder(
          future: _getSales(true),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Expanded(
                child: SmartRefresher(
                  controller: _refreshController,
                  enablePullDown: false,
                  enablePullUp: true,
                  onRefresh: () async {
                    final status = await _getSales(false);
                    if (status) {
                      _refreshController.refreshCompleted();
                    } else {
                      _refreshController.refreshFailed();
                    }
                  },
                  onLoading: () async {
                    final status = await _getSales(true);
                    if (status) {
                      _refreshController.loadComplete();
                    } else {
                      _refreshController.loadNoData();
                    }
                  },
                  child: _sales.isEmpty
                      ? const Center(child: Text("No Products"))
                      : ListView.separated(
                          padding: const EdgeInsets.all(8),
                          itemBuilder: (context, index) {
                            final sale = _sales[index];
                            return Sale(sale: sale);
                          },
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: _sales.length),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        )
      ],
    );
  }
}
