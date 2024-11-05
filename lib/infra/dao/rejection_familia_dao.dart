import 'package:cloud_firestore/cloud_firestore.dart';

class RejectionFamilyDAO {
  final CollectionReference _ref =
      FirebaseFirestore.instance.collection('family');

  Future<List<String>> geFamilies() async {
    List<String> families = [];
    try {
      QuerySnapshot snapshot = await _ref.get();

      for (DocumentSnapshot ds in snapshot.docs) {
        Map<String, dynamic> familia = ds.data() as Map<String, dynamic>;
        families.add(familia['name']);
      }
    } catch (e) {
      print(e);
    }

    return families;
  }
}
