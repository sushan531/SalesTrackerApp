import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tipot/custom_widgets/paymentReceipt_tile.dart';
import 'package:tipot/models/paymentReceipt_model.dart';
import 'package:tipot/rest_api/commons.dart';
import 'package:tipot/rest_api/rest_api.dart';
import 'package:tipot/screens/private/paymentReceipt/paymentReceipt.dart';

var recordType = ["credit", "debit"];

class PaymentReceiptAdd extends StatefulWidget {
  const PaymentReceiptAdd({super.key});

  @override
  State<PaymentReceiptAdd> createState() => _paymentReceiptAddState();
}

class _paymentReceiptAddState extends State<PaymentReceiptAdd> {
  String? _partnerName;
  String? _recordType;
  double? _amount;
  String? _branchName;
  String? _createdTime;

  final GlobalKey<FormState> _formKey = GlobalKey();
  final List<PaymentReceiptModel> _paymentReceipt = [];
  final storage = const FlutterSecureStorage();
  final TextEditingController _dateController = TextEditingController();

  String _accessToken = "";
  List<dynamic> _branchList = [];
  late PartnerBranchData _partnersData;
  List _partnersList = [];
  Map<String, String> branchNameToUuid = {};

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var actualBranch = branchNameToUuid[_branchName];
      _paymentReceipt.add(PaymentReceiptModel(
          partnerName: _partnerName!,
          recordType: _recordType!,
          amount: _amount!,
          branchUuid: actualBranch!,
          createdTime: _createdTime));
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
    _partnersData = await fetchPartnerWithBranch(
        accessToken: _accessToken, branch_list: _branchList);
    _partnersList = _partnersData.partnerNames;
    setState(() {});
  }

  Future<void> _upload() async {
    if (_paymentReceipt.isEmpty) {
      return;
    }
    _accessToken = (await storage.read(key: "access_token")).toString();
    var jsonObject = _paymentReceipt.map((purchase) => purchase.toJson()).toList();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_accessToken',
    };
    var dio = Dio();
    print(jsonObject);
    try {
      var data = json.encode({"Data": jsonObject});
      var uri = '${ApiEndpoints.baseurl}/api/payment-receipt/add';
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
          const SnackBar(content: Text('PaymentReceipt uploaded successfully!')),
        );
        setState(() {
          _paymentReceipt.clear();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PaymentReceiptScreen()),
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
                    height: constraints.maxHeight / 1.5,
                    child: _paymentReceipt.isEmpty
                        ? const Center(child: Text("No purchases to upload"))
                        : ListView.separated(
                            padding: const EdgeInsets.all(8),
                            itemBuilder: (context, index) {
                              final paymentReceipt = _paymentReceipt[index];
                              return PaymentReceipt(paymentReceipt: paymentReceipt);
                            },
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemCount: _paymentReceipt.length)),
              );
            }),
          ),
          Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField(
                            onSaved: (value) {
                              _partnerName = value.toString();
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text("Partner Name"),
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
                              _amount = double.parse(value!);
                            },
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Amount",
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
                          child: DropdownButtonFormField(
                            onSaved: (value) {
                              _recordType = value!;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text("RecordType"),
                            ),
                            items: recordType.map((item) {
                              return DropdownMenuItem(
                                  value: item, child: Text(item));
                            }).toList(),
                            onChanged: (selected) {},
                          ),
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
                              _createdTime = value.toString().split(" ")[0];
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
                              label: Text("Partner related to branch"),
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
                ),
              )),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
