import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/domain/reposotries/profile_repo.dart';

class ProfileRepoImpl extends ProfileRepo {
  @override
  Future<bool> followUser(String uid, String followId) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  try {
    DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
    List following = (snap.data()! as dynamic)['user_following'];

    if (following.contains(followId)) {
      await _firestore.collection('users').doc(uid).update({
        'user_following': FieldValue.arrayRemove([followId])
      });
      await _firestore.collection('users').doc(followId).update({
        'user_followers': FieldValue.arrayRemove([uid])
      });
    } else {
      await _firestore.collection('users').doc(uid).update({
        'user_following': FieldValue.arrayUnion([followId])
      });
      await _firestore.collection('users').doc(followId).update({
        'user_followers': FieldValue.arrayUnion([uid])
      });
    }

    return true; // Operation succeeded
  } catch (e) {
    print(e.toString());
    return false; // Operation failed
  }
}
}
