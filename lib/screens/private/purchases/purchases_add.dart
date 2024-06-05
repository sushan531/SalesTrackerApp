import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tipot/custom_widgets/purchases_tile.dart';
import 'package:tipot/models/purchases_model.dart';
import 'package:tipot/rest_api/commons.dart';
import 'package:tipot/rest_api/rest_api.dart';
import 'package:tipot/screens/private/purchases/purchases.dart';

class PurchasesAdd extends StatefulWidget {
  const PurchasesAdd({super.key});

  @override
  State<PurchasesAdd> createState() => _PurchasesAddState();
}

class _PurchasesAddState extends State<PurchasesAdd> {
  String? _productName;
  late double _unitPurchasePrice;
  late int _units;
  String? _purchaseDate;
  String? _supplier;
  String? _comments;
  String? _branchName;

  final GlobalKey<FormState> _formKey = GlobalKey();
  final List<PurchaseModel> _purchases = [];
  final storage = const FlutterSecureStorage();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey _autocompleteKey = GlobalKey();

  String _accessToken = "";
  List<dynamic> _branchList = [];
  late PartnerBranchData _partnersData;
  late ProductsListData _autoCompleteProductNames;
  List<String> productNames = ["product1", "product3", "product33"];
  List _partnersList = [];
  Map<String, String> branchNameToUuid = {};

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var actualBranch = branchNameToUuid[_branchName];
      var totalCost = _units * _unitPurchasePrice;
      _purchases.add(PurchaseModel(
          productName: _productName,
          unitPurchasePrice: _unitPurchasePrice,
          units: _units,
          purchaseDate: _purchaseDate!,
          supplier: _supplier!,
          comments: _comments!,
          totalCost: totalCost,
          branchUuid: actualBranch!));
      _formKey.currentState!.reset();
      _productNameController.clear();
      _dateController.clear();
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
    _partnersData = await fetchPartnerWithBranch(
        accessToken: _accessToken, branch_list: _branchList);
    _autoCompleteProductNames =
        await fetchProductNames(accessToken: _accessToken);
    productNames = _autoCompleteProductNames.productNames;
    setState(() {});
  }

  Future<void> _upload() async {
    if (_purchases.isEmpty) {
      return;
    }
    _accessToken = (await storage.read(key: "access_token")).toString();
    var jsonObject = _purchases.map((purchase) => purchase.toJson()).toList();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_accessToken',
    };
    var dio = Dio();
    try {
      var data = json.encode({"Data": jsonObject});
      print(data);
      var uri = '${ApiEndpoints.baseurl}/api/purchase/add';
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
          const SnackBar(content: Text('Purchases uploaded successfully!')),
        );
        setState(() {
          _purchases.clear();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PurchasesScreen()),
          );
        });
      } else {
        // Log the error
        print('Server returned status code ${response.statusCode}');
      }
    } catch (error) {
      // Log the error
      print("Error uploading products: $error");
    } finally {
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
                    child: _purchases.isEmpty
                        ? const Center(child: Text("No purchases to upload"))
                        : ListView.separated(
                            padding: const EdgeInsets.all(8),
                            itemBuilder: (context, index) {
                              final purchase = _purchases[index];
                              return Purchase(purchase: purchase);
                            },
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemCount: _purchases.length)),
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
                          flex: 5,
                          child: DropdownButtonFormField(
                            onSaved: (value) {
                              _branchName = value.toString();
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text("Purchase for branch"),
                            ),
                            items: _branchList.map((item) {
                              return DropdownMenuItem(
                                  value: item, child: Text(item));
                            }).toList(),
                            onChanged: (selected) {
                              setState(() {
                                _branchName = selected.toString();
                                _partnersList = _partnersData
                                        .branchToPartner[_branchName] ??
                                    [];
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    RawAutocomplete<String>(
                      focusNode: _focusNode,
                      textEditingController: _productNameController,
                      optionsViewBuilder: (BuildContext context,
                          AutocompleteOnSelected<String> onSelected,
                          Iterable<String> options) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            elevation: 4.0,
                            child: SizedBox(
                              height: 200.0,
                              child: ListView.builder(
                                padding: const EdgeInsets.all(8.0),
                                itemCount: options.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final String option =
                                      options.elementAt(index);
                                  return GestureDetector(
                                    onTap: () {
                                      onSelected(option);
                                    },
                                    child: ListTile(
                                      title: Text(option),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text == '') {
                          return const Iterable<String>.empty();
                        }
                        return productNames.where((option) {
                          var result = option
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase());
                          return result;
                        });
                      },
                      displayStringForOption: (value) => value,
                      fieldViewBuilder: ((context, _productNameController,
                          focusNode, onFieldSubmitted) {
                        return TextFormField(
                          onSaved: (value) {
                            _productName = value;
                          },
                          controller: _productNameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Product Name",
                          ),
                          focusNode: focusNode,
                          validator: (value) {
                            var trimmedValue = value!.trim();
                            if (value.isEmpty ||
                                trimmedValue.length <= 2 ||
                                trimmedValue.trim().length > 50) {
                              return "Must be between 3 and 50 characters.";
                            }
                            return null;
                          },
                        );
                      }),
                      onSelected: (String selection) {
                        _productName = selection;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      onSaved: (value) {
                        _comments = value;
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Comments",
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
                          child: DropdownButtonFormField(
                            onSaved: (value) {
                              _supplier = value.toString();
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text("Supplier Name"),
                            ),
                            items: _partnersList.map((item) {
                              return DropdownMenuItem(
                                  value: item, child: Text(item));
                            }).toList(),
                            onChanged: (selected) {},
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            onSaved: (value) {
                              _units = int.parse(value!);
                            },
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Units",
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
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                              onSaved: (value) {
                                _unitPurchasePrice = double.parse(value!);
                              },
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Unit Price",
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
                              _purchaseDate = value.toString().split(" ")[0];
                            },
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Date",
                              filled: true,
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                            readOnly: true,
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
                                  _productNameController.clear();
                                  _dateController.clear();
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
