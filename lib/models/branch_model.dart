class BranchModel {
  final String? uuid;
  final String branchName;

  BranchModel({this.uuid, required this.branchName});

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      uuid: json['uuid'] as String,
      branchName: json['branch_name'] as String,
    );
  }
}
