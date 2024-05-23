import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tipot/models/branch_model.dart';
import 'package:tipot/rest_api/rest_api.dart';
import 'package:tipot/screens/private/branches/branches.dart';

class LoginPage extends StatefulWidget {
  const LoginPage(this.signUp, {super.key});

  final void Function() signUp;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _logInProgress = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController orgNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    orgNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Login Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
    setState(() {
      _logInProgress = false;
    });
  }

  void _getSetMetadata(Dio dio, String accessToken) async {
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
      if (response.statusCode == 200) {
        var records = response.data["response"] as List;
        // NOTE : Setting the first branch to the default branch
        widget.storage
            .write(key: "active_branch_uuid", value: records[0]["uuid"]);
        var branchNames = [];
        for (var element in records) {
          branchNames.add(element["display_name"]);
          widget.storage
              .write(key: element["display_name"], value: element["uuid"]);
        }
        widget.storage
            .write(key: "branch_list", value: jsonEncode(branchNames));
        setState(() {});
      } else {
        // Handle error scenario
        print("Error fetching data: ${response.statusCode}");
      }
    } catch (error) {
      // Handle network or other exceptions
      print("Error fetching data: $error");
    } finally {
      dio.close();
    }
  }

  void _logInAPICall(String email, orgName, password) async {
    setState(() {
      _logInProgress = true;
    });
    var headers = {'Content-Type': 'application/json'};
    var data = json.encode(
        {"Email": email, "Password": password, "OrganizationName": orgName});
    var dio = Dio();
    try {
      var response = await dio.post(
        '${ApiEndpoints.baseurl}/login',
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: data,
      );
      if (_logInProgress && response.statusCode == 200) {
        widget.storage.deleteAll();
        widget.storage
            .write(key: "access_token", value: response.data['token']);
        widget.storage
            .write(key: "organization_id", value: response.data['org_id']);
        widget.storage
            .write(key: "organization_name", value: response.data['org_name']);
        setState(() {
          _getSetMetadata(dio, response.data['token']);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const BranchesScreen()));
        });
      }
    } on DioException catch (error) {
      String errorMessage = "Unknown Error";
      // Handle specific error codes
      switch (error.response!.statusCode) {
        case 400:
          errorMessage = "Invalid Credentials";
          break;
        case 500:
          errorMessage = "Internal Server Error";
          break;
      }
      _showErrorDialog(errorMessage);
    } finally {
      dio.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(context),
              _inputField(context),
              _forgotPassword(context),
              _signup(context),
            ],
          ),
        ),
      ),
    );
  }

  _header(context) {
    return const Column(
      children: [
        Text(
          "Welcome to Tipot",
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text("Please login to continue."),
      ],
    );
  }

  _inputField(context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: emailController,
            validator: (value) {
              if (value!.isEmpty) {
                return "Please enter your registered email";
              }
              return null;
            },
            decoration: InputDecoration(
                hintText: "User Email",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none),
                fillColor: Colors.green.withOpacity(0.1),
                filled: true,
                prefixIcon: const Icon(Icons.person)),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: orgNameController,
            validator: (value) {
              if (value!.isEmpty) {
                return "Please enter your registered organization name";
              }
              return null;
            },
            decoration: InputDecoration(
                hintText: "Organization Name",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none),
                fillColor: Colors.green.withOpacity(0.1),
                filled: true,
                prefixIcon: const Icon(Icons.house)),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: passwordController,
            validator: (value) {
              if (value!.isEmpty) {
                return "Please enter password";
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: "Password",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none),
              fillColor: Colors.green.withOpacity(0.1),
              filled: true,
              prefixIcon: const Icon(Icons.password),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _logInProgress
                ? null
                : () {
                    if (_formKey.currentState!.validate()) {
                      _logInAPICall(
                          emailController.text.toString(),
                          orgNameController.text.toString(),
                          passwordController.text.toString());
                      emailController.text = "";
                      orgNameController.text = "";
                      passwordController.text = "";
                    } else {
                      print("Un Successful");
                    }
                  },
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.green,
            ),
            child: const Text(
              "Login",
              style: TextStyle(fontSize: 20),
            ),
          )
        ],
      ),
    );
  }

  _forgotPassword(context) {
    return TextButton(
      onPressed: () {},
      child: const Text(
        "Forgot password?",
        style: TextStyle(color: Colors.green),
      ),
    );
  }

  _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        TextButton(
            onPressed: () {
              widget.signUp();
            },
            child: const Text(
              "Sign Up",
              style: TextStyle(color: Colors.green),
            ))
      ],
    );
  }
}
