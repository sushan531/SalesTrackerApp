class BranchModel {
  final String? uuid;
  final String displayName;

  BranchModel({this.uuid, required this.displayName});

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      uuid: json['uuid'] as String,
      displayName: json['display_name'] as String,
    );
  }
}
