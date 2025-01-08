import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Folder {
  final String id;
  final String name;
  final DateTime createdAt;
  Folder({
    required this.id,
    required this.name,
    required this.createdAt,
  });
  factory Folder.fromFirestore(Map<String, dynamic> data, String id) {
    return Folder(
      id: id,
      name: data['name'] ?? 'Untitled',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
  Map<String, dynamic> toMap() {
    //toMap: Converts the Folder instance into a Map so you can easily upload it to Firestore when creating or updating folders.
    return {
      'name': name,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

final folderProvider = StreamProvider<List<Folder>>((ref) {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) {
    return Stream.value([]);
  }
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('folders')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Folder.fromFirestore(doc.data(), doc.id))
          .toList());
});

Future<void> addFolder(String folderName) async {
  try {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return;
    }
    final newFolder = Folder(
      id: '',
      name: folderName,
      createdAt: DateTime.now(),
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('folders')
        .add(newFolder.toMap());
  } catch (e) {
    print('Error adding folder:$e');
  }
}
