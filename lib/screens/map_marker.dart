class MapMarkerData {
  final String id; // Unique ID for Firestore document
  final double latitude;
  final double longitude;
  final String label;
  final String type; // e.g., "visited", "want_to_visit"
  final String userId; // To associate with a user

  MapMarkerData({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.label,
    required this.type,
    required this.userId,
  });

  // Convert object to JSON for Firestore
  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'label': label,
    'type': type,
    'userId': userId,
  };

  // Create object from Firestore JSON + document ID
  factory MapMarkerData.fromJson(Map<String, dynamic> json, String id) {
    return MapMarkerData(
      id: id,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      label: json['label'] as String,
      type: json['type'] as String,
      userId: json['userId'] as String,
    );
  }
}