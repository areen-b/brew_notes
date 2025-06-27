import 'dart:io';

class JournalEntry {
  final String title;
  final String address;
  final double rating;
  final List<String> notes;
  final String date;
  final File? imageFile;

  JournalEntry({
    required this.title,
    required this.address,
    required this.rating,
    required this.notes,
    required this.date,
    this.imageFile,
  });
}
