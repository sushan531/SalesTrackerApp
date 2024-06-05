import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tipot/custom_widgets/branch_row.dart';
import 'package:tipot/custom_widgets/branches_oval_button.dart';
import 'package:tipot/custom_widgets/partners_tile.dart';
import 'package:tipot/models/partners_model.dart';
import 'package:tipot/providers/active_branch_providers.dart';
import 'package:tipot/rest_api/commons.dart';
import 'package:tipot/screens/private/partners/tools/partners_request.dart';

class PartnerListPage extends ConsumerStatefulWidget {
  const PartnerListPage({super.key});

  @override
  ConsumerState<PartnerListPage> createState() => _PartnerListPageState();
}

class _PartnerListPageState extends ConsumerState<PartnerListPage> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final ScrollController _scrollController = ScrollController();
  bool refresh = true;
  var _activeBranchName = "";
  List<String> _branches = [];
  List<PartnerModel> _partners = [];
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
      _partners = response["purchase_list"] as List<PartnerModel>;
    } else {
      _partners.addAll(response["purchase_list"] as List<PartnerModel>);
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
      _partners.clear();
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
            itemCount: _isLoading ? _partners.length + 1 : _partners.length,
            itemBuilder: (context, index) {
              if (index < _partners.length) {
                final partner = _partners[index];
                return Partner(partner: partner);
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
