import 'package:flutter/material.dart';
import 'package:tipot/custom_widgets/branches_tile.dart';
import 'package:tipot/custom_widgets/products_tile.dart';
import 'package:tipot/models/branch_model.dart';
import 'package:tipot/models/products_model.dart';

class BranchesAdd extends StatefulWidget {
  const BranchesAdd({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BranchesAddState();
  }
}

class _BranchesAddState extends State<BranchesAdd> {
  String? _branchName;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final List<BranchModel> _branches = [];

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _branches.add(BranchModel(branchName: _branchName!));
      _formKey.currentState!.reset();
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
        Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16),
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
