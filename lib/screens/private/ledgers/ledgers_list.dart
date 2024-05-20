import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tipot/custom_widgets/branches_oval_button.dart';
import 'package:tipot/custom_widgets/ledgers_tile.dart';
import 'package:tipot/models/ledgers_model.dart';
import 'package:tipot/providers/active_branch_providers.dart';
import 'package:tipot/rest_api/commons.dart';
import 'package:tipot/screens/private/ledgers/tools/ledgers_request.dart';

class LedgerListPage extends ConsumerStatefulWidget {
  const LedgerListPage({super.key});

  @override
  ConsumerState<LedgerListPage> createState() => _LedgerListPageState();
}

class _LedgerListPageState extends ConsumerState<LedgerListPage> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final ScrollController _scrollController = ScrollController();
  bool refresh = true;
  var _activeBranchName = "";
  List<String> _branches = [];
  List<LedgerModel> _ledgers = [];
  bool branchChanged = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    branchChanged = false;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoading) {
        _prepareData(false);
      }
    });
    _getBranches();
    _prepareData(refresh);
    refresh = false;
  }

  void _getBranches() async {
    _branches = await getBranches();
  }

  void _prepareData(bool refresh) async {
    setState(() {
      _isLoading = true;
    });
    Map<String, Object?> response = await fetchData(refresh);
    if (branchChanged == true && response["purchase_list"] != []) {
      _ledgers = response["purchase_list"] as List<LedgerModel>;
    } else {
      _ledgers.addAll(response["purchase_list"] as List<LedgerModel>);
    }
    _activeBranchName = response["active_branch_name"] as String;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newActiveBranchName = ref.watch(activeBranchProvider).toString();
    if (newActiveBranchName.isNotEmpty &&
        newActiveBranchName != _activeBranchName) {
      branchChanged = true;
      _storage.write(key: "active_branch_name", value: newActiveBranchName);
      _storage.write(key: "next_token", value: "");
      _ledgers.clear();
      setState(() {
        _activeBranchName = newActiveBranchName;
        _prepareData(true);
      });
    }
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: ListView.separated(
            padding: const EdgeInsets.only(left: 5),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: _isLoading ? _branches.length + 1 : _branches.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              if (index < _branches.length) {
                final branchName = _branches[index];
                return OvalButton(
                  activeBranchName: _activeBranchName,
                  branchName: branchName,
                );
              }
            },
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _isLoading ? _ledgers.length + 1 : _ledgers.length,
            itemBuilder: (context, index) {
              if (index < _ledgers.length) {
                final ledger = _ledgers[index];
                return Ledger(ledger: ledger);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        )
      ],
    );
  }
}
