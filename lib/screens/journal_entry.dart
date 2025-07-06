import 'package:cloud_firestore/cloud_firestore.dart';

class JournalEntryData {
  final String id;
  final String title;
  final String address;
  final List<String> notes;
  final double rating;
  final String date;
  final String imageUrl;
  final String userId;

  JournalEntryData({
    required this.id,
    required this.title,
    required this.address,
    required this.notes,
    required this.rating,
    required this.date,
    required this.imageUrl,
    required this.userId,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'address': address,
    'notes': notes,
    'rating': rating,
    'date': date,
    'imageUrl': imageUrl,
    'userId': userId,
    'timestamp': FieldValue.serverTimestamp(),
  };

  factory JournalEntryData.fromJson(Map<String, dynamic> json, String id) {
    return JournalEntryData(
      id: id,
      title: json['title'] ?? '',
      address: json['address'] ?? '',
      notes: List<String>.from(json['notes'] ?? []),
      rating: (json['rating'] ?? 0).toDouble(),
      date: json['date'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      userId: json['userId'] ?? '',
    );
  }
}