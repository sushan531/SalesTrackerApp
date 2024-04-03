import 'package:flutter/material.dart';
import 'package:tipot/custom_widgets/products_tile.dart';
import 'package:tipot/models/products_model.dart';

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
  String? _productName;
  String? _description;
  String? _sellingPrice;
  String? _quantity;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final List<ProductModel> _products = [];

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print(_products.length);
      _products.add(ProductModel(
          productName: _productName!,
          description: _description!,
          sellingPrice: double.parse(_sellingPrice!),
          remainingQuantity: int.parse(_quantity!),
          branchUuid: "branchUuid",
          measurementUnit: _unitType!));
      _formKey.currentState!.reset();
      print(_products.length);
      setState(() {});
    }
  }

  void _saveItemAndUpload() {
    //TODO call the rest api to upload the products
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
                              onPressed: _saveItem, child: const Text("Upload"))
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
