import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tipot/custom_widgets/products_tile.dart';
import 'package:tipot/custom_widgets/sales_tile.dart';
import 'package:tipot/models/products_model.dart';
import 'package:tipot/models/sales_model.dart';
import 'package:tipot/rest_api/rest_api.dart';

var measurementUnits = ["kg", "dozen", "pcs", "meters", "lbs"];

class SalesAdd extends StatefulWidget {
  const SalesAdd({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SalesAddState();
  }
}

class _SalesAddState extends State<SalesAdd> {
  String? _branchName;
  String? _productName;
  String? _sellingPrice;
  String? _currentCostPrice;
  String? _quantity;
  String? _date;
  String? _comments;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final List<SalesModel> _sales = [];
  final storage = const FlutterSecureStorage();
  final TextEditingController _dateController = TextEditingController();

  String _accessToken = "";
  List<dynamic> _branchList = [];
  List<dynamic> _productList = [];
  Map<String, String> branchNameToUuid = {};

  // This will not have any branches that has no products
  Map<String, dynamic> branchNameToProducts = {};

  @override
  void initState() {
    _initData();
    super.initState();
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var actualBranch = branchNameToUuid[_branchName];
      _sales.add(SalesModel(
        productName: _productName!,
        branchUuid: actualBranch!,
        currentCostPrice: double.parse(_currentCostPrice!),
        soldDate: _date!,
        comments: _comments,
        quantity: double.parse(_quantity!),
        salesPrice: double.parse(_sellingPrice!),
      ));
      _formKey.currentState!.reset();
      setState(() {});
    }
  }

  void _initData() async {
    Future.delayed(const Duration(seconds: 1));
    String? branchesString = await storage.read(key: "branch_list");

    _branchList = jsonDecode(branchesString!);
    _accessToken = _accessToken.isNotEmpty
        ? _accessToken
        : (await storage.read(key: "access_token")).toString();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_accessToken',
    };
    var dio = Dio();
    var uri = '${ApiEndpoints.baseurl}/api/self/get-users-product';
    var response = await dio.request(
      uri,
      options: Options(
        method: 'GET',
        headers: headers,
      ),
    );
    if (response.statusCode == 200) {
      branchNameToProducts = response.data["response"];
    }
    for (var branch in _branchList) {
      branchNameToUuid[branch] = await storage.read(key: branch) as String;
    }
    setState(() {});
  }

  Future<void> _upload() async {
    _accessToken = _accessToken.isNotEmpty
        ? _accessToken
        : (await storage.read(key: "access_token")).toString();
    var jsonObject = _sales.map((sale) => sale.toJson()).toList();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_accessToken',
    };
    var dio = Dio();
    try {
      var data = json.encode({"Data": jsonObject});
      var uri = '${ApiEndpoints.baseurl}/api/sales/add';
      Future.delayed(const Duration(seconds: 1));

      await dio.request(
        uri,
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: data,
      );

      setState(() {
        _sales.clear();
      });
    } catch (error) {
      print("Error fetching data: $error");
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
                  height: constraints.maxHeight / 1.5,
                  child: _sales.isEmpty
                      ? const Center(child: Text("No sales to upload"))
                      : ListView.separated(
                          padding: const EdgeInsets.all(8),
                          itemBuilder: (context, index) {
                            final sale = _sales[index];
                            return Sale(sale: sale);
                          },
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: _sales.length)),
            );
          }),
        ),
        Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  DropdownButtonFormField(
                    onSaved: (value) {
                      _branchName = value.toString();
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Branch"),
                    ),
                    items: _branchList.map((item) {
                      return DropdownMenuItem(value: item, child: Text(item));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _branchName = value.toString();
                        _productList = branchNameToProducts[_branchName] ?? [];
                      }); // Update state to trigger rebuild
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField(
                          onSaved: (value) {
                            _productName = value.toString();
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Product"),
                          ),
                          items: _productList.map((item) {
                            return DropdownMenuItem(
                                value: item, child: Text(item));
                          }).toList(),
                          onChanged: (selected) {},
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Expanded(
                        child: TextFormField(
                          onSaved: (value) {
                            _sellingPrice = value;
                          },
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Selling Price",
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                double.parse(value) <= 0) {
                              return "Must be greater than 0";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                            onSaved: (value) {
                              _quantity = value;
                            },
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Quantity",
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  int.tryParse(value) == null ||
                                  int.tryParse(value)! <= 0) {
                                return "Must be valid positive number.";
                              }
                              return null;
                            }),
                      ),
                      const SizedBox(width: 5.0),
                      Expanded(
                        child: TextFormField(
                            onSaved: (value) {
                              _currentCostPrice = value;
                            },
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "CurrentCost Price",
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  int.tryParse(value) == null ||
                                  int.tryParse(value)! <= 0) {
                                return "Must be valid positive number.";
                              }
                              return null;
                            }),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            _comments = value;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Comments",
                          ),
                          validator: (value) {
                            var trimmedValue = value!.trim();
                            if (value.isEmpty ||
                                trimmedValue.length <= 1 ||
                                trimmedValue.trim().length > 300) {
                              return "Must be between 3 and 300 characters.";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                          child: TextFormField(
                        controller: _dateController,
                        onTap: () async {
                          final DateTime? date = await showDatePicker(
                              context: context,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100));
                          setState(() {
                            _dateController.text =
                                date.toString().split(" ")[0];
                          });
                        },
                        onSaved: (value) {
                          _date = value.toString().split(" ")[0];
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Date",
                          filled: true,
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                      ))
                    ],
                  ),
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
              ),
            )),
        const SizedBox(height: 20.0),
      ]),
    );
  }
}
