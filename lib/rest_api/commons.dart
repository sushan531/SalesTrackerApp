import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tipot/rest_api/rest_api.dart';

const FlutterSecureStorage _storage = FlutterSecureStorage();

Future<Map<String, String>> getParameters(bool refresh) async {
  String nextToken;
  if (refresh == true) {
    nextToken = "";
  } else {
    nextToken = await _storage.read(key: "next_token") ?? "";
  }
  final activeBranchName = await _storage.read(key: "active_branch_name");
  final activeBranchUuid =
      await _storage.read(key: activeBranchName.toString());
  final accessToken = (await _storage.read(key: "access_token"))!;

  return {
    'activeBranchName': activeBranchName.toString(),
    'activeBranchUuid': activeBranchUuid.toString(),
    'nextToken': nextToken.toString(),
    'accessToken': accessToken.toString(),
  };
}

Future<List<String>> getBranches() async {
  final localBranchesString = await _storage.read(key: "branch_list") as String;
  final branches =
      jsonDecode(localBranchesString) as List<dynamic>?; // Allow null

  if (branches != null) {
    return branches.cast<String>(); // Cast to List<String>
  } else {
    // Handle the case where branches is null (e.g., return an empty list)
    return [];
  }
}

class ProductsListData {
  final List<String> productNames;

  ProductsListData({
    required this.productNames,
  });
}

Future<ProductsListData> fetchProductNames(
    {required String accessToken}) async {
  var params = await getParameters(true);
  final dio = Dio(); // Create a new Dio instance for cleaner separation
  var headers = {
    'Cache-Control': 'true',
    'Authorization': 'Bearer ${params["accessToken"]}',
  };
  List<String> productNames = [];

  const uri = '${ApiEndpoints.baseurl}/api/self/list-products';
  try {
    final response = await dio.get(uri, options: Options(headers: headers));
    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final dataList = data["response"];
      if (dataList != null) {
        final _productNames = data["response"].toList();
        for (String product in _productNames){
          productNames.add(product);
        }
        dio.close();
        return ProductsListData(
            productNames: productNames); // Return both list and nextToken
      } else {
        return ProductsListData(productNames: []);
      }
    } else {
      // Handle non-200 status codes appropriately (throw exception, log error, etc.)
      debugPrint("Error fetching data: ${response.statusCode}");
    }
  } on DioException catch (error) {
    // Handle DioError for network or other issues
    debugPrint("Error fetching data: $error");
  }
  return ProductsListData(productNames: []);
}

class PartnerBranchData {
  final Map<String, List<String>> branchToPartner;
  final List<String> partnerNames;

  PartnerBranchData({
    required this.branchToPartner,
    required this.partnerNames,
  });
}

Future<PartnerBranchData> fetchPartnerWithBranch(
    {required String accessToken, required List branch_list}) async {
  var params = await getParameters(true);
  final dio = Dio(); // Create a new Dio instance for cleaner separation
  var headers = {
    'Cache-Control': 'true',
    'Authorization': 'Bearer ${params["accessToken"]}',
  };
  const uri = '${ApiEndpoints.baseurl}/api/partner/names-with-branch';
  List<String> partnerNames = [];
  List<String> globalPartnerNames = [];
  Map<String, List<String>> branchToPartner = {};

  try {
    final response = await dio.get(uri, options: Options(headers: headers));
    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final dataList = data["response"];
      if (dataList != null) {
        final partnerNamesWithBranch = data["response"].toList();
        dio.close();
        for (var item in partnerNamesWithBranch) {
          var branchName = item['branch_name'];
          var partnerName = item['partner_name'];
          partnerNames.add(partnerName);

          // If branch name is not specified, add partner to all other branches
          if (branchName.isEmpty) {
            globalPartnerNames.add(partnerName);
            branchToPartner.forEach((key, value) {
              branchToPartner[key] ??= [];
              branchToPartner[key]!.add(partnerName);
            });
          } else {
            branchToPartner[branchName] ??= [];
            branchToPartner[branchName]!.add(partnerName);
          }
        }
        for (final branch in branch_list) {
          if (!branchToPartner.containsKey(branch)) {
            branchToPartner[branch] ??= [];
            branchToPartner[branch]!.addAll(globalPartnerNames);
          }
        }
        return PartnerBranchData(
          branchToPartner: branchToPartner,
          partnerNames: partnerNames,
        );
      } else {
        return PartnerBranchData(
          branchToPartner: {},
          partnerNames: [],
        );
      }
    } else {
      // Handle non-200 status codes appropriately (throw exception, log error, etc.)
      debugPrint("Error fetching data: ${response.statusCode}");
    }
  } on DioException catch (error) {
    // Handle DioError for network or other issues
    debugPrint("Error fetching data: $error");
  }
  return PartnerBranchData(
    branchToPartner: {},
    partnerNames: [],
  );
}
