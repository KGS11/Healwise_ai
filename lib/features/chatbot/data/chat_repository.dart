import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../domain/chat_message.dart';
import '../domain/chat_session.dart';

class ChatRepository {
  FirebaseFirestore get _db => FirebaseFirestore.instance;
  FirebaseAuth get _auth => FirebaseAuth.instance;

  String get _uid {
    final user = _auth.currentUser;
    if (user == null) {
      throw ChatRepositoryException('Please log in to save chat history.');
    }
    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> get _sessionsRef {
    return _db.collection('users').doc(_uid).collection('chatSessions');
  }

  // Creates a new chat session using the first user message as the title.
  Future<String> createSession(String firstMessage) async {
    final now = DateTime.now();
    final sessionId = 'session_${now.millisecondsSinceEpoch}';
    final title = _buildTitle(firstMessage);
    final session = ChatSession(
      sessionId: sessionId,
      title: title,
      createdAt: now,
      updatedAt: now,
      messageCount: 0,
    );

    try {
      debugPrint('[ChatRepository] Creating session: $sessionId');
      await _sessionsRef.doc(sessionId).set(session.toMap());
      return sessionId;
    } on FirebaseException catch (e) {
      debugPrint('[ChatRepository] createSession failed: ${e.message}');
      throw ChatRepositoryException(e.message ?? 'Could not create chat.');
    } catch (e) {
      debugPrint('[ChatRepository] createSession failed: $e');
      throw ChatRepositoryException('Could not create chat history.');
    }
  }

  // Updates session metadata after a message is saved.
  Future<void> updateSession(String sessionId) async {
    try {
      await _sessionsRef.doc(sessionId).update({
        'updatedAt': Timestamp.fromDate(DateTime.now()),
        'messageCount': FieldValue.increment(1),
      });
    } on FirebaseException catch (e) {
      debugPrint('[ChatRepository] updateSession failed: ${e.message}');
      throw ChatRepositoryException(e.message ?? 'Could not update chat.');
    } catch (e) {
      debugPrint('[ChatRepository] updateSession failed: $e');
      throw ChatRepositoryException('Could not update chat history.');
    }
  }

  // Streams recent chat sessions ordered by last activity.
  Stream<List<ChatSession>> getSessions() {
    return _sessionsRef
        .orderBy('updatedAt', descending: true)
        .limit(50)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ChatSession.fromFirestore(doc))
              .toList(),
        );
  }

  // Deletes one session and all message documents inside it.
  Future<void> deleteSession(String sessionId) async {
    try {
      debugPrint('[ChatRepository] Deleting session: $sessionId');
      final sessionDoc = _sessionsRef.doc(sessionId);
      final messages = await sessionDoc.collection('messages').get();
      final batch = _db.batch();

      for (final message in messages.docs) {
        batch.delete(message.reference);
      }
      batch.delete(sessionDoc);

      await batch.commit();
    } on FirebaseException catch (e) {
      debugPrint('[ChatRepository] deleteSession failed: ${e.message}');
      throw ChatRepositoryException(e.message ?? 'Could not delete chat.');
    } catch (e) {
      debugPrint('[ChatRepository] deleteSession failed: $e');
      throw ChatRepositoryException('Could not delete chat history.');
    }
  }

  // Saves one message inside a chat session.
  Future<void> saveMessage({
    required String sessionId,
    required ChatMessage message,
  }) async {
    final messageId =
        message.messageId ??
        'message_${message.timestamp.millisecondsSinceEpoch}';
    final messageWithIds = message.copyWith(
      id: messageId,
      messageId: messageId,
      sessionId: sessionId,
    );

    try {
      debugPrint('[ChatRepository] Saving message: $messageId');
      await _sessionsRef
          .doc(sessionId)
          .collection('messages')
          .doc(messageId)
          .set(messageWithIds.toMap());
    } on FirebaseException catch (e) {
      debugPrint('[ChatRepository] saveMessage failed: ${e.message}');
      throw ChatRepositoryException(e.message ?? 'Could not save message.');
    } catch (e) {
      debugPrint('[ChatRepository] saveMessage failed: $e');
      throw ChatRepositoryException('Could not save chat message.');
    }
  }

  // Loads all messages for a session in chronological order.
  Future<List<ChatMessage>> getMessages(String sessionId) async {
    try {
      final snapshot = await _sessionsRef
          .doc(sessionId)
          .collection('messages')
          .orderBy('timestamp')
          .get();

      return snapshot.docs
          .map((doc) => ChatMessage.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      debugPrint('[ChatRepository] getMessages failed: ${e.message}');
      throw ChatRepositoryException(e.message ?? 'Could not load messages.');
    } catch (e) {
      debugPrint('[ChatRepository] getMessages failed: $e');
      throw ChatRepositoryException('Could not load chat messages.');
    }
  }

  // Deletes every saved chat session for the current user.
  Future<void> clearAllHistory() async {
    try {
      final sessions = await _sessionsRef.get();
      for (final session in sessions.docs) {
        await deleteSession(session.id);
      }
    } on FirebaseException catch (e) {
      debugPrint('[ChatRepository] clearAllHistory failed: ${e.message}');
      throw ChatRepositoryException(e.message ?? 'Could not clear history.');
    } catch (e) {
      debugPrint('[ChatRepository] clearAllHistory failed: $e');
      throw ChatRepositoryException('Could not clear chat history.');
    }
  }

  String _buildTitle(String text) {
    final cleaned = text.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (cleaned.isEmpty) {
      return 'New wellness chat';
    }
    if (cleaned.length <= 40) {
      return cleaned;
    }
    return '${cleaned.substring(0, 40)}...';
  }
}

class ChatRepositoryException implements Exception {
  const ChatRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}
