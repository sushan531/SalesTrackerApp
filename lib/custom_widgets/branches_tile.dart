import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tipot/models/branch_model.dart';
import 'package:tipot/screens/private/branches/branches.dart';

class BranchMini extends StatelessWidget {
  final BranchModel branch;

  const BranchMini({Key? key, required this.branch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access properties using dot notation (assuming Product class)
    return Container(
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1.0,
        ),
      ),
      child: ListTile(
        leading: const Icon(Icons.shopping_bag),
        title: Text(branch.branchName),
        subtitle: Text(
          'BranchId: ${branch.uuid}',
        ),
      ),
    );
  }
}

class Branch extends StatefulWidget {
  final BranchModel branch;

  const Branch(this.storage,
      {Key? key, required this.branch})
      : super(key: key);

  final FlutterSecureStorage storage;
  // final bool isActive;

  @override
  State<Branch> createState() => _BranchState();
}

class _BranchState extends State<Branch> {

  @override
  Widget build(BuildContext context) {
    // Access properties using dot notation (assuming Product class)
    return Container(
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1.0,
        ),
      ),
      child: ListTile(
        leading: const Icon(Icons.shopping_bag),
        title: Text(widget.branch.branchName),
        subtitle: Text(
          'BranchId: ${widget.branch.uuid}',
        ),
        // trailing: TextButton.icon(
        //   icon: widget.isActive
        //       ? const Icon(Icons.insert_emoticon_rounded)
        //       : const Icon(Icons.insert_emoticon_outlined),
        //   onPressed: () {
        //     _setActiveBranchUuid(widget.branch.uuid);
        //   },
        //   style: ElevatedButton.styleFrom(
        //       shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(30)),
        //       textStyle: const TextStyle(color: Colors.greenAccent),
        //       backgroundColor: Colors.white),
        //   label:
        //       widget.isActive ? const Text("Active") : const Text("Inactive"),
        // ),
      ),
    );
  }
}
