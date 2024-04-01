import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tipot/custom_widgets/products_tile.dart';
import 'package:tipot/models/products_model.dart';
import 'package:tipot/rest_api/rest_api.dart';

class BlankPage extends StatefulWidget {
  const BlankPage(this.storage, {super.key});

  final FlutterSecureStorage storage;

  @override
  State<BlankPage> createState() => _BlankPageState();
}

class _BlankPageState extends State<BlankPage> {
  List<ProductModel> products = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    var token = await widget.storage.read(key: "token") ?? "";
    var dio = Dio();
    var headers = {
      'Cache-Control': 'true',
      'Authorization': 'Bearer $token',
    };
    try {
      // TODO bid is currently hardcoded
      var response = await dio.request(
        '${ApiEndpoints.baseurl}/api/product/list?bid=ec983e38-4861-4a3f-bf1d-bcd06aa7a3d2&limit=10&token=',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        var records = response.data["data"] as List;
        setState(() {
          List<ProductModel> _products =
              records.map((record) => ProductModel.fromJson(record)).toList();
          products = _products;
        });
      } else {
        // Handle error scenario
        print("Error fetching data: ${response.statusCode}");
      }
    } catch (error) {
      // Handle network or other exceptions
      print("Error fetching data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      alignment: Alignment.center,
      margin: const EdgeInsets.all(40),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Product List'),
        ),
        body: ProductList(products: products), // Pass the parsed products
      ),
    );
  }
}
