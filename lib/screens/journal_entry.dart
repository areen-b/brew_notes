class JournalEntry {
  final String title;
  final String address;
  final double rating;
  final List<String> notes;
  final String imagePath;
  final String date;

  JournalEntry({
    required this.title,
    required this.address,
    required this.rating,
    required this.notes,
    required this.imagePath,
    required this.date,
  });
}
