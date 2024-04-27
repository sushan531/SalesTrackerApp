import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tipot/models/products_model.dart';
import 'package:tipot/rest_api/rest_api.dart';

const FlutterSecureStorage _storage = FlutterSecureStorage();

Future<List<ProductModel>> fetchProductList(
    {required String activeBranchUuid,
    required int limit,
    required nextToken,
    required accessToken}) async {
  final dio = Dio(); // Create a new Dio instance for cleaner separation
  var headers = {
    'Cache-Control': 'true',
    'Authorization': 'Bearer $accessToken',
  };

  final uri =
      '${ApiEndpoints.baseurl}/api/product/list?bid=$activeBranchUuid&limit=$limit&token=$nextToken';
  try {
    final response = await dio.get(uri, options: Options(headers: headers));

    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final dataMap = data['data'];
      if (dataMap != null) {
        final productList = (data['data'] as List)
            .map((product) =>
                ProductModel.fromJson(product as Map<String, dynamic>))
            .toList();
        dio.close();
        final nextToken = data['next_token'] as String?;
        _storage.write(key: "next_token", value: nextToken);
        return productList; // Return both list and nextToken
      } else {
        return [];
      }
    } else {
      // Handle non-200 status codes appropriately (throw exception, log error, etc.)
      debugPrint("Error fetching data: ${response.statusCode}");
    }
  } on DioException catch (error) {
    // Handle DioError for network or other issues
    debugPrint("Error fetching data: $error");
  }
  return [];
}

Future<Map<String, String>> getParameters() async {
  final activeBranchName = await _storage.read(key: "active_branch_name");
  final activeBranchUuid = await _storage.read(key: activeBranchName.toString());
  final nextToken = await _storage.read(key: "next_token") ?? "";
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

Future<Map<String, Object?>> fetchData() async {
  Map<String, String> params = await getParameters();
  List<ProductModel> productLists = await fetchProductList(
      activeBranchUuid: params["activeBranchUuid"].toString(),
      limit: 10,
      nextToken: params["nextToken"].toString(),
      accessToken: params["accessToken"].toString());
  return {
    "prod_list": productLists,
    "active_branch_name": params["activeBranchName"]
  };
}
