import 'package:cloud_firestore/cloud_firestore.dart';

import '../response/live_chat_response.dart';
import '../response/live_chat_user_details_response.dart';

class CloudFirestoreService {
  final FirebaseFirestore db;

  const CloudFirestoreService(this.db);

  Future<String> add(LiveChatResponse liveChatResponse, String userId) async {
    // Add a new document with a generated ID
    final data = liveChatResponse.toJson();
    final document = await db
        .collection('support_chat')
        .doc("customer")
        .collection("user_id")
        .doc(userId)
        .collection("messages")
        .add(data);
    return document.id;
  }

  Future<String> addUserDetails(
      LiveChatUserDetailsResponse liveChatUserDetailsResponse, String userId) async {
    // Initialize Firestore instance
    FirebaseFirestore db = FirebaseFirestore.instance;
    // Define the custom document ID
    String documentId = userId;
    // Create a reference to the document in the 'user_id' collection
    DocumentReference userDocRef = db
        .collection('support_chat')
        .doc("customer")
        .collection("user_id")
        .doc(documentId);
    // Convert the LiveChatUserDetailsResponse to JSON
    final data = liveChatUserDetailsResponse.toJson();

    DocumentReference messageDocRef =
        userDocRef; // Auto-generated ID

    try {
      await userDocRef.set(data);
      return userDocRef.id;
    } catch (e) {
      // Handle any errors that occur
      print("Error adding user details: $e");
      return "";
    }
  }

  // get all `user` collection's documents
  Stream<QuerySnapshot<Map<String, dynamic>>> getUsers(String userId) {
    return db
        .collection('support_chat')
        .doc("customer")
        .collection("user_id")
        .doc(userId)
        .collection("messages")
        .orderBy('createdAt', descending: false)
        .snapshots();
  }
}
