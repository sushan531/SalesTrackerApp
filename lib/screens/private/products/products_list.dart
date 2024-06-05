import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tipot/custom_widgets/branch_row.dart';
import 'package:tipot/custom_widgets/branches_oval_button.dart';
import 'package:tipot/custom_widgets/products_tile.dart';
import 'package:tipot/models/products_model.dart';
import 'package:tipot/providers/active_branch_providers.dart';
import 'package:tipot/rest_api/commons.dart';
import 'package:tipot/screens/private/products/tools/product_request.dart';

class ProductsListPage extends ConsumerStatefulWidget {
  const ProductsListPage({super.key});

  @override
  ConsumerState<ProductsListPage> createState() => _ProductsListPageState();
}

class _ProductsListPageState extends ConsumerState<ProductsListPage> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final ScrollController _scrollController = ScrollController();
  bool refresh = true;
  var _activeBranchName = "";
  List<String> _branches = [];
  List<ProductModel> _products = [];
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _prepareData(bool refresh) async {
    setState(() {
      _isLoading = true;
    });
    Map<String, Object?> response = await fetchData(refresh);
    if (branchChanged == true && response["prod_list"] != []) {
      _products = response["prod_list"] as List<ProductModel>;
    } else {
      _products.addAll(response["prod_list"] as List<ProductModel>);
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
      _products.clear();
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
            itemCount: _isLoading ? _products.length + 1 : _products.length,
            itemBuilder: (context, index) {
              if (index < _products.length) {
                final product = _products[index];
                return Product(product: product);
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
