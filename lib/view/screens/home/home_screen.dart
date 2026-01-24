import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yuva_ride/provider/auth_provider.dart';
import 'package:yuva_ride/provider/book_ride_provider.dart';
import 'package:yuva_ride/services/status.dart';
import 'package:yuva_ride/utils/app_assets.dart';
import 'package:yuva_ride/utils/app_fonts.dart';
import 'package:yuva_ride/utils/app_urls.dart';
import 'package:yuva_ride/view/custom_widgets/cusotm_back.dart';
import 'package:yuva_ride/view/custom_widgets/custom_image_carousel.dart';
import 'package:yuva_ride/view/custom_widgets/custom_inkwell.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yuva_ride/main.dart';
import 'package:yuva_ride/services/map_services.dart';
import 'package:yuva_ride/utils/animations.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/view/screens/home/navbar/navbar_screen.dart';
import 'package:yuva_ride/view/screens/ride_booking/after_booking/partener_on_the_way_screen.dart';

import 'package:yuva_ride/view/screens/ride_booking/book_ride/selection_location_book_screen.dart';
import 'package:yuva_ride/view/screens/ride_sharing/share_ride/selection_location_share_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final MapService mapService = MapService();
  Set<Marker> markers = {};

  late AnimationController sheetCtrl;
  late Animation<double> slideAnim;
  late Animation<double> bounceAnim;

  @override
  void initState() {
    super.initState();
    sheetCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    slideAnim = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: sheetCtrl, curve: Curves.easeOutCubic),
    );

    bounceAnim = Tween<double>(begin: 25, end: 0).animate(
      CurvedAnimation(parent: sheetCtrl, curve: Curves.elasticOut),
    );
    Future.delayed(const Duration(milliseconds: 300), () {
      sheetCtrl.forward();
    });
      Future.microtask(() {
      // ignore: use_build_context_synchronously
      context.read<BookRideProvider>().loadLocations();
    });
    _loadMarkers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkActiveRide();
      context.read<AuthProvider>().fetchProfile();
    });
  }

  checkActiveRide() async {
    try {
      print('🔹 checkActiveRide: Starting...');
      final provider = context.read<BookRideProvider>();
      print('🔹 checkActiveRide: Provider initialized');

      await provider.fetchUserActiveRide();
      print('🔹 checkActiveRide: fetchUserActiveRide completed');
      print(
          '🔹 checkActiveRide: activeRideState = ${provider.activeRideState}');

      final ride = provider.activeRideState.data?.data;
      print('🔹 checkActiveRide: ride = $ride');
      print(ride?.serviceCategory);
      print(ride?.vehicleServiceCategory);

      if (provider.activeRideState.data?.data != null &&
          ride != null &&
          ride.serviceCategory != 'pooling' &&
          ride.vehicleServiceCategory != 'pooling') {
        print(
            '🔹 checkActiveRide: Ride found - ID: ${ride.requestId}, Status: ${ride.status}');

        provider.initSocket();
        print('🔹 checkActiveRide: Socket initialized');

        await provider.rideDetail(requestId: ride.requestId!);
        print('🔹 checkActiveRide: rideDetail fetched');

        if (ride.driverId != null) {
          print(
              '🔹 checkActiveRide: Fetching driver profile - driverId: ${ride.driverId}');
          provider.getDriverProfile(driverId: ride.driverId!);
        } else {
          print('🔹 checkActiveRide: No driver ID available');
        }

        // if (ride.status == '0') {
        //   print('🔹 checkActiveRide: Status 0 - Ride accepted');
        //   if (parseLatLng(ride.pickupLatLong) != null &&
        //       parseLatLng(ride.dropLatLong) != null) {
        //     print('🔹 checkActiveRide: Valid pickup/drop coordinates');
        //   }
        // } else if (ride.status == '1') {
        //   print('🔹 checkActiveRide: Status ${ride.status} - Driver on way');
        //   provider.initMapFeatures();
        // }
        // else if( ride.status == '2' || ride.status == '3'){
        //    provider.arrivedPickup();
        // }

        //  else if (ride.status == '5' || ride.status == '6' || ride.status == '7') {
        //   provider.pickuDropMapFeatures();
        // } else {
        //   print('🔹 checkActiveRide: Unknown status - ${ride.status}');
        // }

        print('🔹 checkActiveRide: Navigating to PartnerOnTheWayScreen');
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (_) => const PartnerOnTheWayScreen(),
          ),
        );
      } else {
        print('🔹 checkActiveRide: No active ride found');
      }
    } catch (e) {
      print('❌ checkActiveRide: Error - $e');
      print('❌ checkActiveRide: Stack trace - ${StackTrace.current}');
    }
  }

  Future<void> _loadMarkers() async {
    final loadedMarkers = await mapService.loadVehicleMarkers();
    setState(() {
      markers = loadedMarkers;
    });

    // move camera to markers
    mapService.mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        _boundsFromMarkers(loadedMarkers),
        20,
      ),
    );
  }

  LatLngBounds _boundsFromMarkers(Set<Marker> markers) {
    final lats = markers.map((m) => m.position.latitude);
    final lngs = markers.map((m) => m.position.longitude);

    return LatLngBounds(
      southwest: LatLng(lats.reduce(min), lngs.reduce(min)),
      northeast: LatLng(lats.reduce(max), lngs.reduce(max)),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    context.read<BookRideProvider>().fetchCategory();
    double mapHeight = screenHeight * .27;
    double headerHight = screenHeight * .18;
    return CustomScaffold(
      scaffoldKey: _scaffoldKey,
      drawer: Drawer(
          width: MediaQuery.of(context).size.width,
          child: const ProfileMenuScreen()),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color.fromRGBO(249, 111, 0, 1),
            expandedHeight: headerHight + 30,
            pinned: true,
            floating: false,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                InkWell(
                  onTap: () async {
                    debugPrint(markers.length.toString());
                    mapService.moreIconCamereraAnimation();
                    //   LocalStorage.clearLocalStorate();
                    //   return;
                    // String userId=  await LocalStorage.getUserId()??"";
                    // print(userId);
                  },
                  // child: Text(
                  //   "Yuva Rider",
                  //   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  //         color: Colors.white,
                  //       ),
                  // ),
                  child: Image.asset('assets/images/logo.png',
                      height: headerHight * .5, width: headerHight * .5),
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
              background: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: headerHight * .05),
                  Padding(
                    padding: EdgeInsets.only(
                        top: headerHight * .4, left: 18, right: 18),
                    child: Row(
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
                              height: headerHight * .30,
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
                  ),
                  SizedBox(height: headerHight * .0),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) {
                          return const _LiveRideSharingBottomSheet();
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      decoration: const BoxDecoration(color: AppColors.black),
                      height: headerHight * .25,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            // LIVE INDICATOR (OUTSIDE)
                            Container(
                              height: 19,
                              width: 19,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green.withOpacity(.3)),
                              child: Center(
                                child: Container(
                                  height: 8,
                                  width: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),

                            const Text(
                              "Live",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(width: 10),

                            // HORIZONTAL CARDS
                            ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF232020),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        "2:30 AM",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontFamily: AppFonts.medium),
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        "Hyderabad",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontFamily: AppFonts.medium),
                                      ),
                                      const SizedBox(width: 6),
                                      const Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 6),
                                      const Text(
                                        "Vizag",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontFamily: AppFonts.medium),
                                      ),
                                      const SizedBox(width: 12),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: const Text(
                                          "Bike",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontFamily: AppFonts.medium),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 10)
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          // GOOGLE MAP SECTION
          SliverToBoxAdapter(
            child: Stack(
              children: [
                SizedBox(
                  height: mapHeight,
                  child: GoogleMap(
                    onTap: (argument) {
                      if (kDebugMode) {
                        print(argument.toString());
                      }
                    },
                    onMapCreated: (controller) {
                      mapService.initController(controller);
                      Future.delayed(const Duration(milliseconds: 500), () {
                        mapService.moreIconCamereraAnimation();
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
                Positioned(
                  top: mapHeight * .56,
                  right: 16,
                  child: InkWell(
                    onTap: () {
                      Future.delayed(const Duration(milliseconds: 500), () {
                        mapService.moreIconCamereraAnimation();
                      });
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: AppColors.grey,
                                blurRadius: 1,
                                spreadRadius: 1)
                          ]),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.my_location, color: Colors.black),
                      ),
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(),
                //   child: Image.asset(
                //     "assets/images/pickup_icon.png",
                //     height: 25,
                //     width: 25,
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 240, left: 10, right: 10),
                //   child: Row(
                //     children: [
                //       _buildCategoryCard(
                //         title: "Ride Booking",
                //         subtitle: "Book your ride in seconds",
                //         imagePath: "assets/images/ride_booking.png",
                //         ontap: () {
                //           Navigator.push(
                //             context,
                //             AppAnimations.slideTopToBottom(
                //               const SelectLocationBookScreen(),
                //             ),
                //           );
                //         },
                //       ),
                //       const SizedBox(width: 12),
                //       _buildCategoryCard(
                //         title: "Ride Sharing",
                //         subtitle: "Connect and ride together",
                //         imagePath: "assets/images/ride_sharing.png",
                //         ontap: () {
                //           Navigator.push(
                //             context,
                //             AppAnimations.slideTopToBottom(
                //               const SelectLocationShareScreen(),
                //             ),
                //           );
                //         },
                //       ),
                //     ],
                //   ),
                // ),
                Padding(
                  padding:
                      EdgeInsets.only(top: mapHeight - 40, left: 10, right: 10),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        width: 1,
                        // ignore: deprecated_member_use
                        color: AppColors.white.withOpacity(.3),
                      ),
                      boxShadow: [
                        BoxShadow(
                            // ignore: deprecated_member_use
                            color: AppColors.grey.withOpacity(.3),
                            // offset: const Offset(1, 0),
                            offset: const Offset(0, -2),
                            blurRadius: 1,
                            spreadRadius: 1)
                      ],
                    ),
                    padding: const EdgeInsets.all(8),
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
                                  "Where are you going ?",
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
                        Consumer<BookRideProvider>(
                          builder: (context, provider, _) {
                            final state = provider.locationState;

                            if (isStatusLoading(state.status)) {
                              return const LocationShimmer();
                            }

                            if (isStatusError(state.status)) {
                              return Center(
                                  child: Text(state.message ?? ""));
                            }

                            final list = state.data ?? [];

                            if (list.isEmpty) {
                              return const Center(
                                  child: Text("No locations found"));
                            }

                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              itemCount: list.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 5),
                              itemBuilder: (context, index) {
                                final item = list[index];
                                return _locationTile(item.title, item.subtitle);
                              },
                            );
                          },
                        )

                        // _locationTile("Madhapur",
                        //     "9-120 , Madhapur metro station, Hyderabad, Telangana"),
                        // const SizedBox(height: 5),
                        // _locationTile("Madhapur",
                        //     "9-120 , Madhapur metro station, Hyderabad, Telangana"),
                        // const SizedBox(height: 5),
                        // _locationTile("Madhapur",
                        //     "9-120 , Madhapur metro station, Hyderabad, Telangana"),
                        ,
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Consumer<BookRideProvider>(
              builder: (context, bookingProvider, child) {
                return Consumer<BookRideProvider>(
                    builder: (context, homeProvider, _) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 40),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Explore services',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontFamily: AppFonts.semiBold),
                              ),
                              TextButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) {
                                        return SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.52,
                                          width: double.infinity,
                                          child: _categoryBottomSheet(context,
                                              Theme.of(context).textTheme),
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    'View all',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                            fontFamily: AppFonts.semiBold),
                                  ))
                            ],
                          ),
                        ),
                        isStatusLoadingOrError(
                                homeProvider.categoryState.status)
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(
                                    3, (index) => categoryGridItemShimmer()),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: List.generate(
                                        (homeProvider
                                                        .categoryState
                                                        .data
                                                        ?.categoryList
                                                        ?.length ??
                                                    0) >=
                                                3
                                            ? 3
                                            : homeProvider.categoryState.data
                                                    ?.categoryList?.length ??
                                                0, (index) {
                                      final data = homeProvider.categoryState
                                          .data?.categoryList?[index];
                                      return _categoryGridItem(
                                        text: Theme.of(context).textTheme,
                                        title: data?.name ?? "",
                                        icon: data?.image ??
                                            "", //  "assets/images/bike_book.png",
                                        isSelected: false,
                                        onTap: () async {
                                          // homeProvider.setCategory(
                                          //     data?.serviceCategory ?? '');
                                          // homeProvider.getCalculatedPrice();
                                        },
                                      );
                                    })),
                              ),
                      ],
                    ),
                  );
                });
              },
            ),
          ),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: CustomImageCarousel(
              height: screenHeight * .18,
              images: const [
                AppAssets.homeBanner,
                AppAssets.homeBanner,
                AppAssets.homeBanner,
                AppAssets.homeBanner,
              ],
            ),
          )),
          SliverToBoxAdapter(
              child: Padding(
            padding:
                const EdgeInsets.only(left: 11, right: 11, top: 20, bottom: 20),
            child: CustomImageCarousel(
              height: screenHeight * .18,
              images: const [
                AppAssets.homeBanner2,
                AppAssets.homeBanner2,
                AppAssets.homeBanner2,
                AppAssets.homeBanner2
              ],
            ),
          )),
          // BODY CONTENT
          // SliverToBoxAdapter(
          //   child: Container(
          //     margin: const EdgeInsets.all(18),
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(20),
          //       border: Border.all(
          //         width: 1,
          //         color: AppColors.white.withOpacity(.3),
          //       ),
          //       boxShadow: [
          //         BoxShadow(
          //           color: AppColors.grey.withOpacity(.3),
          //           offset: const Offset(1, 3),
          //           blurRadius: 1,
          //           spreadRadius: 3,
          //         )
          //       ],
          //     ),
          //     padding: const EdgeInsets.all(18),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         InkWell(
          //           onTap: () {
          //             Navigator.push(
          //               context,
          //               AppAnimations.slideBottomToTop(
          //                 const SelectLocationBookScreen(),
          //               ),
          //             );
          //           },
          //           child: Container(
          //             padding: const EdgeInsets.symmetric(
          //                 vertical: 10, horizontal: 16),
          //             decoration: BoxDecoration(
          //               border: Border.all(color: Colors.orange),
          //               borderRadius: BorderRadius.circular(30),
          //             ),
          //             child: Row(
          //               children: [
          //                 const Icon(Icons.search, color: Colors.orange),
          //                 const SizedBox(width: 10),
          //                 Text(
          //                   "Where are you going ?",
          //                   style: Theme.of(context)
          //                       .textTheme
          //                       .bodyLarge
          //                       ?.copyWith(color: Colors.orange),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //         const SizedBox(height: 20),
          //         _locationTile("Madhapur",
          //             "9-120 , Madhapur metro station, Hyderabad, Telangana"),
          //         _locationTile("Madhapur",
          //             "9-120 , Madhapur metro station, Hyderabad, Telangana"),
          //         _locationTile("Madhapur",
          //             "9-120 , Madhapur metro station, Hyderabad, Telangana"),
          //       ],
          //     ),
          //   ),
          // ),
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
        height: 108,
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
                  // Container(
                  //   padding:
                  //       const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  //   margin: const EdgeInsets.only(top: 8, left: 8),
                  //   decoration: BoxDecoration(
                  //     color: const Color(0xff0F59ED),
                  //     borderRadius: BorderRadius.circular(25),
                  //   ),
                  //   child: Text(
                  //     "10% OFF",
                  //     style: Theme.of(context)
                  //         .textTheme
                  //         .labelLarge
                  //         ?.copyWith(color: Colors.white),
                  //   ),
                  // ),
                  const SizedBox(height: 20),

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
    return Row(
      children: [
        const Icon(Icons.location_on_outlined),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context).textTheme.titleSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            SizedBox(
              width: screenWidth * .7,
              child: Text(subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            )
          ],
        )
      ],
    );
  }
}

