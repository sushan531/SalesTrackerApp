import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tipot/custom_widgets/partners_tile.dart';
import 'package:tipot/models/partners_model.dart';
import 'package:tipot/rest_api/rest_api.dart';

var recordType = ["credit", "debit"];

class PartnersAdd extends StatefulWidget {
  const PartnersAdd({super.key});

  @override
  State<PartnersAdd> createState() => _ledgersAddState();
}

class _ledgersAddState extends State<PartnersAdd> {
  String? _partnerName;
  String? _contactNumber;
  int? _panNumber;
  String? _address;
  String? _email;
  String? _branchName;

  final GlobalKey<FormState> _formKey = GlobalKey();
  final List<PartnerModel> _partners = [];
  final storage = const FlutterSecureStorage();

  String _accessToken = "";
  List<dynamic> _branchList = [];
  Map<String, String> branchNameToUuid = {};

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var actualBranch = branchNameToUuid[_branchName];
      _partners.add(PartnerModel(
          partnerName: _partnerName!,
          contactNumber: _contactNumber,
          panNumber: _panNumber,
          address: _address,
          email: _email,
          branchUuid: actualBranch));
      _formKey.currentState!.reset();
      setState(() {});
    }
  }

  @override
  void initState() {
    _initPartnersAndBranchList();
    super.initState();
  }

  void _initPartnersAndBranchList() async {
    String? branchesString = await storage.read(key: "branch_list");
    _branchList = jsonDecode(branchesString!);

    for (var branch in _branchList) {
      branchNameToUuid[branch] = await storage.read(key: branch) as String;
    }
    setState(() {});
  }

  Future<void> _upload() async {
    _accessToken = (await storage.read(key: "access_token")).toString();
    var jsonObject = _partners.map((purchase) => purchase.toJson()).toList();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_accessToken',
    };
    var dio = Dio();
    print(jsonObject);
    try {
      var data = json.encode({"Data": jsonObject});
      var uri = '${ApiEndpoints.baseurl}/api/partner/add';
      Future.delayed(const Duration(seconds: 1));

      var response = await dio.request(
        uri,
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: data,
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Partners uploaded successfully!')),
        );
        setState(() {
          _partners.clear();
        });
      }
    } catch (error) {
      setState(() {
        _partners.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to uploaded partners!')),
      );    } finally {
      dio.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                child: SizedBox(
                    height: constraints.maxHeight,
                    child: _partners.isEmpty
                        ? const Center(child: Text("No partners to upload"))
                        : ListView.separated(
                            padding: const EdgeInsets.all(8),
                            itemBuilder: (context, index) {
                              final partner = _partners[index];
                              return Partner(partner: partner);
                            },
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemCount: _partners.length)),
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
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            onSaved: (value) {
                              _partnerName = value;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Partner Name",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Name cannot be empty";
                              }
                              return null;
                            },
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            onSaved: (value) {
                              _contactNumber = value;
                            },
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Contact Number",
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.toString().length != 10) {
                                return "Must be a valid contact number";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            onSaved: (value) {
                              _email = value;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Email",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email cannot be null";
                              }
                              return null;
                            },
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            onSaved: (value) {
                              _address = value;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Address",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Address cannot be null";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: DropdownButtonFormField(
                            onSaved: (value) {
                              _branchName = value.toString();
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text("Product related to branch"),
                            ),
                            items: _branchList.map((item) {
                              return DropdownMenuItem(
                                  value: item, child: Text(item));
                            }).toList(),
                            onChanged: (selected) {},
                          ),
                        ),
                      ],
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
                                onPressed: _saveItem,
                                child: const Text("Save")),
                            const SizedBox(width: 10.0),
                            ElevatedButton(
                                onPressed: _upload, child: const Text("Upload"))
                          ]),
                    )
                  ],
                )),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
