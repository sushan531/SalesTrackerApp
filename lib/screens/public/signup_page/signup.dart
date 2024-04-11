import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tipot/rest_api/rest_api.dart';

class SignupPage extends StatefulWidget {
  const SignupPage(this.login, {super.key});

  final void Function() login;

  @override
  State<SignupPage> createState() => _SignupPageState();
}


class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isSignUpInProgress = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController orgNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    orgNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
      _isSignUpInProgress = false;
    });
  }

  void _signupAPICall(String orgName, email, password, confirmPassword) async {
    setState(() {
      _isSignUpInProgress = true;
    });
    var headers = {'Content-Type': 'application/json'};

    var data = json.encode(
        {"UserEmail": email, "Password": password, "OrganizationID": orgName});
    var dio = Dio();
    try {
      var response = await dio.post(
        '${ApiEndpoints.baseurl}/signup',
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: data,
      );
      if (_isSignUpInProgress && response.statusCode == 200) {
        print(json.encode(response.data));
        widget.login();
      }
    } on DioException catch (error) {
      String errorMessage = "Unknown Error";
      switch (error.response!.statusCode) {
        case 500:
          errorMessage = "Organization Name Taken!";
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
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height - 50,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const SizedBox(height: 60.0),
                    const Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Create your account",
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    )
                  ],
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        // TODO: add more complex Validator
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter Organization Name";
                          }
                          return null;
                        },
                        controller: orgNameController,
                        decoration: InputDecoration(
                            hintText: "Organization Name",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none),
                            fillColor: Colors.green.withOpacity(0.1),
                            filled: true,
                            prefixIcon: const Icon(Icons.person)),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        // TODO: add more complex Validator
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please entry Organization Name";
                          }
                          return null;
                        },
                        controller: emailController,
                        decoration: InputDecoration(
                            hintText: "Email",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none),
                            fillColor: Colors.green.withOpacity(0.1),
                            filled: true,
                            prefixIcon: const Icon(Icons.email)),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
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
                        controller: passwordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter a password";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Confirm Password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: Colors.green.withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.password),
                        ),
                        controller: confirmPasswordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please re-enter the password";
                          }
                          if (passwordController.text !=
                              confirmPasswordController.text) {
                            return "Password does not match";
                          }
                          return null;
                        },
                        obscureText: true,
                      ),
                    ],
                  ),
                ),
                Container(
                    padding: const EdgeInsets.only(top: 3, left: 3),
                    child: ElevatedButton(
                      onPressed: _isSignUpInProgress
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                _signupAPICall(
                                    orgNameController.text.toString(),
                                    emailController.text.toString(),
                                    passwordController.text.toString(),
                                    confirmPasswordController.text.toString());
                                orgNameController.text = "";
                                emailController.text = "";
                                passwordController.text = "";
                                confirmPasswordController.text = "";
                              } else {
                                print("Un Successful");
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.green,
                      ),
                      child: _isSignUpInProgress
                          ? const CircularProgressIndicator()
                          : const Text(
                              "Sign up",
                              style: TextStyle(fontSize: 20),
                            ),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Already have an account?"),
                    TextButton(
                        onPressed: () {
                          widget.login();
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.green),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
