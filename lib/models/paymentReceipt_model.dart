class PaymentReceiptModel {
  final int? prId;
  final int? partnerId;
  final String partnerName;
  final String recordType;
  final double amount;
  final String? createdTime;
  final String branchUuid;
  final String? userEmail;
  final String? comments;
  final String? organizationId;

  PaymentReceiptModel({
    this.prId,
    this.partnerId,
    required this.partnerName,
    required this.recordType,
    required this.amount,
    this.createdTime,
    required this.branchUuid,
    this.userEmail,
    this.comments,
    this.organizationId,
  });

  Map<String, dynamic> toJson() {
    return {
      // 'payment_receipt_id': prId,
      // 'partner_id': partnerId,
      'PartnerName': partnerName,
      'RecordType': recordType,
      'Amount': amount.toString(),
      'CreatedTime': createdTime,
      'BranchUuid': branchUuid,
      // 'user_email': userEmail,
      'Comments': comments,
      // 'organization_id': organizationId,
    };
  }

  factory PaymentReceiptModel.fromJson(Map<String, dynamic> json) {
    return PaymentReceiptModel(
      prId: json['pr_id'],
      partnerId: json['partner_id'],
      partnerName: json['partner_name'],
      recordType: json['record_type']['String'],
      amount: double.parse(json['amount']),
      createdTime: json['created_time'],
      branchUuid: json['branch_uuid'],
      userEmail: json['user_email'],
      comments: json['comments']['Valid'] ? json['comments']['String'] : null,
      organizationId: json['organization_id'],
    );
  }
}
