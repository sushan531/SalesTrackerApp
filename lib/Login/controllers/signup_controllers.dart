import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tipot/index.dart';
import 'package:http/http.dart' as http;


class SignupControllers extends GetxController {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController organizationidcontroller = TextEditingController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> registerWithEmail() async {
    var headers = {'Content-Type': 'application/json',
      'Accept': 'application/json'};
    var url =
    Uri.parse(ApiEndpoints.baseurl + ApiEndpoints.authEndpoints.signup);
    Map body = {

      'UserEmail': emailcontroller.text,
      'Password': passwordcontroller.text,
      'OrganizationID': organizationidcontroller.text,
    };


    http.Response response =
    await http.post(url, body: jsonEncode(body), headers: headers);
    print(response.statusCode.runtimeType);

    print(response.body);


    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      var token = json['OrganizationId'];
      print(token);


      //Save token to local storage
      final SharedPreferences? prefs = await _prefs;
      await prefs?.setString('OrganizationId', token);


//Check if the stored token matches the logge-in token before navigating
      if (await isValidToken(token)) {
        Get.offAll(() => const MessageDialog());
      } else {
        print("Invalid Token");
      }
    } else {
      print("error");
    }
  }

  Future<bool> isValidToken(String? loggedInToken) async {
    //Retrieve the stored token from local storage
    final SharedPreferences? prefs = await _prefs;
    String? storedToken = prefs?.getString('OrganizationId');

    return storedToken != null &&
        storedToken.isNotEmpty &&
        loggedInToken == storedToken;
  }
}

