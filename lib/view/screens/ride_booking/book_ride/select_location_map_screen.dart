import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yuva_ride/main.dart';
import 'package:yuva_ride/utils/app_colors.dart';

class SelectLocationMapScreen extends StatefulWidget {
  const SelectLocationMapScreen({super.key});

  @override
  State<SelectLocationMapScreen> createState() =>
      _SelectLocationMapScreenState();
}

class _SelectLocationMapScreenState
    extends State<SelectLocationMapScreen> {
  GoogleMapController? mapController;

  LatLng currentPosition = const LatLng(17.4486, 78.3908);
  LatLng selectedPosition = const LatLng(17.4486, 78.3908);

  final Completer<GoogleMapController> _controller = Completer();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    if(mounted)
    setState(() {
      currentPosition = LatLng(pos.latitude, pos.longitude);
      selectedPosition = currentPosition;
      isLoading = false;
    });

    final GoogleMapController c = await _controller.future;
    c.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: currentPosition, zoom: 16),
    ));
  }

  // -----------------------------------------
  // FORMAT ADDRESS (dummy for now)
  // -----------------------------------------
  String get formattedAddress =>
      "Shri Peddamma talli Devalayam,\nHyderabad, Telangana";

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          // ------------------ MAP ------------------
          // if (!isLoading)
            GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: currentPosition, zoom: 15),
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              onMapCreated: (controller) {
                _controller.complete(controller);
                mapController = controller;
              },
              onCameraMove: (position) {
                setState(() => selectedPosition = position.target);
              },
            ),

          // ------------------ MARKER ICON IN CENTER ------------------
          Center(
            child: Image.asset(
              "assets/images/pickup.png",
              height: 50,errorBuilder: (context, error, stackTrace) {
                return SizedBox();
              },
            ),
          ),

          // ------------------ LOCATION CARD ------------------
          Positioned(
            top: screenHeight*.3,
            left: 12,
            right: 12,
            child: Container( 
              margin: EdgeInsets.symmetric(horizontal:screenWidth*.1 ),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Pickup location",
                      style: text.bodyMedium!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(
                    formattedAddress,
                    style: text.bodySmall!.copyWith(
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ------------------ SAVE BUTTON ------------------
          Positioned(
            left: 18,
            right: 18,
            bottom: 40,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context, selectedPosition);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    "Save",
                    style: text.titleMedium!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),

          // ---------------- BACK BUTTON ----------------
          Positioned(
            top: 40,
            left: 12,
            child: Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back),
              ),
            ),
          )
        ],
      ),
    );
  }
}
