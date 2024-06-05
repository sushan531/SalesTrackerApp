import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tipot/custom_widgets/branch_row.dart';
import 'package:tipot/custom_widgets/branches_oval_button.dart';
import 'package:tipot/custom_widgets/paymentReceipt_tile.dart';
import 'package:tipot/models/paymentReceipt_model.dart';
import 'package:tipot/providers/active_branch_providers.dart';
import 'package:tipot/rest_api/commons.dart';
import 'package:tipot/screens/private/paymentReceipt/tools/paymentReceipt_request.dart';

class PaymentReceiptListPage extends ConsumerStatefulWidget {
  const PaymentReceiptListPage({super.key});

  @override
  ConsumerState<PaymentReceiptListPage> createState() => _PaymentReceiptListPageState();
}

class _PaymentReceiptListPageState extends ConsumerState<PaymentReceiptListPage> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final ScrollController _scrollController = ScrollController();
  bool refresh = true;
  var _activeBranchName = "";
  List<String> _branches = [];
  List<PaymentReceiptModel> _paymentReceipt = [];
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
      _paymentReceipt = response["purchase_list"] as List<PaymentReceiptModel>;
    } else {
      _paymentReceipt.addAll(response["purchase_list"] as List<PaymentReceiptModel>);
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
      _paymentReceipt.clear();
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
            itemCount: _isLoading ? _paymentReceipt.length + 1 : _paymentReceipt.length,
            itemBuilder: (context, index) {
              if (index < _paymentReceipt.length) {
                final paymentReceipt = _paymentReceipt[index];
                return PaymentReceipt(paymentReceipt: paymentReceipt);
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
