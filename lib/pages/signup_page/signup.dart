import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  SignupPage(this.login, {super.key});

  void Function() login;

  @override
  State<SignupPage> createState() => _SignupPageState();
}

TextEditingController emailController = TextEditingController();
TextEditingController orgNameController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController confirmPasswordController = TextEditingController();

Future<void> signupAPICall(
    String orgName, email, password, confirmPassword) async {
  if (password != confirmPassword) {}
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          return;
                        } else {
                          print("Un Successful");
                        }
                        signupAPICall(
                            orgNameController.text.toString(),
                            emailController.text.toString(),
                            passwordController.text.toString(),
                            confirmPasswordController.text.toString());
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.green,
                      ),
                      child: const Text(
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
