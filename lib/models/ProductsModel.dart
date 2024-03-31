class Product {
  final int productId;
  final String productName;
  final String? productImage; // Make productImage nullable
  final String description;
  final double sellingPrice;
  final int remainingQuantity;
  final DateTime createdTime;
  final String branchUuid;
  final String measurementUnit;

  Product({
    required this.productId,
    required this.productName,
    this.productImage,
    required this.description,
    required this.sellingPrice,
    required this.remainingQuantity,
    required this.createdTime,
    required this.branchUuid,
    required this.measurementUnit,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    productId: json['product_id'],
    productName: json['product_name'],
    productImage: json['product_image']?['String'], // Extract image URL
    description: json['description']?['String'], // Extract description
    sellingPrice: double.parse(json['selling_price']),
    remainingQuantity: int.parse(json['remaining_quantity']),
    createdTime: DateTime.parse(json['created_time']),
    branchUuid: json['branch_uuid'],
    measurementUnit: json['measurement_unit'],
  );
}
