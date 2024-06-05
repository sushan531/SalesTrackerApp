import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tipot/custom_widgets/branch_row.dart';
import 'package:tipot/custom_widgets/branches_oval_button.dart';
import 'package:tipot/custom_widgets/sales_tile.dart';
import 'package:tipot/models/sales_model.dart';
import 'package:tipot/providers/active_branch_providers.dart';
import 'package:tipot/rest_api/commons.dart';
import 'package:tipot/screens/private/sales/tools/sales_request.dart';

class SalesListPage extends ConsumerStatefulWidget {
  const SalesListPage({super.key});

  @override
  ConsumerState<SalesListPage> createState() => _SalesListState();
}

class _SalesListState extends ConsumerState<SalesListPage> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final ScrollController _scrollController = ScrollController();

  var _activeBranchName = "";
  List<String> _branches = [];
  var nextToken = "";
  int limit = 10;
  List<SalesModel> _sales = [];
  bool _isLoading = false;
  bool branchChanged = false;
  bool refresh = true;

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

  Future<void> _getBranches() async {
    _branches = await getBranches();
  }

  void _prepareData(bool refresh) async {
    setState(() {
      _isLoading = true;
    });
    Map<String, Object?> response = await fetchData(refresh);
    if (branchChanged == true && response["sales_list"] != []) {
      _sales = response["sales_list"] as List<SalesModel>;
    } else {
      _sales.addAll(response["sales_list"] as List<SalesModel>);
    }
    _activeBranchName = response["active_branch_name"] as String;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final newActiveBranchName = ref.watch(activeBranchProvider).toString();
    if (newActiveBranchName.isNotEmpty &&
        newActiveBranchName != _activeBranchName) {
      branchChanged = true;
      _storage.write(key: "active_branch_name", value: newActiveBranchName);
      _storage.write(key: "next_token", value: "");
      _sales.clear();
      setState(() {
        _activeBranchName = newActiveBranchName;
        _prepareData(true);
      });
    }
    return Column(
      children: [
        HorizontalBranchList(branches: _branches, isLoading: _isLoading, activeBranchName: _activeBranchName),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _isLoading ? _sales.length + 1 : _sales.length,
            itemBuilder: (context, index) {
              if (index < _sales.length) {
                final sale = _sales[index];
                return Sale(sale: sale);
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
