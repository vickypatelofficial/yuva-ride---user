import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapService {
  GoogleMapController? mapController;

  // Initialize map controller
  void initController(GoogleMapController controller) {
    mapController = controller;
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
          markerId: MarkerId("bike1"),
          position: LatLng(17.4065, 78.4772),
          icon: bike),
      Marker(
          markerId: MarkerId("bike2"),
          position: LatLng(17.4068, 78.4785),
          icon: bike),
      Marker(
          markerId: MarkerId("bike3"),
          position: LatLng(17.4072, 78.4769),
          icon: bike),

      // Autos
      Marker(
          markerId: MarkerId("auto1"),
          position: LatLng(17.4085, 78.4790),
          icon: auto),
      Marker(
          markerId: MarkerId("auto2"),
          position: LatLng(17.4079, 78.4775),
          icon: auto),

      // Cars
      Marker(
          markerId: MarkerId("car1"),
          position: LatLng(17.4048, 78.4740),
          icon: car),
      Marker(
          markerId: MarkerId("car2"),
          position: LatLng(17.4075, 78.4764),
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
}
