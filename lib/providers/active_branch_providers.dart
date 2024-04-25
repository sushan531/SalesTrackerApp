import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActiveBranchProvider extends StateNotifier<String> {
  ActiveBranchProvider() : super("");

  void updateActiveBranch(String newBranch) {
    state = newBranch;
  }
}

final activeBranchProvider =
    StateNotifierProvider<ActiveBranchProvider, String>((ref) {
  return ActiveBranchProvider();
});
