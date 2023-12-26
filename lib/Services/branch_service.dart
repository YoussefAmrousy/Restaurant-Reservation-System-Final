import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_reservation_final/models/branch.dart';

class BranchService {
  CollectionReference branchesCollection =
      FirebaseFirestore.instance.collection('branches');
  List<Branch> branches = [];

  Future<List<Branch>> getAllBranches() async {
    branches.clear();
    final branchQuery = await branchesCollection.get();
    if (branchQuery.docs.isNotEmpty) {
      for (var doc in branchQuery.docs) {
        branches.add(Branch.fromSnapshot(doc));
      }
    }
    return branches;
  }

  Future<List<Branch>> getBranchesByRestaurant(String restaurant) async {
    branches.clear();
    final branchQuery = await branchesCollection
        .where('restaurant', isEqualTo: restaurant)
        .get();
    if (branchQuery.docs.isNotEmpty) {
      for (var doc in branchQuery.docs) {
        branches.add(Branch.fromSnapshot(doc));
      }
    }
    return branches;
  }

  Future<void> addBranch(Branch branch) async {
    await branchesCollection.add(branch.toJson());
  }

  Future<void> deleteBranch(String id) async {
    await branchesCollection.doc(id).delete();
  }

  Future<void> updateBranch(String id, Branch branch) async {
    await branchesCollection.doc(id).update(branch.toJson());
  }
}
