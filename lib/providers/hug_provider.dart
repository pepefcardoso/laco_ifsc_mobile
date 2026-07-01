import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/hug_model.dart';
import '../core/services/firestore_service.dart';

class HugProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<HugModel> _receivedHugs = [];
  bool _isSending = false;
  String? _errorMessage;
  StreamSubscription? _hugsSubscription;

  List<HugModel> get receivedHugs => _receivedHugs;
  bool get isSending => _isSending;
  String? get errorMessage => _errorMessage;

  /// Start listening to hugs received by [userId] within the group.
  void loadReceivedHugs(String groupId, String userId) {
    _hugsSubscription?.cancel();
    _hugsSubscription = _firestoreService
        .getReceivedHugsStream(groupId, userId)
        .listen((hugs) {
      _receivedHugs = hugs;
      notifyListeners();
    }, onError: (e) {
      _errorMessage = 'Erro ao carregar abraços: $e';
      notifyListeners();
    });
  }

  /// Send a virtual hug from [fromUid] to [toUid].
  /// Returns `true` on success and `false` if cooldown is active or an error occurred.
  Future<bool> sendHug({
    required String fromUid,
    required String fromName,
    required String toUid,
    required String toName,
    required String groupId,
  }) async {
    _isSending = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Check 1-hour cooldown
      final lastHug = await _firestoreService.getLastHugBetween(groupId, fromUid, toUid);

      if (lastHug != null) {
        final sentAt = lastHug.sentAt.toDate();
        final cooldownEnd = sentAt.add(const Duration(hours: 1));
        final remaining = cooldownEnd.difference(DateTime.now());

        if (remaining.isNegative == false) {
          final minutes = remaining.inMinutes;
          _errorMessage = 'Aguarde ${minutes + 1} minuto${minutes == 0 ? '' : 's'} para enviar outro abraço para $toName.';
          _isSending = false;
          notifyListeners();
          return false;
        }
      }

      // Create and save hug
      final hugId = FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .collection('hugs')
          .doc()
          .id;

      final hug = HugModel(
        id: hugId,
        fromUid: fromUid,
        fromName: fromName,
        toUid: toUid,
        toName: toName,
        groupId: groupId,
        sentAt: Timestamp.now(),
      );

      await _firestoreService.sendHug(hug);

      _isSending = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isSending = false;
      _errorMessage = 'Erro ao enviar abraço: $e';
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _hugsSubscription?.cancel();
    super.dispose();
  }
}
