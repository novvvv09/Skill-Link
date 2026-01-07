import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create notification for event registration
  static Future<void> notifyEventRegistration({
    required String professorId,
    required String studentName,
    required String eventTitle,
    required String eventId,
  }) async {
    try {
      await _firestore.collection('notifications').add({
        'userId': professorId,
        'type': 'registration',
        'title': 'New Event Registration',
        'description': '$studentName registered for "$eventTitle"',
        'eventId': eventId,
        'unread': true,
        'createdAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      print('Error creating registration notification: $e');
    }
  }

  // Create notification for project submission
  static Future<void> notifyProjectSubmission({
    required String professorId,
    required String studentName,
    required String projectTitle,
    required String eventTitle,
    required String projectId,
  }) async {
    try {
      await _firestore.collection('notifications').add({
        'userId': professorId,
        'type': 'project',
        'title': 'New Project Submitted',
        'description': '$studentName submitted "$projectTitle" for $eventTitle',
        'projectId': projectId,
        'unread': true,
        'createdAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      print('Error creating project notification: $e');
    }
  }

  // Create notification for new event (notify all students)
  static Future<void> notifyNewEvent({
    required String eventTitle,
    required String professorName,
    required String eventId,
  }) async {
    try {
      // Get all student users
      final usersSnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'student')
          .get();

      final batch = _firestore.batch();

      for (var userDoc in usersSnapshot.docs) {
        final notifRef = _firestore.collection('notifications').doc();
        batch.set(notifRef, {
          'userId': userDoc.id,
          'type': 'event',
          'title': 'New Event Available',
          'description': '$professorName created "$eventTitle"',
          'eventId': eventId,
          'unread': true,
          'createdAt': Timestamp.fromDate(DateTime.now()),
        });
      }

      await batch.commit();
    } catch (e) {
      print('Error creating new event notifications: $e');
    }
  }

  // Create notification for event update
  static Future<void> notifyEventUpdate({
    required String eventId,
    required String eventTitle,
    required String updateMessage,
  }) async {
    try {
      // Get all students registered for this event
      final registrationsSnapshot = await _firestore
          .collection('events')
          .doc(eventId)
          .collection('registrations')
          .get();

      final batch = _firestore.batch();

      for (var regDoc in registrationsSnapshot.docs) {
        final notifRef = _firestore.collection('notifications').doc();
        batch.set(notifRef, {
          'userId': regDoc.id, // The document ID is the student's user ID
          'type': 'event',
          'title': 'Event Update',
          'description': '$updateMessage for "$eventTitle"',
          'eventId': eventId,
          'unread': true,
          'createdAt': Timestamp.fromDate(DateTime.now()),
        });
      }

      await batch.commit();
    } catch (e) {
      print('Error creating event update notifications: $e');
    }
  }

  // Create notification for event reminder (1 day before)
  static Future<void> notifyEventReminder({
    required String eventId,
    required String eventTitle,
    required DateTime eventDate,
  }) async {
    try {
      // Get all students registered for this event
      final registrationsSnapshot = await _firestore
          .collection('events')
          .doc(eventId)
          .collection('registrations')
          .get();

      final batch = _firestore.batch();

      for (var regDoc in registrationsSnapshot.docs) {
        final notifRef = _firestore.collection('notifications').doc();
        batch.set(notifRef, {
          'userId': regDoc.id,
          'type': 'event',
          'title': 'Event Reminder',
          'description': '"$eventTitle" starts tomorrow!',
          'eventId': eventId,
          'unread': true,
          'createdAt': Timestamp.fromDate(DateTime.now()),
        });
      }

      await batch.commit();
    } catch (e) {
      print('Error creating event reminder notifications: $e');
    }
  }

  // Create notification for milestone achievement (professor)
  static Future<void> notifyMilestone({
    required String professorId,
    required String title,
    required String description,
  }) async {
    try {
      await _firestore.collection('notifications').add({
        'userId': professorId,
        'type': 'milestone',
        'title': title,
        'description': description,
        'unread': true,
        'createdAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      print('Error creating milestone notification: $e');
    }
  }

  // Create notification for achievement (student)
  static Future<void> notifyAchievement({
    required String studentId,
    required String title,
    required String description,
  }) async {
    try {
      await _firestore.collection('notifications').add({
        'userId': studentId,
        'type': 'achievement',
        'title': title,
        'description': description,
        'unread': true,
        'createdAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      print('Error creating achievement notification: $e');
    }
  }

  // Get unread notification count
  static Future<int> getUnreadCount(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .where('unread', isEqualTo: true)
          .get();

      return snapshot.docs.length;
    } catch (e) {
      print('Error getting unread count: $e');
      return 0;
    }
  }
}
