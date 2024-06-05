import 'package:flutter/material.dart';
import 'package:tipot/custom_widgets/branches_oval_button.dart';

class HorizontalBranchList extends StatelessWidget {
  final List<String> branches;
  final bool isLoading;
  final String activeBranchName;

  const HorizontalBranchList({
    Key? key,
    required this.branches,
    required this.isLoading,
    required this.activeBranchName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ListView.separated(
        padding: const EdgeInsets.only(left: 5),
        separatorBuilder: (context, index) => const Divider(),
        itemCount: isLoading ? branches.length + 1 : branches.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (index < branches.length) {
            final branchName = branches[index];
            return OvalButton(
              activeBranchName: activeBranchName,
              branchName: branchName,
            );
          } else {
            return const CircularProgressIndicator(); // Or any other loading indicator
          }
        },
      ),
    );
  }
}