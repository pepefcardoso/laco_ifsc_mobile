import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';
import '../../models/group_model.dart';
import '../../models/post_model.dart';
import '../../models/hug_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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
    
    List<UserModel> members = [];
    for (String uid in uids) {
      UserModel? user = await getUser(uid);
      if (user != null) {
        members.add(user);
      }
    }
    return members;
  }

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
    await _db.collection('users').doc(uid).set({
      'groupId': groupId
    }, SetOptions(merge: true));
  }

  Future<void> createPost(PostModel post) async {
    await _db.collection('groups').doc(post.groupId).collection('posts').doc(post.id).set(post.toMap());
  }

  Stream<List<PostModel>> getGroupPostsStream(String groupId) {
    return _db
        .collection('groups')
        .doc(groupId)
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PostModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> reactToPost(String postId, String userId, String emoji, String groupId) async {
    final postRef = _db.collection('groups').doc(groupId).collection('posts').doc(postId);
    await _db.runTransaction((transaction) async {
      final doc = await transaction.get(postRef);
      if (!doc.exists) return;
      
      final data = doc.data()!;
      Map<String, String> reactions = Map<String, String>.from(data['reactions'] ?? {});
      
      if (reactions.containsKey(userId) && reactions[userId] == emoji) {
        reactions.remove(userId);
      } else {
        reactions[userId] = emoji;
      }
      
      transaction.update(postRef, {'reactions': reactions});
    });
  }

  Future<void> sendHug(HugModel hug) async {
    await _db.collection('groups').doc(hug.groupId).collection('hugs').doc(hug.id).set(hug.toMap());
  }

  /// Returns the most recent hug sent from [fromUid] to [toUid] within the
  /// last hour, or null if no such hug exists. Used for the 1-hour cooldown.
  Future<HugModel?> getLastHugBetween(String groupId, String fromUid, String toUid) async {
    final query = await _db
        .collection('groups')
        .doc(groupId)
        .collection('hugs')
        .where('fromUid', isEqualTo: fromUid)
        .where('toUid', isEqualTo: toUid)
        .orderBy('sentAt', descending: true)
        .limit(5)
        .get();

    final oneHourAgo = DateTime.now().subtract(const Duration(hours: 1));

    for (final doc in query.docs) {
      final hug = HugModel.fromMap(doc.data(), doc.id);
      if (hug.sentAt.toDate().isAfter(oneHourAgo)) {
        return hug;
      }
    }
    return null;
  }

  /// Real-time stream of hugs received by [toUid] within the group,
  /// ordered by most recent first. Used to populate the "abraços recebidos" feed.
  Stream<List<HugModel>> getReceivedHugsStream(String groupId, String toUid) {
    return _db
        .collection('groups')
        .doc(groupId)
        .collection('hugs')
        .where('toUid', isEqualTo: toUid)
        .orderBy('sentAt', descending: true)
        .limit(20)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => HugModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<List<PostModel>> getUserPosts(String groupId, String authorId) async {
    if (groupId.isEmpty) return [];
    
    final query = await _db
        .collection('groups')
        .doc(groupId)
        .collection('posts')
        .where('authorId', isEqualTo: authorId)
        .orderBy('createdAt', descending: true)
        .get();

    return query.docs.map((doc) => PostModel.fromMap(doc.data(), doc.id)).toList();
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).update(data);
  }
}
