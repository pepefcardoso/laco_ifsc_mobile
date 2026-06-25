import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';
import '../../models/group_model.dart';
import '../../models/post_model.dart';
import '../../models/hug_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- Usuários ---
  Future<void> createUser(UserModel user) async {
    await _db.collection('users').doc(user.id).set(user.toMap());
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  Future<void> updateUserLocationAndSeen(String uid, GeoPoint? location) async {
    final data = <String, dynamic>{
      'lastSeen': FieldValue.serverTimestamp(),
    };
    if (location != null) {
      data['lastLocation'] = location;
    }
    await _db.collection('users').doc(uid).update(data);
  }

  Future<List<UserModel>> getGroupMembers(List<String> uids) async {
    if (uids.isEmpty) return [];
    
    // Firestore 'whereIn' limits to 10 items, handle if group has more than 10 members later if needed, 
    // for this scope 10 is fine for a family app, or we can fetch individually. Let's fetch individually to be safe with any number of members.
    List<UserModel> members = [];
    for (String uid in uids) {
      UserModel? user = await getUser(uid);
      if (user != null) {
        members.add(user);
      }
    }
    return members;
  }

  // --- Grupos ---
  Future<void> createGroup(GroupModel group) async {
    await _db.collection('groups').doc(group.id).set(group.toMap());
  }

  Future<GroupModel?> getGroup(String groupId) async {
    final doc = await _db.collection('groups').doc(groupId).get();
    if (doc.exists && doc.data() != null) {
      return GroupModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  Future<GroupModel?> getGroupByCode(String code) async {
    final query = await _db
        .collection('groups')
        .where('code', isEqualTo: code)
        .limit(1)
        .get();
        
    if (query.docs.isNotEmpty) {
      return GroupModel.fromMap(query.docs.first.data(), query.docs.first.id);
    }
    return null;
  }

  Future<void> joinGroup(String groupId, String uid) async {
    await _db.collection('groups').doc(groupId).update({
      'members': FieldValue.arrayUnion([uid])
    });
    await _db.collection('users').doc(uid).update({
      'groupId': groupId
    });
  }

  // --- Posts ---
  Future<void> createPost(PostModel post) async {
    await _db.collection('posts').doc(post.id).set(post.toMap());
  }

  Stream<List<PostModel>> getGroupPostsStream(String groupId) {
    return _db
        .collection('posts')
        .where('groupId', isEqualTo: groupId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PostModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> reactToPost(String postId, String userId, String emoji) async {
    final postRef = _db.collection('posts').doc(postId);
    await _db.runTransaction((transaction) async {
      final doc = await transaction.get(postRef);
      if (!doc.exists) return;
      
      final data = doc.data()!;
      Map<String, String> reactions = Map<String, String>.from(data['reactions'] ?? {});
      
      // Se já reagiu com esse emoji, remove; se não, adiciona/sobrescreve
      if (reactions.containsKey(userId) && reactions[userId] == emoji) {
        reactions.remove(userId);
      } else {
        reactions[userId] = emoji;
      }
      
      transaction.update(postRef, {'reactions': reactions});
    });
  }

  // --- Abraços ---
  Future<void> sendHug(HugModel hug) async {
    await _db.collection('hugs').doc(hug.id).set(hug.toMap());
  }
}
