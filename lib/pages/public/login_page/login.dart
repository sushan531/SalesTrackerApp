import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tipot/rest_api/rest_api.dart';

class LoginPage extends StatefulWidget {
  LoginPage(this.signUp, this.blank, this.storage, {super.key});

  final void Function() signUp;
  final void Function() blank;
  final FlutterSecureStorage storage;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _logInProgress = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController orgNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _logInAPICall(String, email, orgName, password) async {
    setState(() {
      _logInProgress = true;
    });
    var headers = {'Content-Type': 'application/json'};
    var data = json.encode(
        {"Email": email, "Password": password, "OrganizationName": orgName});
    var dio = Dio();
    var response = await dio.post(
      '${ApiEndpoints.baseurl}/login',
      options: Options(
        method: 'POST',
        headers: headers,
      ),
      data: data,
    );
    if (_logInProgress && response.statusCode == 200) {
      widget.storage.write(key: "token", value: response.data['token']);
      widget.blank();
    } else {
      print(response.statusMessage);
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
                          String,
                          emailController.text.toString(),
                          orgNameController.text.toString(),
                          passwordController.text.toString());
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