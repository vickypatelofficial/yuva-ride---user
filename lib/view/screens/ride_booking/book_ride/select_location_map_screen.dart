import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yuva_ride/controller/book_ride_provider.dart';
import 'package:yuva_ride/main.dart';
import 'package:yuva_ride/models/place_suggestion_model.dart';
import 'package:yuva_ride/services/map_services.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/view/custom_widgets/customTextField.dart';

class SelectLocationMapScreen extends StatefulWidget {
  const SelectLocationMapScreen(
      {super.key, required this.onSelectLocation, required this.latLng});
  final LatLng? latLng;
  final Function(LatLng data, String address, String titile, String subtitle)?
      onSelectLocation;

  @override
  State<SelectLocationMapScreen> createState() =>
      _SelectLocationMapScreenState();
}

class _SelectLocationMapScreenState extends State<SelectLocationMapScreen> {
  final MapService _mapService = MapService();
  String pickupAddress = "";
  String title = "";
  String subtitle = "";
  bool isShowAddressCard = true;

  LatLng selectedPosition = const LatLng(17.4486, 78.3908);

  final Completer<GoogleMapController> _controller = Completer();
  // bool isLoading = true;

  List<PlaceSuggestion> suggestions = [];

  Set<Marker> markers = {};

  final TextEditingController textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadCurrentLocation();
  }

  Future<void> _loadCurrentLocation() async {
    LatLng? latLng;
    if (widget.latLng == null) {
      latLng = await _mapService.getCurrentLatLng();
    } else {
      latLng = widget.latLng;
    }

    if (latLng != null && mounted) {
      LocationModel? location = await _mapService.getAddressFromLatLng(latLng);
      setState(() {
        selectedPosition = latLng!;
        pickupAddress = location?.address ?? "";
        title = location?.title ?? "";
        subtitle = location?.subtitle ?? "";
      });
    }

    // Move camera to tapped position
    await _mapService.moveCamera(selectedPosition);

    // Update marker
    markers.clear();
    markers.add(_mapService.buildSelectedMarker(selectedPosition));

    // Get address
    LocationModel? location =
        await _mapService.getAddressFromLatLng(selectedPosition);

    if (mounted) {
      setState(() {
        selectedPosition = latLng!;
        pickupAddress = location?.address ?? "";
        title = location?.title ?? "";
        subtitle = location?.subtitle ?? "";
      });
    }

    final controller = await _controller.future;
    _mapService.initController(controller);
    _mapService.moveCamera(selectedPosition);
  }

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
                CameraPosition(target: selectedPosition, zoom: 15),
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            onMapCreated: (controller) {
              _controller.complete(controller);
              _mapService.initController(controller);
            },
            onTap: (LatLng latLng) async {
              selectedPosition = latLng;

              // Move camera to tapped position
              await _mapService.moveCamera(latLng);

              // Update marker
              markers.clear();
              markers.add(_mapService.buildSelectedMarker(latLng));

              // Get address
              LocationModel? location =
                  await _mapService.getAddressFromLatLng(latLng);

              if (mounted) {
                setState(() {
                  selectedPosition = latLng;
                  pickupAddress = location?.address ?? "";
                  title = location?.title ?? "";
                  subtitle = location?.subtitle ?? "";
                });
              }
            },
            markers: markers,

            // 🎯 CENTER PIN LOGIC
            onCameraMove: (position) {
              selectedPosition = _mapService.onCameraMove(position);
            },
          ),

          // ------------------ MARKER ICON IN CENTER ------------------
          Center(
            child: Image.asset(
              "assets/images/pickup.png",
              height: 50,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox();
              },
            ),
          ),

          // ------------------ LOCATION CARD ------------------
          // 📦 Address card

          Positioned(
            top: screenHeight * .1,
            left: 16,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  focusNode: _focusNode,
                  hint: 'Search location',
                  borderRadius: 28,
                  controller: textEditingController,
                  suffixIcon: IconButton(
                      onPressed: () {
                        textEditingController.clear();
                        setState(() {
                          isShowAddressCard = true;
                        });
                      },
                      icon: const Icon(Icons.clear)),
                  onChanged: (value) async {
                    suggestions =
                        await _mapService.getLocationSuggestions(value);
                    setState(() {
                      if (textEditingController.text.isEmpty) {
                        isShowAddressCard = true;
                      }
                    });
                  },
                ),
                const SizedBox(height: 10),
                if (textEditingController.text.isNotEmpty &&
                    suggestions.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(width: 1, color: AppColors.grey),
                        borderRadius: BorderRadius.circular(8)),
                    height: screenHeight * .35,
                    child: ListView.builder(
                      itemCount: suggestions.length,
                      itemBuilder: (context, index) {
                        final item = suggestions[index];
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(12)),
                                child: ListTile(
                                  leading: const Icon(Icons.location_on),
                                  title: Text(item.description),
                                  onTap: () async {
                                    // Get LatLng from placeId
                                    LatLng? latLng = await _mapService
                                        .getLatLngFromPlaceId(item.placeId);

                                    if (latLng == null) return;

                                    // Move map camera
                                    await _mapService.moveCamera(latLng);

                                    //  Update marker
                                    markers.clear();
                                    markers.add(_mapService
                                        .buildSelectedMarker(latLng));

                                    //  Get full address
                                    LocationModel? location = await _mapService
                                        .getAddressFromLatLng(latLng);
                                    _focusNode.unfocus();
                                    if (mounted) {
                                      setState(() {
                                        selectedPosition = latLng;
                                        pickupAddress = location?.address ?? "";
                                        title = location?.title ?? "";
                                        subtitle = location?.subtitle ?? "";

                                        isShowAddressCard = true;
                                        suggestions.clear(); // hide list
                                        textEditingController.text =
                                            item.description;
                                      });
                                    }

                                    // 6️⃣ Reset session
                                    _mapService.resetSessionToken();
                                  },
                                ),
                              ),
                              Divider()
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),

          if ((suggestions.isEmpty) && isShowAddressCard)
            Positioned(
              top: screenHeight * .3,
              left: 12,
              right: 12,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth * .1),
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
                      pickupAddress,
                      style: text.bodySmall!
                          .copyWith(color: Colors.white, height: 1.3),
                    ),
                  ],
                ),
              ),
            ),

          // ✅ select
          if ((suggestions.isEmpty) && isShowAddressCard)
            Positioned(
              left: 18,
              right: 18,
              bottom: 40,
              child: GestureDetector(
                onTap: () {
                  widget.onSelectLocation!(
                      selectedPosition, pickupAddress, title, subtitle);
                  Navigator.pop(context);
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
                      "Select",
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
