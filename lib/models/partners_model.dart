class PartnerModel {
  final int? partnerId;
  final String partnerName;
  final String? contactNumber;
  final int? panNumber;
  final String? address;
  final String? email;
  final String? branchUuid;
  final String? organizationId;

  PartnerModel({
    this.partnerId,
    required this.partnerName,
    this.contactNumber,
    this.panNumber,
    this.address,
    this.email,
    this.branchUuid,
    this.organizationId,
  });

  Map<String, dynamic> toJson() {
    return {
      'PartnerName': partnerName,
      'ContactNumber': contactNumber,
      'PanNumber': panNumber,
      'Address': address,
      'Email': email,
      'BranchUuid': branchUuid,
    };
  }

  factory PartnerModel.fromJson(Map<String, dynamic> json) {
    return PartnerModel(
      partnerId: json['partner_id'],
      partnerName: json['partner_name'],
      contactNumber: json['contact_number']['Valid']
          ? json['contact_number']['String']
          : null,
      panNumber:
          json['pan_number']['Valid'] ? json['pan_number']['Int32'] : null,
      address: json['address']['Valid'] ? json['address']['String'] : null,
      email: json['email']['Valid'] ? json['email']['String'] : null,
      branchUuid: json['branch_uuid'],
      organizationId: json['organization_id'],
    );
  }
}
