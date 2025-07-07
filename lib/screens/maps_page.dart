import 'dart:ui' as ui;
import 'package:flutter/material.dart' hide SearchBar;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brew_notes/theme.dart';
import 'package:brew_notes/widgets.dart';
import 'package:brew_notes/screens/map_marker.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});
  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  final _searchController = TextEditingController();
  final _initialPosition = const LatLng(34.0572, -117.8217);
  GoogleMapController? _mapController;
  Set<Marker> _uiMarkers = {};
  BitmapDescriptor? _coffeeIcon;
  BitmapDescriptor? _heartIcon;

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User? _currentUser;
  bool _isLoadingMarkers = true;
  final _markersCollection = 'map_markers_v2';
  int _selectedIndex = 0;

  Map<String, ({String firestoreId, String emoji})> _markerInfo = {};

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    _auth.authStateChanges().listen((user) {
      setState(() => _currentUser = user);
      if (user != null) _loadEmojiMarkers().then((_) => _loadMarkers());
      else _clearMarkers();
    });
    _loadEmojiMarkers();
    if (_currentUser != null) _loadMarkers();
    else _showLoginPromptIfNeeded();
  }

  Future<void> _loadEmojiMarkers() async {
    if (_coffeeIcon != null && _heartIcon != null) return;
    _coffeeIcon = await _emojiToBitmapDescriptor("☕️");
    _heartIcon = await _emojiToBitmapDescriptor("🤎");
    if (mounted) setState(() {});
  }

  Future<BitmapDescriptor> _emojiToBitmapDescriptor(String emoji) async {
    const size = 150.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final tp = TextPainter(
      text: TextSpan(text: emoji, style: const TextStyle(fontSize: 120)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset((size - tp.width) / 2, (size - tp.height) / 2));
    final image = await recorder.endRecording().toImage(size.toInt(), size.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  void _clearMarkers() {
    setState(() {
      _uiMarkers.clear();
      _markerInfo.clear();
      _isLoadingMarkers = false;
    });
  }

  void _showLoginPromptIfNeeded() {
    if (_currentUser == null && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please log in to save and see your markers.'),
          duration: Duration(seconds: 5),
        ));
      });
    }
  }

  Future<void> _loadMarkers() async {
    if (_currentUser == null || _coffeeIcon == null || _heartIcon == null) return;
    setState(() => _isLoadingMarkers = true);
    try {
      final snapshot = await _firestore
          .collection(_markersCollection)
          .where('userId', isEqualTo: _currentUser!.uid)
          .orderBy('createdAt', descending: true)
          .limit(100)
          .get();

      final newUiMarkers = <Marker>{};
      final newMarkerInfo = <String, ({String firestoreId, String emoji})>{};

      for (var doc in snapshot.docs) {
        final data = MapMarkerData.fromJson(doc.data() as Map<String, dynamic>, doc.id);
        final emoji = data.type == "visited" ? "☕️" : "🤎";
        final icon = data.type == "visited" ? _coffeeIcon! : _heartIcon!;
        final markerId = MarkerId(data.id);

        newUiMarkers.add(Marker(
          markerId: markerId,
          position: LatLng(data.latitude, data.longitude),
          icon: icon,
          infoWindow: InfoWindow(title: "$emoji ${data.label}"),
          onTap: () => _showMarkerOptions(markerId, data.label, LatLng(data.latitude, data.longitude)),
        ));
        newMarkerInfo[markerId.value] = (firestoreId: data.id, emoji: emoji);
      }

      if (mounted) {
        setState(() {
          _uiMarkers = newUiMarkers;
          _markerInfo = newMarkerInfo;
          _isLoadingMarkers = false;
        });
      }
    } catch (e) {
      print("❌ Error loading markers: $e");
      if (mounted) {
        setState(() => _isLoadingMarkers = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading markers: ${e.toString()}")),
        );
      }
    }
  }

  void _showMarkerOptions(MarkerId markerId, String label, LatLng position) {
    final info = _markerInfo[markerId.value];
    if (info == null) return;
    final isVisited = info.emoji == "☕️";
    final firestoreId = info.firestoreId;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit Marker"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                final newEmoji = isVisited ? "🤎" : "☕️";
                _saveMarker(label: label, position: position, emoji: newEmoji, overwriteId: firestoreId);
              },
              child: Text(isVisited ? "🤎 Mark as Want to Visit" : "☕️ Mark as Visited"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteMarkerFromFirestore(firestoreId, markerId);
              },
              child: const Text("🗑 Delete Marker", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }

  void _showVisitedList() {
    final visited = _uiMarkers.where((m) => _markerInfo[m.markerId.value]?.emoji == "☕️").toList();
    _showMarkerListDialog("☕️ Places Visited", visited);
  }

  void _showWantToVisitList() {
    final wantToVisit = _uiMarkers.where((m) => _markerInfo[m.markerId.value]?.emoji == "🤎").toList();
    _showMarkerListDialog("🤎 Want to Visit", wantToVisit);
  }

  void _showMarkerListDialog(String title, List<Marker> markers) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: markers.length,
            itemBuilder: (_, i) {
              final marker = markers[i];
              return ListTile(
                title: Text(marker.infoWindow.title ?? "No label"),
                onTap: () {
                  Navigator.of(context).pop();
                  _mapController?.animateCamera(CameraUpdate.newLatLngZoom(marker.position, 15));
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _saveMarker({
    required String label,
    required LatLng position,
    required String emoji,
    String? overwriteId,
  }) async {
    final docId = overwriteId ?? _firestore.collection(_markersCollection).doc().id;
    final markerData = MapMarkerData(
      id: docId,
      label: label,
      latitude: position.latitude,
      longitude: position.longitude,
      type: emoji == "☕️" ? "visited" : "want_to_visit",
      userId: _currentUser!.uid,
    );
    await _firestore.collection(_markersCollection).doc(docId).set({
      ...markerData.toJson(),
      'createdAt': Timestamp.now()
    });

    final markerId = MarkerId(docId);
    final icon = emoji == "☕️" ? _coffeeIcon! : _heartIcon!;

    setState(() {
      _uiMarkers.removeWhere((m) => m.markerId == markerId);
      _uiMarkers.add(Marker(
        markerId: markerId,
        position: position,
        icon: icon,
        infoWindow: InfoWindow(title: "$emoji $label"),
        onTap: () => _showMarkerOptions(markerId, label, position),
      ));
      _markerInfo[markerId.value] = (firestoreId: docId, emoji: emoji);
    });
  }

  Future<void> _searchAndMoveMap(String query) async {
    if (query.isEmpty || _mapController == null) return;
    try {
      final locations = await locationFromAddress(query);
      if (locations.isEmpty) return;
      final loc = locations.first;
      final position = LatLng(loc.latitude, loc.longitude);
      _mapController!.animateCamera(CameraUpdate.newLatLngZoom(position, 15));

      final markerId = MarkerId("search_${position.latitude}_${position.longitude}");
      setState(() {
        _uiMarkers.removeWhere((m) => m.markerId.value.startsWith("search_"));
        _uiMarkers.add(Marker(
          markerId: markerId,
          position: position,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: InfoWindow(title: 'Add "$query"?'),
          onTap: () => _promptEmojiChoice(query, position),
        ));
      });
    } catch (_) {
      _showAlert("Search Failed", "Could not find location.");
    }
  }

  void _promptEmojiChoice(String label, LatLng position) {
    if (_currentUser == null) return _showLoginPromptIfNeeded();
    showDialog(
      context: context,
      builder: (_) => EmojiChoiceDialog(onSelect: (emoji) {
        _saveMarker(label: label, position: position, emoji: emoji);
        Navigator.pop(context);
      }),
    );
  }

  void _deleteMarkerFromFirestore(String firestoreId, MarkerId markerId) async {
    try {
      await _firestore.collection(_markersCollection).doc(firestoreId).delete();
      setState(() {
        _uiMarkers.removeWhere((m) => m.markerId == markerId);
        _markerInfo.remove(markerId.value);
      });
    } catch (_) {
      _showAlert("Delete Failed", "Could not delete marker.");
    }
  }

  void _promptEmojiChoiceFromLongPress(LatLng pos) async {
    String label = 'Pinned Location';
    try {
      final placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      final place = placemarks.first;
      label = '${place.name ?? ''}, ${place.locality ?? ''}'.trim();
    } catch (_) {}
    _promptEmojiChoice(label, pos);
  }

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);
    Future.delayed(const Duration(milliseconds: 50), () {
      if (!mounted) return;
      switch (index) {
        case 1: Navigator.pushNamed(context, '/gallery'); break;
        case 2: Navigator.pushNamed(context, '/journal'); break;
        case 3: Navigator.pushNamed(context, '/profile'); break;
      }
    });
  }

  void _showAlert(String title, String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.latteFoam(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            Row(children: [
              Expanded(child: SearchBar(controller: _searchController, onSearch: _searchAndMoveMap)),
              const SizedBox(width: 20),
              Row(children: [HomeButton(), ThemeToggleButton(iconColor: AppColors.brown(context))]),
            ]),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.shadow(context),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _showVisitedList,
                  child: Text("☕️ Places Visited", style: TextStyle(color: AppColors.brown(context))),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.shadow(context),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _showWantToVisitList,
                  child: Text("🤎 Want to Visit", style: TextStyle(color: AppColors.brown(context))),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isLoadingMarkers)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 14),
                    onMapCreated: (controller) => _mapController = controller,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    markers: _uiMarkers,
                    onLongPress: _promptEmojiChoiceFromLongPress,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            NavBar(currentIndex: _selectedIndex, onTap: _onNavTap),
          ]),
        ),
      ),
    );
  }
}
class EmojiChoiceDialog extends StatelessWidget {
  final void Function(String emoji) onSelect;

  const EmojiChoiceDialog({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Select a Marker Type"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () => onSelect("☕️"),
            child: const Text("☕️ Visited"),
          ),
          TextButton(
            onPressed: () => onSelect("🤎"),
            child: const Text("🤎 Want to Visit"),
          ),
        ],
      ),
    );
  }
}
class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onSearch;

  const SearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onSubmitted: onSearch,
      decoration: InputDecoration(
        hintText: 'Search location...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: AppColors.latteFoam(context),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.brown(context)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.primary(context), width: 2.5),
        ),
      ),
    );
  }
}
