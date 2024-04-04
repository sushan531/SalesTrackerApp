import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tipot/custom_widgets/products_tile.dart';
import 'package:tipot/models/products_model.dart';
import 'package:tipot/rest_api/rest_api.dart';

var measurementUnits = ["kg", "dozen", "pcs", "meters", "lbs"];

class ProductsAdd extends StatefulWidget {
  const ProductsAdd({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProductsAddState();
  }
}

class _ProductsAddState extends State<ProductsAdd> {
  String? _unitType;
  String? _branchName;
  String? _productName;
  String? _description;
  String? _sellingPrice;
  String? _quantity;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final List<ProductModel> _products = [];
  final storage = const FlutterSecureStorage();

  String _accessToken = "";
  List<dynamic> _branchList = [];
  Map<String, String> branchNameToUuid = {};

  @override
  void initState() {
    _initBranchList();
    super.initState();
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print(_products.length);
      var actualBranch = branchNameToUuid[_branchName];
      _products.add(ProductModel(
          productName: _productName!,
          description: _description!,
          sellingPrice: double.parse(_sellingPrice!),
          remainingQuantity: int.parse(_quantity!),
          measurementUnit: _unitType!,
          branchUuid: actualBranch!));
      _formKey.currentState!.reset();
      setState(() {});
    }
  }

  void _initBranchList() async {
    String? _branchesString = await storage.read(key: "branch_list");
    _branchList = jsonDecode(_branchesString!);

    for (var branch in _branchList) {
      branchNameToUuid[branch] = await storage.read(key: branch) as String;
    }
    setState(() {});
  }

  Future<void> _upload() async {
    _accessToken = await storage.read(key: "access_token") ?? "";
    var jsonObject = _products.map((product) => product.toJson()).toList();

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_accessToken',
    };
    var dio = Dio();
    try {
      var data = json.encode({"Data":jsonObject});
      var uri = '${ApiEndpoints.baseurl}/api/product/add';
      print(jsonObject);
      var response = await dio.request(
        uri,
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: data,
      );

      setState(() {
        _products.clear();
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
                  child: _products.isEmpty
                      ? const Center(child: Text("No products to upload"))
                      : ListView.separated(
                          padding: const EdgeInsets.all(8),
                          itemBuilder: (context, index) {
                            final product = _products[index];
                            return Product(product: product);
                          },
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: _products.length)),
            );
          }),
        ),
        Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextFormField(
                    onSaved: (value) {
                      _productName = value;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Product Name",
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
                  TextFormField(
                    onSaved: (value) {
                      _description = value;
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Description",
                    ),
                    validator: (value) {
                      var trimmedValue = value!.trim();
                      if (value.isEmpty ||
                          trimmedValue.length <= 2 ||
                          trimmedValue.trim().length > 300) {
                        return "Must be between 3 and 300 characters.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
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
                      const SizedBox(width: 5.0),
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
                        child: DropdownButtonFormField(
                          onSaved: (value) {
                            _unitType = value;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Unit Type"),
                          ),
                          items: measurementUnits.map((item) {
                            return DropdownMenuItem(
                                value: item, child: Text(item));
                          }).toList(),
                          onChanged: (selected) {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  DropdownButtonFormField(
                    onSaved: (value) {
                      _branchName = value.toString();
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Product related to branch"),
                    ),
                    items: _branchList.map((item) {
                      return DropdownMenuItem(value: item, child: Text(item));
                    }).toList(),
                    onChanged: (selected) {},
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
              ),
            )),
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
