import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tipot/models/ledgers_model.dart';
import 'package:tipot/rest_api/commons.dart';
import 'package:tipot/rest_api/rest_api.dart';

const FlutterSecureStorage _storage = FlutterSecureStorage();

Future<List<LedgerModel>> fetchPurchaseList(
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
      '${ApiEndpoints.baseurl}/api/ledger/list?bid=$activeBranchUuid&limit=$limit&token=$nextToken';
  try {
    final response = await dio.get(uri, options: Options(headers: headers));

    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final dataMap = data["response"]['data'];
      if (dataMap != null) {
        final purchaseList = (data["response"]['data'] as List)
            .map((purchase) =>
                LedgerModel.fromJson(purchase as Map<String, dynamic>))
            .toList();
        dio.close();
        final nextToken = data["response"]['next_token'] as String?;
        _storage.write(key: "next_token", value: nextToken);
        return purchaseList; // Return both list and nextToken
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

Future<Map<String, Object?>> fetchData(bool refresh) async {
  Map<String, String> params = await getParameters(refresh);
  List<LedgerModel> purchaseLists = await fetchPurchaseList(
      activeBranchUuid: params["activeBranchUuid"].toString(),
      limit: 10,
      nextToken: params["nextToken"].toString(),
      accessToken: params["accessToken"].toString());
  return {
    "purchase_list": purchaseLists,
    "active_branch_name": params["activeBranchName"]
  };
}
