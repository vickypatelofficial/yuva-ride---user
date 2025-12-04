import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:yuva_ride/view/custom_widgets/cusotm_back.dart';
import 'package:yuva_ride/view/custom_widgets/custom_inkwell.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yuva_ride/main.dart';
import 'package:yuva_ride/services/map_services.dart';
import 'package:yuva_ride/utils/animations.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/view/screens/home/navbar/navbar_screen.dart';
import 'dart:ui' as ui;

import 'package:yuva_ride/view/screens/ride_booking/book_ride/selection_location_book_screen.dart';
import 'package:yuva_ride/view/screens/ride_sharing/ride_sharing_history/ride_sharing_history_screen.dart';
import 'package:yuva_ride/view/screens/ride_sharing/share_ride/selection_location_share_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MapService mapService = MapService();
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();

    mapService.loadVehicleMarkers().then((value) {
      setState(() => markers = value);
    });
  }

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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      scaffoldKey: _scaffoldKey,
      drawer: Drawer(
          width: MediaQuery.of(context).size.width,
          child: const ProfileMenuScreen()),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.primaryColor,
            expandedHeight: 150,
            pinned: true,
            floating: false,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Text(
                  "Yuva Rider",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                      ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.only(top: 90, left: 18, right: 18),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _circleButton(Icons.menu, () {
                          _scaffoldKey.currentState?.openDrawer();
                        }),
                        const SizedBox(width: 10),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                AppAnimations.slideTopToBottom(
                                  const SelectLocationBookScreen(),
                                ),
                              );
                            },
                            child: Container(
                              height: 50,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 12, right: 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Madhapura, Hyderabad",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: Colors.black),
                                    ),
                                    const SizedBox(width: 10),
                                    const Icon(Icons.favorite_border,
                                        color: Colors.black),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // GOOGLE MAP SECTION
          SliverToBoxAdapter(
            child: Stack(
              children: [
                SizedBox(
                  height: 300,
                  child: GoogleMap(
                    onMapCreated: (controller) {
                      mapService.initController(controller);

                      Future.delayed(const Duration(milliseconds: 500), () {
                        mapService.runAdvancedCameraAnimation();
                      });
                    },
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(17.4065, 78.4772),
                      zoom: 13.5,
                    ),
                    markers: markers,
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(),
                  child: Image.asset(
                    "assets/images/pickup_icon.png",
                    height: 25,
                    width: 25,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 240, left: 10, right: 10),
                  child: Row(
                    children: [
                      _buildCategoryCard(
                        title: "Ride Booking",
                        subtitle: "Book your ride in seconds",
                        imagePath: "assets/images/ride_booking.png",
                        ontap: () {
                          Navigator.push(
                            context,
                            AppAnimations.slideTopToBottom(
                              const SelectLocationBookScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      _buildCategoryCard(
                        title: "Ride Sharing",
                        subtitle: "Connect and ride together",
                        imagePath: "assets/images/ride_sharing.png",
                        ontap: () {
                          Navigator.push(
                            context,
                            AppAnimations.slideTopToBottom(
                              const SelectLocationShareScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // BODY CONTENT
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  width: 1,
                  color: AppColors.white.withOpacity(.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.grey.withOpacity(.3),
                    offset: const Offset(1, 3),
                    blurRadius: 1,
                    spreadRadius: 3,
                  )
                ],
              ),
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        AppAnimations.slideBottomToTop(
                          const SelectLocationBookScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.orange),
                          const SizedBox(width: 10),
                          Text(
                            "Search Destination",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: Colors.orange),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _locationTile("Madhapur",
                      "9-120 , Madhapur metro station, Hyderabad, Telangana"),
                  _locationTile("Madhapur",
                      "9-120 , Madhapur metro station, Hyderabad, Telangana"),
                  _locationTile("Madhapur",
                      "9-120 , Madhapur metro station, Hyderabad, Telangana"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // UI widgets
  Widget _circleButton(IconData icon, VoidCallback? ontap) {
    return CustomBack(
      // padding: const EdgeInsets.all(10),

      icon: icon, onTap: ontap,
    );
  }

  Widget _buildCategoryCard(
      {required String title,
      required String subtitle,
      required String imagePath,
      VoidCallback? ontap}) {
    return Expanded(
      child: CustomInkWell(
        onTap: ontap,
        height: 106,
        padding: const EdgeInsets.all(0),
        elevation: 1,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 10% OFF
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    margin: const EdgeInsets.only(top: 8, left: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xff0F59ED),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      "10% OFF",
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 2),

                  // Title + Arrow
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 5,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: SizedBox(
                            width: screenWidth * .2,
                            child: AutoSizeText(
                              title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontSize: 13),
                              maxLines: 2,
                            ),
                          ),
                        ),
                        Container(
                          height: 18,
                          width: 18,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 11,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, bottom: 5),
                    child: Text(subtitle,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontSize: 8),
                        maxLines: 2),
                  )
                ],
              ),
            ),
            const SizedBox(width: 4),
            Container(
              decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(.05),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                  )),
              child: ClipRRect(
                borderRadius: const BorderRadiusGeometry.only(
                  topRight: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
                child: Image.asset(
                    height: 100,
                    imagePath,
                    width: screenWidth * .17,
                    fit: BoxFit.fitHeight),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _locationTile(String title, String subtitle) {
    return ListTile(
      leading: const Icon(Icons.location_on_outlined),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall,
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}
