import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tipot/models/sales_model.dart';
import 'package:tipot/rest_api/commons.dart';
import 'package:tipot/rest_api/rest_api.dart';

const storage = FlutterSecureStorage();

Future<Map<String, dynamic>> fetchBranchNameToProducts() async {
  Map<String, dynamic> branchNameToProducts = {};

  try {
    // Retrieve the access token from secure storage or use the existing one.
    // String _accessToken = await storage.read(key: "access_token") ?? "";
    Map<String, String> params = await getParameters(true);
    // Set up the headers for the HTTP request.
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${params["accessToken"]}',
    };

    // Create an instance of Dio for making HTTP requests.
    var dio = Dio();
    var uri = '${ApiEndpoints.baseurl}/api/self/get-grouped-users-product';

    // Make the HTTP GET request.
    var response = await dio.request(
      uri,
      options: Options(
        method: 'GET',
        headers: headers,
      ),
    );

    // Check if the response status code is 200 (OK).
    if (response.statusCode == 200) {
      // Parse the response data and update the map.
      branchNameToProducts = response.data["response"];
    } else {
      throw Exception("Failed to load data");
    }
  } catch (e) {
    print("Error: $e");
    // Handle errors appropriately, e.g., log them or display a message to the user.
  }
  return branchNameToProducts;
}

Future<List<SalesModel>> fetchSalesList(
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
      '${ApiEndpoints.baseurl}/api/sales/list?bid=$activeBranchUuid&limit=$limit&token=$nextToken';
  try {
    final response = await dio.get(uri, options: Options(headers: headers));

    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final dataMap = data["response"]['data'];
      if (dataMap != null) {
        final salesList = (data["response"]['data'] as List)
            .map((sales) => SalesModel.fromJson(sales as Map<String, dynamic>))
            .toList();
        dio.close();
        final nextToken = data["response"]['next_token'] as String?;
        storage.write(key: "next_token", value: nextToken);
        return salesList; // Return both list and nextToken
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
  List<SalesModel> salesLists = await fetchSalesList(
      activeBranchUuid: params["activeBranchUuid"].toString(),
      limit: 10,
      nextToken: params["nextToken"].toString(),
      accessToken: params["accessToken"].toString());
  return {
    "sales_list": salesLists,
    "active_branch_name": params["activeBranchName"]
  };
}
