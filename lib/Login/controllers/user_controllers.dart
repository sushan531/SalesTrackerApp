
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tipot/index.dart';
class SalesAddUserControllers extends GetxController{
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> AddUserWithEmail() async {
    final SharedPreferences prefs = await _prefs;
    String? token = prefs.getString('token');
    var headers = {'Content-Type': 'application/json',
      'Accept': 'application/json'};
    var url =
    Uri.parse(ApiEndpoints.baseurl + ApiEndpoints.authEndpoints.adduser);
    String? organizationId = prefs.getString('OrganaizationId');
    print(organizationId);
    String? branchUuids = prefs.getString('branchUuids');
    Map body = {
      'UserEmail': emailcontroller.text,
      'Password': passwordcontroller.text,
      'OrganizationID': organizationId,
      'BranchUuids': branchUuids,
      'Role': "sales",

    };
  }

  }
  class SalesLoginControllers extends GetxController {
  TextEditingController salesusercontroller = TextEditingController();
  TextEditingController salespwdcontroller = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> AddUserWithEmail() async {
  final SharedPreferences prefs = await _prefs;
  String? token = prefs.getString('token');
  var headers = {'Content-Type': 'application/json',
  'Accept': 'application/json'};
  var url =
  Uri.parse(ApiEndpoints.baseurl + ApiEndpoints.authEndpoints.adduser);
  String? organizationId = prefs.getString('OrganaizationId');
  print(organizationId);
  String? branchUuids = prefs.getString('branchUuids');
  Map body = {
  'UserEmail':salesusercontroller.text,
  'Password':salespwdcontroller.text,
  'OrganizationID':organizationId,
  'BranchUuids':branchUuids,
  'Role':"sales",

  };
  }
  }
