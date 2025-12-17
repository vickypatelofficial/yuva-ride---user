import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:yuva_ride/models/place_suggestion_model.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/constatns.dart';

class MapService {
  GoogleMapController? mapController;

  // Initialize map controller
  void initController(GoogleMapController controller) {
    mapController = controller;
  }

  // ================== 📍 CURRENT LOCATION ==================

  /// Check & request permission
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }

    if (permission == LocationPermission.deniedForever) return false;

    return true;
  }

  /// Get current LatLng
  Future<LatLng?> getCurrentLatLng() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return null;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return LatLng(position.latitude, position.longitude);
  }

  /// Move camera to current location
  Future<void> moveToCurrentLocation() async {
    if (mapController == null) return;

    LatLng? latLng = await getCurrentLatLng();
    if (latLng == null) return;

    await mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: latLng,
          zoom: 16,
        ),
      ),
    );
  }

  /// Handle map tap & return tapped LatLng
  LatLng onMapTap(LatLng tappedLatLng) {
    return tappedLatLng;
  }

  Marker getTappedMarker(LatLng latLng) {
    return Marker(
      markerId: const MarkerId("tapped_location"),
      position: latLng,
      infoWindow: const InfoWindow(title: "Selected Location"),
    );
  }

  Future<void> moveCameraToTap(LatLng latLng) async {
    if (mapController == null) return;

    await mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: latLng,
          zoom: 16,
        ),
      ),
    );
  }

  // ---------------- MOVE CAMERA ----------------
  Future<void> moveCamera(LatLng latLng, {double zoom = 16}) async {
    if (mapController == null) return;

    await mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: zoom),
      ),
    );
  }

  // ---------------- CAMERA MOVE (CENTER PIN) ----------------
  LatLng onCameraMove(CameraPosition position) {
    return position.target;
  }

  /// 🔹 Create selected location marker
  Marker buildSelectedMarker(LatLng latLng) {
    return Marker(
      markerId: const MarkerId("selected_location"),
      position: latLng,
      infoWindow: const InfoWindow(title: "Selected Location"),
    );
  }

  // Resize PNG Marker
  Future<BitmapDescriptor> getResizedMarker(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final Uint8List bytes = data.buffer.asUint8List();

    final ui.Codec codec =
        await ui.instantiateImageCodec(bytes, targetWidth: width);
    final ui.FrameInfo fi = await codec.getNextFrame();

    final Uint8List resizedBytes =
        (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
            .buffer
            .asUint8List();

    // ignore: deprecated_member_use
    return BitmapDescriptor.fromBytes(resizedBytes);
  }

  // Load multiple markers (bikes / autos / cars)
  Future<Set<Marker>> loadVehicleMarkers() async {
    BitmapDescriptor bike =
        await getResizedMarker("assets/images/bike.png", 90);
    BitmapDescriptor auto =
        await getResizedMarker("assets/images/auto.png", 110);
    BitmapDescriptor car = await getResizedMarker("assets/images/car.png", 120);
    BitmapDescriptor pickup =
        await getResizedMarker("assets/images/pickup_icon.png", 120);

    return {
      // Bikes
      Marker(
          markerId: const MarkerId("bike1"),
          position: const LatLng(17.4065, 78.4772),
          icon: bike),
      Marker(
          markerId: const MarkerId("bike2"),
          position: const LatLng(17.4068, 78.4785),
          icon: bike),
      Marker(
          markerId: const MarkerId("bike3"),
          position: const LatLng(17.4072, 78.4769),
          icon: bike),

      // Autos
      Marker(
          markerId: const MarkerId("auto1"),
          position: const LatLng(17.4085, 78.4790),
          icon: auto),
      Marker(
          markerId: const MarkerId("auto2"),
          position: const LatLng(17.4079, 78.4775),
          icon: auto),

      // Cars
      Marker(
          markerId: const MarkerId("car1"),
          position: const LatLng(17.4048, 78.4740),
          icon: car),
      Marker(
          markerId: const MarkerId("car2"),
          position: const LatLng(17.4075, 78.4764),
          icon: car),

      //Pickup
      Marker(
        markerId: const MarkerId("pickup"),
        position: const LatLng(17.4054, 78.476),
        icon: pickup,
      ),
    };
  }

  // Advanced camera animation
  Future<void> runAdvancedCameraAnimation({LatLng? latlng}) async {
    //LatLng(17.401599313936217, 78.47910862416029)
    if (mapController == null) return;

    LatLng center = latlng ?? const LatLng(17.4065, 78.4772);

    await mapController!.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(
        target: center,
        zoom: 12,
        tilt: 0,
        bearing: 0,
      )),
    );
    await Future.delayed(const Duration(milliseconds: 300));

    await mapController!.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(
        target: center,
        zoom: 13.5,
        tilt: 45,
        bearing: 20,
      )),
    );
    await Future.delayed(const Duration(milliseconds: 300));

    await mapController!.animateCamera(
      CameraUpdate.newLatLng(const LatLng(17.4078, 78.4779)),
    );
    await Future.delayed(const Duration(milliseconds: 300));

    // Final TOP VIEW
    await mapController!.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(
        target: center,
        zoom: 15.5,
        tilt: 0,
        bearing: 0,
      )),
    );
  }

  /// 🔹 Convert LatLng → Address
  Future<String> getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

      if (placemarks.isEmpty) return "Unknown location";

      final p = placemarks.first;

      return "${p.name}, ${p.subLocality}, ${p.locality}, ${p.administrativeArea}, ${p.country}";
    } catch (e) {
      return "Unable to fetch address";
    }
  }

  final uuid = const Uuid();
  String _sessionToken = '';

  /// 🔍 Get place suggestions
  Future<List<PlaceSuggestion>> getLocationSuggestions(String input) async {
    if (input.isEmpty) return [];

    if (_sessionToken.isEmpty) {
      _sessionToken = uuid.v4();
    }

    try {
      const String baseURL =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json';

      final String request =
          '$baseURL?input=$input&key=${Constants.mapkey}&sessiontoken=$_sessionToken';

      if (kDebugMode) {
        debugPrint("Places API: $request");
      }

      final response = await http.get(Uri.parse(request));
      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        final List predictions = data['predictions'];
        return predictions.map((e) => PlaceSuggestion.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      debugPrint("Places Error: $e");
      return [];
    }
  }

  /// 🔁 Clear token after selection
  void resetSessionToken() {
    _sessionToken = '';
  }

  Future<LatLng?> getLatLngFromPlaceId(String placeId) async {
    try {
      const String baseURL =
          'https://maps.googleapis.com/maps/api/place/details/json';

      final String request =
          '$baseURL?place_id=$placeId&key=${Constants.mapkey}';

      final response = await http.get(Uri.parse(request));
      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == 'OK') {
        final location = data['result']['geometry']['location'];

        return LatLng(
          location['lat'],
          location['lng'],
        );
      }
    } catch (e) {
      debugPrint('PlaceId to LatLng error: $e');
    }
    return null;
  }

  final Map<MarkerId, Marker> _markers = {};
  final Map<PolylineId, Polyline> _polylines = {};

  /// Expose sets
  Set<Marker> get markers => _markers.values.toSet();
  Set<Polyline> get polylines => _polylines.values.toSet();

  // ===================== 📍 PICKUP MARKER =====================
  Future<void> addPickupMarker(LatLng latLng) async {
    final icon = await _getCustomMarker("assets/images/green_marker.png", 110);

    const markerId = MarkerId("pickup");

    _markers[markerId] = Marker(
      markerId: markerId,
      position: latLng,
      icon: icon,
      infoWindow: const InfoWindow(title: "Pickup Location"),
    );
  }

  Future<void> addDropMarker(LatLng latLng) async {
    final icon = await _getCustomMarker("assets/images/red_marker.png", 110);

    const markerId = MarkerId("drop");

    _markers[markerId] = Marker(
      markerId: markerId,
      position: latLng,
      icon: icon,
      infoWindow: const InfoWindow(title: "Drop Location"),
    );
  }

  Future<BitmapDescriptor> _getCustomMarker(String assetPath, int width) async {
    final ByteData data = await rootBundle.load(assetPath);
    final Uint8List bytes = data.buffer.asUint8List();

    final ui.Codec codec =
        await ui.instantiateImageCodec(bytes, targetWidth: width);
    final ui.FrameInfo fi = await codec.getNextFrame();

    final Uint8List resizedBytes =
        (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
            .buffer
            .asUint8List();

    return BitmapDescriptor.fromBytes(resizedBytes);
  }

  // ===================== 🧭 DRAW POLYLINE =====================
  void drawPolyline({
    required List<LatLng> points,
    Color color = AppColors.primaryColor,
    int width = 5,
  }) {
    const polylineId = PolylineId('route');

    _polylines[polylineId] = Polyline(
      polylineId: polylineId,
      points: points,
      color: color,
      width: width,
    );
  }

  // getRoute Polyline
  Future<List<LatLng>> getRoutePolyline(
    LatLng pickup,
    LatLng drop,
    String apiKey,
  ) async {
    final url = 'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${pickup.latitude},${pickup.longitude}'
        '&destination=${drop.latitude},${drop.longitude}'
        '&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['routes'].isEmpty) return [];

    final encoded = data['routes'][0]['overview_polyline']['points'];
    return decodePolyline(encoded);
  }

// decode polyline
  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      poly.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return poly;
  }

  // ===================== 🗑 CLEAR ROUTE =====================
  void clearRoute() {
    _polylines.clear();
  }

  // ===================== 🗑 CLEAR ALL =====================
  void clearAll() {
    _markers.clear();
    _polylines.clear();
  }
}
