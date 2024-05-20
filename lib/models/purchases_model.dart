class PurchaseModel {
  final int? purchaseId;
  final int? productId;
  final String? productName;
  final double unitPurchasePrice;
  final int units;
  final String purchaseDate;
  final String supplier;
  final String comments;
  final double totalCost;
  final String branchUuid;
  final String? userEmail;
  final String? organizationId;

  PurchaseModel({
    this.purchaseId,
    this.productId,
    required this.productName,
    required this.unitPurchasePrice,
    required this.units,
    required this.purchaseDate,
    required this.supplier,
    required this.comments,
    required this.totalCost,
    required this.branchUuid,
    this.userEmail,
    this.organizationId,
  });

  Map<String, dynamic> toJson() {
    return {
      'PurchaseId': purchaseId,
      'ProductId': productId,
      'ProductName': productName,
      'UnitPurchasePrice': unitPurchasePrice.toString(),
      'Units': units.toString(),
      'PurchaseDate': purchaseDate,
      'Supplier': supplier,
      'Comments': comments,
      'TotalCost': totalCost.toString(),
      'BranchUuid': branchUuid,
      'UserEmail': userEmail,
      'OrganizationId': organizationId,
    };
  }

  factory PurchaseModel.fromJson(Map<String, dynamic> json) => PurchaseModel(
        purchaseId: json['purchase_id'],
        productId: json['product_id']?['Int32'],
        productName: json['product_name'],
        unitPurchasePrice: double.parse(json['unit_purchase_price']),
        units: int.parse(json['units']),
        purchaseDate: json['purchase_date'],
        supplier: json['supplier']?['String'],
        comments: json['comments']?['String'],
        totalCost: double.parse(json['total_cost']),
        branchUuid: json['branch_uuid'],
        userEmail: json['user_email'],
        organizationId: json['organization_id'],
      );
}
