import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tipot/custom_widgets/branches_oval_button.dart';
import 'package:tipot/custom_widgets/products_tile.dart';
import 'package:tipot/models/products_model.dart';
import 'package:tipot/providers/active_branch_providers.dart';
import 'package:tipot/screens/private/products/tools/product_request.dart';

class ProductsListPage extends ConsumerStatefulWidget {
  const ProductsListPage({super.key});

  @override
  ConsumerState<ProductsListPage> createState() => _ProductsListState();
}

class _ProductsListState extends ConsumerState<ProductsListPage> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final ScrollController _scrollController = ScrollController();

  var _activeBranchName = "";
  List<String> _branches = [];
  var nextToken = "";
  int limit = 10;
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
        _prepareData();
      }
    });
    _getBranches();
    _prepareData();
  }

  void _getBranches() async {
    _branches = await getBranches();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _prepareData() async {
    setState(() {
      _isLoading = true;
    });
    // _getBranches();
    Map<String, Object?> response = await fetchData();
    if (branchChanged == true && response["prod_list"] != []) {
      _products = response["prod_list"] as List<ProductModel>;
    } else {
      _products.addAll(response["prod_list"] as List<ProductModel>);
      debugPrint("Am here now");
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
        _prepareData();
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
