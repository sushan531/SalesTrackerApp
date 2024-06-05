import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tipot/custom_widgets/branches_tile.dart';
import 'package:tipot/models/branch_model.dart';
import 'package:tipot/rest_api/rest_api.dart';
import 'package:tipot/screens/private/branches/branches.dart';

class BranchesAdd extends StatefulWidget {
  const BranchesAdd({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BranchesAddState();
  }
}

class _BranchesAddState extends State<BranchesAdd> {
  final storage = const FlutterSecureStorage();
  String? _branchName;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final List<BranchModel> _branches = [];
  var _accessToken = "";
  var _orgId = "";

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _branches.add(BranchModel(branchName: _branchName!));
      _formKey.currentState!.reset();
      setState(() {});
    }
  }

  Future<void> _upload() async {
    if (_branches.isEmpty) {
      return;
    }
    _accessToken = await storage.read(key: "access_token") ?? "";
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_accessToken',
    };
    var dio = Dio();
    try {
      for (var branch in _branches) {
        var data = json.encode({"BranchName": branch.branchName});
        var uri = '${ApiEndpoints.baseurl}/api/admin/add-branch';

        // Send POST request with error handling
        var response =
            await dio.post(uri, options: Options(headers: headers), data: data);

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Branch uploaded successfully!')),
          );
          setState(() {
            _branches.clear();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BranchesScreen()),
            );
          });
        } else {
          // Handle other errors
          print("Unexpected error: ${response.statusCode}");
        }
      }
    } catch (error) {
      setState(() {
        _branches.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to add branch. May be it already exists.'),
        ),
      );
    } finally {
      dio.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: SizedBox(
                  height: constraints.maxHeight,
                  child: _branches.isEmpty
                      ? const Center(child: Text("No branches to add"))
                      : ListView.separated(
                          padding: const EdgeInsets.all(8),
                          itemBuilder: (context, index) {
                            final product = _branches[index];
                            return BranchMini(branch: product);
                          },
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: _branches.length)),
            );
          }),
        ),
        const Divider(),
        Container(
          padding: const EdgeInsets.all(10.0),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    onSaved: (value) {
                      _branchName = value;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Branch Name",
                    ),
                    validator: (value) {
                      var trimmedValue = value!.trim();
                      if (value.isEmpty ||
                          trimmedValue.length <= 2 ||
                          trimmedValue.trim().length > 50) {
                        return "Must be between 3 and 50 characters.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  Visibility(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {
                                _formKey.currentState!.reset();
                              },
                              child: const Text("Reset")),
                          const SizedBox(width: 10.0),
                          ElevatedButton(
                              onPressed: _saveItem, child: const Text("Save")),
                          const SizedBox(width: 10.0),
                          ElevatedButton(
                              onPressed: _upload, child: const Text("Upload"))
                        ]),
                  )
                ],
              )),
        ),
        SizedBox(height: 20.0),
      ]),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.add), label: "New Product"),
      //     BottomNavigationBarItem(icon: Icon(Icons.upload), label: "Upload"),
      //   ],
      // ),
    );
  }
}
