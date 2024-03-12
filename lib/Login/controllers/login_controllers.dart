import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tipot/home/screens/add_branch.dart';
import 'package:tipot/home/screens/home_page.dart';
import 'package:tipot/index.dart';
import 'package:http/http.dart' as http;

class LoginControllers extends GetxController {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController organizationidcontroller = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> loginwithEmail() async {
    var headers = {'Content-Type': 'application/json'};

    var url =
        Uri.parse(ApiEndpoints.baseurl + ApiEndpoints.authEndpoints.login);
    Map body = {
      'Email': emailcontroller.text,
      'Password': passwordcontroller.text,
      'OrganizationName': organizationidcontroller.text,
    };
    http.Response response =
        await http.post(url, body: jsonEncode(body), headers: headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      var token = json['token'];
      final SharedPreferences? prefs = await _prefs;
      await prefs?.setString('token', token);

      print("Login Successful");

//Check if the stored token matches the logge-in tken before navigating
      if (await isValidToken(token)) {
        Get.offAll(() => const AddBranch());
      } else {
        print("Invalid Token");
      }
    } else {
      print("Not Registered");
    }
  }

  Future<bool> isValidToken(String? loggedInToken) async {
    //Retrieve the stored token from locl storage
    final SharedPreferences? prefs = await _prefs;
    String? storedToken = prefs?.getString('token');

    return storedToken != null &&
        storedToken.isNotEmpty &&
        loggedInToken == storedToken;
  }
}
