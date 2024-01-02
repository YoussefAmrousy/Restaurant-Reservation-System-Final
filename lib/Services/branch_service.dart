import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:reservy/models/branch.dart';

class BranchService {
  CollectionReference branchesCollection =
      FirebaseFirestore.instance.collection('branches');
  List<Branch> branches = [];
  List<Branch> nearbyBranches = [];

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

  List<Branch> getNearbyBranches(Position location) {
    double maxDistance = 5000;

    List<Branch> nearbyBranches = branches.where((branch) {
      if (branch.latitude != null && branch.longitude != null) {
        double distance = Geolocator.distanceBetween(
          location.latitude,
          location.longitude,
          branch.latitude!,
          branch.longitude!,
        );
        return distance <= maxDistance;
      }
      return false;
    }).toList();
    return nearbyBranches;
  }
}
