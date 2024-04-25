
class SalesModel {
  final String productName;
  final int? salesId;
  final double quantity;
  final double currentCostPrice;
  final double salesPrice;
  final String soldDate;
  final String? comments; // Allow null for comments
  final double? total;
  final double? profit;
  final String? paymentMethod;
  final String? customerName;
  final String branchUuid;
  final String? userEmail;

  SalesModel({
    required this.productName,
    this.salesId,
    required this.quantity,
    required this.currentCostPrice,
    required this.salesPrice,
    required this.soldDate,
    this.comments,
    this.total,
    this.profit,
    this.paymentMethod,
    this.customerName,
    required this.branchUuid,
    this.userEmail,
  });

  Map<String, dynamic> toJson() => {
        'ProductName': productName,
        'Quantity': quantity.toString(), // Convert to string for JSON
        'CurrentCostPrice': currentCostPrice.toString(),
        'SalesPrice': salesPrice.toString(),
        'SoldDate': soldDate.toString(), // Use ISO 8601 format for date
        'Comments': comments,
        'Total': total.toString(),
        'Profit': profit.toString(),
        'PaymentMethod': paymentMethod,
        'CustomerName': customerName,
        'BranchUuid': branchUuid,
      };

  factory SalesModel.fromJson(Map<String, dynamic> json) => SalesModel(
        productName: json['product_name'] as String,
        salesId: json['sales_id'] as int,
        quantity: double.parse(json['quantity'] as String),
        currentCostPrice: double.parse(json['current_cost_price'] as String),
        salesPrice: double.parse(json['sales_price'] as String),
        soldDate: json['sold_date'] as String,
        comments: json['comments']?['String'] as String?,
        total: double.parse(json['total'] as String),
        profit: double.parse(json['profit'] as String),
        paymentMethod: json['payment_method']?['String'] as String,
        customerName: json['customer_name']?['String'] as String,
        branchUuid: json['branch_uuid'] as String,
        userEmail: json['user_email'] as String,
      );
}
