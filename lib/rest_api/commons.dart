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

Future<List> fetchPartnerNames({required String accessToken}) async {
  var params = await getParameters(true);
  final dio = Dio(); // Create a new Dio instance for cleaner separation
  var headers = {
    'Cache-Control': 'true',
    'Authorization': 'Bearer ${params["accessToken"]}',
  };
  var bid = params["activeBranchUuid"].toString();
  final uri = '${ApiEndpoints.baseurl}/api/partner/name/list?bid=$bid';
  try {
    final response = await dio.get(uri, options: Options(headers: headers));
    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final dataList = data["response"];
      if (dataList != null) {
        final partnerNames = data["response"].toList();
        dio.close();
        return partnerNames; // Return both list and nextToken
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