Widget _categoryBottomSheet(BuildContext context, TextTheme text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.22),
          blurRadius: 18,
          offset: const Offset(0, -4),
        )
      ],
    ),
    child: Column(
      children: [
        // 👇 Handle (UI clarity)
        Container(
          height: 5,
          width: 50,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Explore services',
                style: text.titleLarge?.copyWith(fontFamily: AppFonts.semiBold),
              ),
              IconButton(
                  style: const ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(Color(0xffF3F4F6))),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Center(child: Icon(Icons.close)))
            ],
          ),
        ),

        const SizedBox(height: 12),

        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: Consumer<BookRideProvider>(
              builder: (context, homeProvider, _) {
                return isStatusLoadingOrError(homeProvider.categoryState.status)
                    ? GridView.builder(
                        itemCount: 9,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.85,
                        ),
                        itemBuilder: (_, __) => categoryGridItemShimmer(),
                      )
                    : GridView.builder(
                        itemCount: homeProvider
                                .categoryState.data?.categoryList?.length ??
                            0,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          final data = homeProvider
                              .categoryState.data?.categoryList?[index];
                          return _categoryGridItem(
                              text: text,
                              title: data?.name ?? "",
                              icon: '${AppUrl.baseUrl}/${data?.name ?? ""}',
                              isSelected: false,
                              onTap: () {
                                homeProvider
                                    .setCategory(data?.serviceCategory ?? '');
                                if (kDebugMode) {
                                  print('pool');
                                }
                                if (data?.name
                                        ?.toLowerCase()
                                        .contains('pool') ??
                                    false) {
                                  Navigator.push(
                                      context,
                                      AppAnimations.slideBottomToTop(
                                          const SelectLocationShareScreen()));
                                }

                                // homeProvider.getCalculatedPrice();
                              });
                        },
                      );
              },
            ),
          ),
        ),
      ],
    ),
  );
}

