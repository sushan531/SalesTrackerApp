import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tipot/index.dart';


class BranchControllers extends GetxController {

  TextEditingController branchcontroller = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var branchName = ''.obs; // Observable variable to hold branch name


  Future<void> addBranchName() async {
    final SharedPreferences prefs = await _prefs;
    String? token = prefs.getString('token');
    var headers = {'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',};
    var url =
    Uri.parse(ApiEndpoints.baseurl + ApiEndpoints.authEndpoints.branch
    );

    String? organizationId = prefs.getString('OrganizationId');
    print(organizationId);
    // Check if OrganizationId is available
    String? branchNameText = branchcontroller.text;
    if (branchNameText != null && branchNameText.isNotEmpty) {
      String? organizationId = prefs.getString('OrganizationId');
      if (organizationId != null) {
        Map<String, dynamic> body = {
          'BranchName': branchNameText,
          'OrganizationID': organizationId,
        };
        print(branchNameText);
        http.Response response =
        await http.post(url, body: jsonEncode(body), headers: headers);
        print(response.statusCode);

        if (response.statusCode == 200) {
          print("Branch Added");
          print(token);
          final json = jsonDecode(response.body);

          var branchid = json['record']['uuid'];
          await prefs.setString('uuid', branchid);
          print(branchid);
        }
      }
    }
  }

  RxList<String> branchNames = RxList<String>(); // List to store branch names


  Future<void> getAllBranchNames() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? organizationId = prefs.getString('OrganizationId');

    if (token != null && organizationId != null) {
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var url = Uri.parse(
          ApiEndpoints.baseurl + ApiEndpoints.authEndpoints.getbranch);

      http.Response response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        var responseList = json['response'];

        List<String> names = [];

        for (var branch in responseList) {
          var uuid = branch['uuid'];

          var branchName = branch['branch_name'];
          print('UUID: $uuid, Branch Name: $branchName');
          names.add(branchName);
        }
        branchNames.assignAll(names);

      }
    }
  }
}
