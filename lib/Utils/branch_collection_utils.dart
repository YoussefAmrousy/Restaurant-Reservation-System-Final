import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_reservation_final/models/branch.dart';

class BranchCollectionUtils {
  CollectionReference branchesCollection =
      FirebaseFirestore.instance.collection('branches');
  List<Branch> branches = [];
  Future<void> fetchBranches(String? restaurantName) async {
    final querySnapshot = await branchesCollection.get();
    if (querySnapshot.docs.isEmpty) {
      branches = [];
      return;
    }
    if (restaurantName != null) {
      final querySnapshot = await branchesCollection
          .where('restaurant', isEqualTo: restaurantName)
          .get();
      branches = querySnapshot.docs
          .map((doc) => Branch.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } else{
      final querySnapshot = await branchesCollection.get();
      branches = querySnapshot.docs
          .map((doc) => Branch.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    }
  }
}