/// Category Item
Widget _categoryGridItem({
  required TextTheme text,
  required String icon,
  required String title,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Container(
      height: screenWidth * .3,
      width: screenWidth * .3,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffF3F4F6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.primaryColor : Color(0xffF3F4F6),
          width: 1,
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(.06),
        //     blurRadius: 8,
        //     offset: const Offset(0, 4),
        //   ),
        // ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //assets/images/bike_book.png
          Image.network(
            '${AppUrl.imageUrl}/$icon',
            height: 42,
            errorBuilder: (context, _, __) => Image.asset(
              'assets/images/bike_book.png',
              height: 42,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: text.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
          ),
        ],
      ),
    ),
  );
}

Widget categoryGridItemShimmer() {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      height: screenWidth * .3,
      width: screenWidth * .3,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// ICON PLACEHOLDER
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 10),

          /// TITLE PLACEHOLDER
          Container(
            height: 12,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ],
      ),
    ),
  );
}

class _LiveRideSharingBottomSheet extends StatelessWidget {
  const _LiveRideSharingBottomSheet();

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return SizedBox(
      height: h * 0.75,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(0xff14821F),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                          height: 16,
                          width: 16,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: const Icon(Icons.circle,
                              size: 8, color: Color(0xff14821F))),
                      const SizedBox(width: 6),
                      const Text(
                        "Live",
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(Color(0xffF3F4F6))),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Center(child: Icon(Icons.close)))
              ],
            ),

            const SizedBox(height: 14),

            // Title
            const Text(
              "Today’s Available ride sharing Booking",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 16),

            // List
            Expanded(
              child: ListView.separated(
                itemCount: 8,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F6F6),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: const Row(
                      children: [
                        Text(
                          "2:30 AM",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppFonts.medium),
                        ),
                        SizedBox(width: 16),
                        Text(
                          "Hyderabad",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppFonts.medium),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 18),
                        SizedBox(width: 8),
                        Text(
                          "Vizag",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppFonts.medium),
                        ),
                        Spacer(),
                        Text(
                          "Bike",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppFonts.medium),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
