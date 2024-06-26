class ProductModel {
  final int? productId;
  final String productName;
  String productImage; // Make productImage nullable
  final String description;
  final double sellingPrice;
  final int remainingQuantity;
  final DateTime? createdTime;
  final String branchUuid;
  final String measurementUnit;

  ProductModel({
    this.productId,
    required this.productName,
    required this.productImage,
    required this.description,
    required this.sellingPrice,
    required this.remainingQuantity,
    this.createdTime,
    required this.branchUuid,
    required this.measurementUnit,
  });

  Map<String, dynamic> toJson() {
    return {
      'ProductName': productName,
      'Description': description,
      'SellingPrice': sellingPrice.toString(), // Convert to string
      'RemainingQuantity': remainingQuantity,
      'BranchUuid': branchUuid,
      'MeasurementUnit': measurementUnit,
      'ProductImage': productImage,
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        productId: json['product_id'],
        productName: json['product_name'],
        productImage: json['product_image']?['String'],
        // Extract image URL
        description: json['description']?['String'],
        // Extract description
        sellingPrice: double.parse(json['selling_price']),
        remainingQuantity: int.parse(json['remaining_quantity']),
        createdTime: DateTime.parse(json['created_time']),
        branchUuid: json['branch_uuid'],
        measurementUnit: json['measurement_unit'],
      );
}
