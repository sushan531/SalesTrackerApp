import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tipot/providers/active_branch_providers.dart';

class OvalButton extends ConsumerStatefulWidget {
  const OvalButton(
      {super.key, required this.activeBranchName, required this.branchName});

  final String activeBranchName;
  final String branchName;

  @override
  ConsumerState<OvalButton> createState() => _OvalButtonState();
}

class _OvalButtonState extends ConsumerState<OvalButton> {

  @override
  Widget build(BuildContext context) {
    return widget.activeBranchName == widget.branchName
        ? ElevatedButton(onPressed: () {}, child: Text(widget.branchName))
        : OutlinedButton(
            onPressed: () {
              ref
                  .read(activeBranchProvider.notifier)
                  .updateActiveBranch(widget.branchName);
            },
            child: Text(widget.branchName));
  }
}
