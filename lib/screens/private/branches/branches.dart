import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:tipot/custom_widgets/branches_tile.dart';
import 'package:tipot/models/branch_model.dart';
import 'package:tipot/rest_api/rest_api.dart';
import 'package:tipot/screens/private/branches/branches_add.dart';
import 'package:tipot/screens/private/tipot_drawer/tipot_drawer.dart';

class BranchesScreen extends StatefulWidget {
  const BranchesScreen({super.key});

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  State<BranchesScreen> createState() {
    return _BranchesScreenState();
  }
}

class _BranchesScreenState extends State<BranchesScreen> {
  final List<BranchModel> _branches = [];
  var accessToken = "";
  var _activeBranch = "";

  @override
  void initState() {
    super.initState();
    _fetchData(true);
  }

  int _page = 2;

  Widget _getActivePage(int page) {
    switch (page) {
      case 0:
        return Center(
          child: Text(
            "Dashboard Page\n$_page",
            style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
          ),
        );
      case 1:
        return const BranchesAdd();
      case 2:
        return SmartRefresher(
          controller: _refreshController,
          enablePullDown: false,
          enablePullUp: true,
          onLoading: () async {
            final status = await _fetchData(false);
            if (status) {
              _refreshController.loadComplete();
            } else {
              _refreshController.loadNoData();
            }
          },
          child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final branch = _branches[index];
                return Branch(
                  widget.storage,
                  branch: branch,
                  isActive: _activeBranch == branch.uuid,
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: _branches.length),
        );
      default:
        throw Exception('Invalid ActiveScreen value');
    }
  }

  Future<bool> _fetchData(bool? refresh) async {
    _branches.clear();
    _activeBranch = await widget.storage.read(key: "active_branch_uuid") ?? "";
    accessToken = await widget.storage.read(key: "access_token") ?? "";
    var dio = Dio();
    var headers = {
      'Cache-Control': 'true',
      'Authorization': 'Bearer $accessToken',
    };
    try {
      var uri = '${ApiEndpoints.baseurl}/api/self/get-users-branch';
      var response = await dio.request(
        uri,
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );
      dio.close();
      if (response.statusCode == 200) {
        var records = response.data["response"] as List;
        if (_activeBranch == "") {
          widget.storage
              .write(key: "active_branch_uuid", value: records[0]["uuid"]);
          _activeBranch = records[0]["uuid"];
        }
        var branch_names = [];
        for (var element in records) {
          branch_names.add(element["branch_name"]);
          widget.storage
              .write(key: element["branch_name"], value: element["uuid"]);
        }
        widget.storage
            .write(key: "branch_list", value: jsonEncode(branch_names));
        if (records.isEmpty) {
          return true;
        }
        var branches =
            records.map((record) => BranchModel.fromJson(record)).toList();
        _branches.addAll(branches);
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
      drawer: TipotDrawer(),
      appBar: AppBar(
        title: const Text('Organization Branches',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: _getActivePage(_page),
      bottomNavigationBar: CurvedNavigationBar(
        height: 60,
        backgroundColor: Colors.white,
        buttonBackgroundColor: Colors.greenAccent,
        color: Colors.green,
        animationDuration: const Duration(milliseconds: 200),
        items: const [
          Icon(Icons.dashboard_rounded, size: 25, color: Colors.white),
          Icon(Icons.add, size: 25, color: Colors.white),
          Icon(Icons.account_tree, size: 25, color: Colors.white),
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
