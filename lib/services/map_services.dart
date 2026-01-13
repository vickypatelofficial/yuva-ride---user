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
import 'package:uuid/uuid.dart';
import 'package:yuva_ride/models/place_suggestion_model.dart';
import 'package:yuva_ride/provider/book_ride_provider.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/constatns.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapService {
  GoogleMapController? mapController;

  // map elements
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  // pickup & drop icons
  BitmapDescriptor? startLocation;
  BitmapDescriptor? endLocation;
  BitmapDescriptor? pickupLocation;

  // initialize controller
  void  initController(GoogleMapController controller) {
    mapController = controller;
  }

// ================== 📍 CURRENT LOCATION ==================

  /// Check & request permission
  static Future<bool> _handleLocationPermission() async {
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

  Future<void> addMarker({
    required String markerId,
    required LatLng position,
    String? iconPath,
    int iconSize = 80,
  }) async {
    BitmapDescriptor icon;

    if (iconPath != null) {
      icon = await getResizedMarker(iconPath, iconSize);
    } else {
      icon = BitmapDescriptor.defaultMarker;
    }

    markers.add(
      Marker(
        markerId: MarkerId(markerId),
        position: position,
        icon: icon,
        anchor: const Offset(0.5, 1.0),
      ),
    );
  }

  void clearAllMarkers() {
    markers.clear();
  }

  void clearMap() {
    markers.clear();
    polylines.clear();
  }

  /// Get current LatLng
  static Future<LatLng?> getCurrentLatLng() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return null;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return LatLng(position.latitude, position.longitude);
  }

  // resize marker
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

    return BitmapDescriptor.fromBytes(resizedBytes);
  }

  // load pickup & drop icons
  Future<void> loadMapIcons(
      {String? startLocationIcon, String? endLocationIcon}) async {
    startLocation = await getResizedMarker(
        startLocationIcon ?? "assets/images/pickup_location.png", 110);
    endLocation = await getResizedMarker(
        endLocationIcon ?? "assets/images/drop_location.png", 110);
  }

    
   Future<void> loadPickup({String? icon}) async {
    pickupLocation = await getResizedMarker(
      icon??  "assets/images/pickup_location.png", 110); 
  }

  // add pickup & drop markers
  void setPickupDropMarkers({
    required LatLng pickup,
    required LatLng drop,
  }) {
    markers = {
      Marker(
        markerId: const MarkerId("start"),
        position: pickup,
        icon: startLocation ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        anchor: const Offset(
            0.5, 1.0), // FIX: bottom center of image touches map point
      ),
      Marker(
        markerId: const MarkerId("end"),
        position: drop,
        icon: endLocation ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        anchor: const Offset(0.5, 1.0), // FIX
      ),
    };
  }

  // set drop marker
  void setDropMarker({
    required LatLng drop,
  }) {
    markers = {
      Marker(
        markerId: const MarkerId("end"),
        position: drop,
        icon: endLocation ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        anchor: const Offset(0.5, 1.0), // FIX
      ),
    };
  }

      // set pickup marker
   setPickupMarker({
    required LatLng pickup,
  }) async{
    markers = {
      Marker(
        markerId: const MarkerId("start"),
        position: pickup,
        icon: pickupLocation ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        anchor: const Offset(0.5, 1.0), // FIX
      ),
    };
  }

  // add polyline route
  Future createRoutePolyline(List<LatLng> routePoints) async {
    if (routePoints.length >= 2) {
      final points = await getRoutePolyline(
          routePoints[0], routePoints[1], Constants.mapkey);
      polylines = {
        Polyline(
          polylineId: const PolylineId("route"),
          color: AppColors.black,
          width: 5,
          points: points,
        )
      };
    }
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

  // move camera to pickup
  Future<void> animateToPickup(LatLng loc) async {
    if (mapController == null) return;
    await mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: loc, zoom: 14.5),
      ),
    );
  }

  // move camera to include both pickup & drop
  Future<void> fitToPickupDrop(LatLng pickup, LatLng drop) async {
    if (mapController == null) return;

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
          pickup.latitude < drop.latitude ? pickup.latitude : drop.latitude,
          pickup.longitude < drop.longitude
              ? pickup.longitude
              : drop.longitude),
      northeast: LatLng(
          pickup.latitude > drop.latitude ? pickup.latitude : drop.latitude,
          pickup.longitude > drop.longitude
              ? pickup.longitude
              : drop.longitude),
    );

    await Future.delayed(const Duration(milliseconds: 300));

    await mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 70),
    );
  }

  // Advanced camera animation
  Future<void> runAdvancedCameraAnimation() async {
    if (mapController == null) return;

    const LatLng center = LatLng(17.4486, 78.3908);

    await mapController!.animateCamera(
      CameraUpdate.newCameraPosition(const CameraPosition(
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
    // await Future.delayed(const Duration(milliseconds: 300));

    // await mapController!.animateCamera(
    //   CameraUpdate.newLatLng(const LatLng(17.4078, 78.4779)),
    // );
    await Future.delayed(const Duration(milliseconds: 300));

    // Final TOP VIEW
    await mapController!.animateCamera(
      CameraUpdate.newCameraPosition(const CameraPosition(
        target: center,
        zoom: 15.5,
        tilt: 0,
        bearing: 0,
      )),
    );
  }

  // Advanced camera animation
  Future<void> moreIconCamereraAnimation() async {
    if (mapController == null) return;

    const LatLng center = LatLng(17.408151707455986, 78.4787243977189);

    await mapController!.animateCamera(
      CameraUpdate.newCameraPosition(const CameraPosition(
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
    // await Future.delayed(const Duration(milliseconds: 300));

    // await mapController!.animateCamera(
    //   CameraUpdate.newLatLng(const LatLng(17.4078, 78.4779)),
    // );
    await Future.delayed(const Duration(milliseconds: 300));

    // Final TOP VIEW
    await mapController!.animateCamera(
      CameraUpdate.newCameraPosition(const CameraPosition(
        target: center,
        zoom: 15.5,
        tilt: 0,
        bearing: 0,
      )),
    );
  }

  Future<void> openGoogleMaps({
    required double pickupLat,
    required double pickupLng,
    required double dropLat,
    required double dropLng,
  }) async {
    final Uri googleUrl = Uri.parse(
      "https://www.google.com/maps/dir/?api=1"
      "&origin=$pickupLat,$pickupLng"
      "&destination=$dropLat,$dropLng"
      "&travelmode=driving",
    );

    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open Google Maps';
    }
  }

  static LatLng? parseLatLngSafe(String? value) {
    try {
      if (value == null || value.trim().isEmpty) {
        return null;
      }

      final parts = value.split('&!');

      if (parts.length != 2) {
        return null;
      }

      final lat = double.tryParse(parts[0].trim());
      final lng = double.tryParse(parts[1].trim());

      if (lat == null || lng == null) {
        return null;
      }

      return LatLng(lat, lng);
    } catch (e) {
      // Optional: log error
      debugPrint("LatLng parse error: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>> getDistanceAndTime(
    LatLng origin,
    LatLng destination,
  ) async {
    const apiKey = Constants.mapkey;

    final url = "https://maps.googleapis.com/maps/api/directions/json"
        "?origin=${origin.latitude},${origin.longitude}"
        "&destination=${destination.latitude},${destination.longitude}"
        "&key=$apiKey";

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['routes'].isEmpty) return {};

    final leg = data['routes'][0]['legs'][0];

    return {
      "distance_km": leg['distance']['value'] / 1000, // meters → km
      "duration_min": leg['duration']['value'] / 60, // seconds → min
    };
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

    // ignore: deprecated_member_use
    return BitmapDescriptor.fromBytes(resizedBytes);
  }

  Future<void> setupRoute({
    required LatLng pickup,
    required LatLng drop,
  }) async {
    markers.clear();
    polylines.clear();
    // return;

    markers.add(
      Marker(
        markerId: const MarkerId('pickup'),
        position: pickup,
        icon: startLocation ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );

    markers.add(
      Marker(
        markerId: const MarkerId('drop'),
        position: drop,
        icon: endLocation ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );

    final points = await getRoutePolyline(pickup, drop, Constants.mapkey);

    if (points.isNotEmpty) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: points,
          width: 5,
          color: AppColors.primaryColor,
        ),
      );
    }

    await fitToPickupDrop(pickup, drop);
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

  /// 🔹 Convert LatLng → Address
  static Future<LocationModel?> getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

      if (placemarks.isEmpty) {
        return LocationModel(latLng, '', title: '', subtitle: '');
      }

      final p = placemarks.first;

      "${p.name}, ${p.subLocality}, ${p.locality}, ${p.administrativeArea}, ${p.country}";
      return LocationModel(latLng,
          "${p.name}, ${p.subLocality}, ${p.locality}, ${p.administrativeArea}, ${p.country}",
          title: '${p.name}, ${p.subLocality}, ${p.locality}',
          subtitle: '${p.administrativeArea}, ${p.country}');
    } catch (e) {
      print(e.toString());
    }
    return null;
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

  /// 🔹 Create selected location marker
  Marker buildSelectedMarker(LatLng latLng) {
    return Marker(
      markerId: const MarkerId("selected_location"),
      position: latLng,
      infoWindow: const InfoWindow(title: "Selected Location"),
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
  static LatLng onCameraMove(CameraPosition position) {
    return position.target;
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
      print('===========suggestions=========');
      print(data.toString());

      if (response.statusCode == 200) {
        final List predictions = data['predictions'];
        return predictions.map((e) => PlaceSuggestion.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      debugPrint("Places Error: $e");
      return []; //
    }
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

  /// 🔁 Clear token after selection
  void resetSessionToken() {
    _sessionToken = '';
  }
}


// class MapService {
//   GoogleMapController? mapController;

//   // Initialize map controller
//   void initController(GoogleMapController controller) {
//     mapController = controller;
//   }

//   // ================== 📍 CURRENT LOCATION ==================

//   /// Check & request permission
//   Future<bool> _handleLocationPermission() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) return false;

//     LocationPermission permission = await Geolocator.checkPermission();

//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) return false;
//     }

//     if (permission == LocationPermission.deniedForever) return false;

//     return true;
//   }

//   /// Get current LatLng
//   Future<LatLng?> getCurrentLatLng() async {
//     final hasPermission = await _handleLocationPermission();
//     if (!hasPermission) return null;

//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );

//     return LatLng(position.latitude, position.longitude);
//   }

//   /// Move camera to current location
//   Future<void> moveToCurrentLocation() async {
//     if (mapController == null) return;

//     LatLng? latLng = await getCurrentLatLng();
//     if (latLng == null) return;

//     await mapController!.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(
//           target: latLng,
//           zoom: 16,
//         ),
//       ),
//     );
//   }

//   /// Handle map tap & return tapped LatLng
//   LatLng onMapTap(LatLng tappedLatLng) {
//     return tappedLatLng;
//   }

//   Marker getTappedMarker(LatLng latLng) {
//     return Marker(
//       markerId: const MarkerId("tapped_location"),
//       position: latLng,
//       infoWindow: const InfoWindow(title: "Selected Location"),
//     );
//   }

  // Future<void> moveCameraToTap(LatLng latLng) async {
  //   if (mapController == null) return;

  //   await mapController!.animateCamera(
  //     CameraUpdate.newCameraPosition(
  //       CameraPosition(
  //         target: latLng,
  //         zoom: 16,
  //       ),
  //     ),
  //   );
  // }

  // // ---------------- MOVE CAMERA ----------------
  // Future<void> moveCamera(LatLng latLng, {double zoom = 16}) async {
  //   if (mapController == null) return;

  //   await mapController!.animateCamera(
  //     CameraUpdate.newCameraPosition(
  //       CameraPosition(target: latLng, zoom: zoom),
  //     ),
  //   );
  // }

  // // ---------------- CAMERA MOVE (CENTER PIN) ----------------
  // LatLng onCameraMove(CameraPosition position) {
  //   return position.target;
  // }

  // /// 🔹 Create selected location marker
  // Marker buildSelectedMarker(LatLng latLng) {
  //   return Marker(
  //     markerId: const MarkerId("selected_location"),
  //     position: latLng,
  //     infoWindow: const InfoWindow(title: "Selected Location"),
  //   );
  // }

  // Resize PNG Marker
  // Future<BitmapDescriptor> getResizedMarker(String path, int width) async {
  //   final ByteData data = await rootBundle.load(path);
  //   final Uint8List bytes = data.buffer.asUint8List();

  //   final ui.Codec codec =
  //       await ui.instantiateImageCodec(bytes, targetWidth: width);
  //   final ui.FrameInfo fi = await codec.getNextFrame();

  //   final Uint8List resizedBytes =
  //       (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
  //           .buffer
  //           .asUint8List();

  //   // ignore: deprecated_member_use
  //   return BitmapDescriptor.fromBytes(resizedBytes);
  // }

  // // Load multiple markers (bikes / autos / cars)
  // Future<Set<Marker>> loadVehicleMarkers() async {
  //   BitmapDescriptor bike =
  //       await getResizedMarker("assets/images/bike.png", 90);
  //   BitmapDescriptor auto =
  //       await getResizedMarker("assets/images/auto.png", 110);
  //   BitmapDescriptor car = await getResizedMarker("assets/images/car.png", 120);
  //   BitmapDescriptor pickup =
  //       await getResizedMarker("assets/images/pickup_icon.png", 120);

  //   return {
  //     // Bikes
  //     Marker(
  //         markerId: const MarkerId("bike1"),
  //         position: const LatLng(17.4065, 78.4772),
  //         icon: bike),
  //     Marker(
  //         markerId: const MarkerId("bike2"),
  //         position: const LatLng(17.4068, 78.4785),
  //         icon: bike),
  //     Marker(
  //         markerId: const MarkerId("bike3"),
  //         position: const LatLng(17.4072, 78.4769),
  //         icon: bike),

  //     // Autos
  //     Marker(
  //         markerId: const MarkerId("auto1"),
  //         position: const LatLng(17.4085, 78.4790),
  //         icon: auto),
  //     Marker(
  //         markerId: const MarkerId("auto2"),
  //         position: const LatLng(17.4079, 78.4775),
  //         icon: auto),

  //     // Cars
  //     Marker(
  //         markerId: const MarkerId("car1"),
  //         position: const LatLng(17.4048, 78.4740),
  //         icon: car),
  //     Marker(
  //         markerId: const MarkerId("car2"),
  //         position: const LatLng(17.4075, 78.4764),
  //         icon: car),

  //     //Pickup
  //     Marker(
  //       markerId: const MarkerId("pickup"),
  //       position: const LatLng(17.4054, 78.476),
  //       icon: pickup,
  //     ),
  //   };
  // }

//   // Advanced camera animation
//   Future<void> runAdvancedCameraAnimation({LatLng? latlng}) async {
//     //LatLng(17.401599313936217, 78.47910862416029)
//     if (mapController == null) return;

//     LatLng center = latlng ?? const LatLng(17.4065, 78.4772);

//     await mapController!.animateCamera(
//       CameraUpdate.newCameraPosition(CameraPosition(
//         target: center,
//         zoom: 12,
//         tilt: 0,
//         bearing: 0,
//       )),
//     );
//     await Future.delayed(const Duration(milliseconds: 300));

//     await mapController!.animateCamera(
//       CameraUpdate.newCameraPosition(CameraPosition(
//         target: center,
//         zoom: 13.5,
//         tilt: 45,
//         bearing: 20,
//       )),
//     );
//     await Future.delayed(const Duration(milliseconds: 300));

//     await mapController!.animateCamera(
//       CameraUpdate.newLatLng(const LatLng(17.4078, 78.4779)),
//     );
//     await Future.delayed(const Duration(milliseconds: 300));

//     // Final TOP VIEW
//     await mapController!.animateCamera(
//       CameraUpdate.newCameraPosition(CameraPosition(
//         target: center,
//         zoom: 15.5,
//         tilt: 0,
//         bearing: 0,
//       )),
//     );
//   }

  // /// 🔹 Convert LatLng → Address
  // Future<LocationModel?> getAddressFromLatLng(LatLng latLng) async {
  //   try {
  //     List<Placemark> placemarks =
  //         await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

  //     if (placemarks.isEmpty) {
  //       return LocationModel(latLng, '', title: '', subtitle: '');
  //     }

  //     final p = placemarks.first;

  //     "${p.name}, ${p.subLocality}, ${p.locality}, ${p.administrativeArea}, ${p.country}";
  //     return LocationModel(latLng,
  //         "${p.name}, ${p.subLocality}, ${p.locality}, ${p.administrativeArea}, ${p.country}",
  //         title: p.locality ?? '', subtitle: p.subLocality ?? '');
  //   } catch (e) {
  //     print(e.toString());
  //   }
  //   return null;
  // }

  // final uuid = const Uuid();
  // String _sessionToken = '';

  // /// 🔍 Get place suggestions
  // Future<List<PlaceSuggestion>> getLocationSuggestions(String input) async {
  //   if (input.isEmpty) return [];

  //   if (_sessionToken.isEmpty) {
  //     _sessionToken = uuid.v4();
  //   }

  //   try {
  //     const String baseURL =
  //         'https://maps.googleapis.com/maps/api/place/autocomplete/json';

  //     final String request =
  //         '$baseURL?input=$input&key=${Constants.mapkey}&sessiontoken=$_sessionToken';

  //     if (kDebugMode) {
  //       debugPrint("Places API: $request");
  //     }

  //     final response = await http.get(Uri.parse(request));
  //     final data = json.decode(response.body);

  //     if (response.statusCode == 200) {
  //       final List predictions = data['predictions'];
  //       return predictions.map((e) => PlaceSuggestion.fromJson(e)).toList();
  //     } else {
  //       return [];
  //     }
  //   } catch (e) {
  //     debugPrint("Places Error: $e");
  //     return [];
  //   }
  // }

  // /// 🔁 Clear token after selection
  // void resetSessionToken() {
  //   _sessionToken = '';
  // }

  // Future<LatLng?> getLatLngFromPlaceId(String placeId) async {
  //   try {
  //     const String baseURL =
  //         'https://maps.googleapis.com/maps/api/place/details/json';

  //     final String request =
  //         '$baseURL?place_id=$placeId&key=${Constants.mapkey}';

  //     final response = await http.get(Uri.parse(request));
  //     final data = json.decode(response.body);

  //     if (response.statusCode == 200 && data['status'] == 'OK') {
  //       final location = data['result']['geometry']['location'];

  //       return LatLng(
  //         location['lat'],
  //         location['lng'],
  //       );
  //     }
  //   } catch (e) {
  //     debugPrint('PlaceId to LatLng error: $e');
  //   }
  //   return null;
  // }

//   final Map<MarkerId, Marker> _markers = {};
//   final Map<PolylineId, Polyline> _polylines = {};

//   /// Expose sets
//   Set<Marker> get markers => _markers.values.toSet();
//   Set<Polyline> get polylines => _polylines.values.toSet();

//   // ===================== 📍 PICKUP MARKER =====================
//   Future<void> addPickupMarker(LatLng latLng) async {
//     final icon = await _getCustomMarker("assets/images/green_marker.png", 110);

//     const markerId = MarkerId("pickup");

//     _markers[markerId] = Marker(
//       markerId: markerId,
//       position: latLng,
//       icon: icon,
//       infoWindow: const InfoWindow(title: "Pickup Location"),
//     );
//   }

//   Future<void> addDropMarker(LatLng latLng) async {
//     final icon = await _getCustomMarker("assets/images/red_marker.png", 110);

//     const markerId = MarkerId("drop");

//     _markers[markerId] = Marker(
//       markerId: markerId,
//       position: latLng,
//       icon: icon,
//       infoWindow: const InfoWindow(title: "Drop Location"),
//     );
//   }

  // Future<BitmapDescriptor> _getCustomMarker(String assetPath, int width) async {
  //   final ByteData data = await rootBundle.load(assetPath);
  //   final Uint8List bytes = data.buffer.asUint8List();

  //   final ui.Codec codec =
  //       await ui.instantiateImageCodec(bytes, targetWidth: width);
  //   final ui.FrameInfo fi = await codec.getNextFrame();

  //   final Uint8List resizedBytes =
  //       (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
  //           .buffer
  //           .asUint8List();

  //   // ignore: deprecated_member_use
  //   return BitmapDescriptor.fromBytes(resizedBytes);
  // }

//   // ===================== 🧭 DRAW POLYLINE =====================
//   void drawPolyline({
//     required List<LatLng> points,
//     Color color = AppColors.primaryColor,
//     int width = 5,
//   }) {
//     const polylineId = PolylineId('route');

//     _polylines[polylineId] = Polyline(
//       polylineId: polylineId,
//       points: points,
//       color: color,
//       width: width,
//     );
//   }

//   // getRoute Polyline
//   Future<List<LatLng>> getRoutePolyline(
//     LatLng pickup,
//     LatLng drop,
//     String apiKey,
//   ) async {
//     final url = 'https://maps.googleapis.com/maps/api/directions/json'
//         '?origin=${pickup.latitude},${pickup.longitude}'
//         '&destination=${drop.latitude},${drop.longitude}'
//         '&key=$apiKey';

//     final response = await http.get(Uri.parse(url));
//     final data = json.decode(response.body);

//     if (data['routes'].isEmpty) return [];

//     final encoded = data['routes'][0]['overview_polyline']['points'];
//     return decodePolyline(encoded);
//   }

// // decode polyline
//   List<LatLng> decodePolyline(String encoded) {
//     List<LatLng> poly = [];
//     int index = 0, len = encoded.length;
//     int lat = 0, lng = 0;

//     while (index < len) {
//       int b, shift = 0, result = 0;
//       do {
//         b = encoded.codeUnitAt(index++) - 63;
//         result |= (b & 0x1f) << shift;
//         shift += 5;
//       } while (b >= 0x20);
//       int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
//       lat += dlat;

//       shift = 0;
//       result = 0;
//       do {
//         b = encoded.codeUnitAt(index++) - 63;
//         result |= (b & 0x1f) << shift;
//         shift += 5;
//       } while (b >= 0x20);
//       int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
//       lng += dlng;

//       poly.add(LatLng(lat / 1E5, lng / 1E5));
//     }
//     return poly;
//   }

//   // ===================== 🗑 CLEAR ROUTE =====================
//   void clearRoute() {
//     _polylines.clear();
//   }

//   // ===================== 🗑 CLEAR ALL =====================
//   void clearAll() {
//     _markers.clear();
//     _polylines.clear();
//   }

//  static Future<Map<String, dynamic>> getDistanceAndTime(
//     LatLng origin,
//     LatLng destination,
//   ) async {
//     const apiKey = Constants.mapkey;

//     final url = "https://maps.googleapis.com/maps/api/directions/json"
//         "?origin=${origin.latitude},${origin.longitude}"
//         "&destination=${destination.latitude},${destination.longitude}"
//         "&key=$apiKey";

//     final response = await http.get(Uri.parse(url));
//     final data = json.decode(response.body);

//     if (data['routes'].isEmpty) return {};

//     final leg = data['routes'][0]['legs'][0];

//     return {
//       "distance_km": leg['distance']['value'] / 1000, // meters → km
//       "duration_min": leg['duration']['value'] / 60, // seconds → min
//     };
//   }
// }
