import 'dart:ffi';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yuva_ride/provider/book_ride_provider.dart';
import 'package:yuva_ride/main.dart';
import 'package:yuva_ride/services/map_services.dart';
import 'package:yuva_ride/services/status.dart';
import 'package:yuva_ride/utils/app_urls.dart';
import 'package:yuva_ride/utils/constatns.dart';
import 'package:yuva_ride/utils/globle_func.dart';
import 'package:yuva_ride/view/custom_widgets/cusotm_back.dart';
import 'package:yuva_ride/view/custom_widgets/cusotm_radio_container.dart';
import 'package:yuva_ride/view/custom_widgets/custom_button.dart';
import 'package:yuva_ride/view/custom_widgets/custom_inkwell.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yuva_ride/utils/animations.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/app_fonts.dart';
import 'package:yuva_ride/view/screens/ride_booking/after_booking/partener_on_the_way_screen.dart';
import 'package:yuva_ride/view/screens/ride_booking/book_ride/choose_contact_screen.dart';
import 'package:yuva_ride/view/screens/ride_booking/book_ride/choose_payment_screen.dart';
import 'package:yuva_ride/view/screens/ride_booking/book_ride/offer_selection_screen.dart';

import 'package:flutter/services.dart';
import 'dart:ui' as ui;

class BookRideVehicleScreen extends StatefulWidget {
  const BookRideVehicleScreen({super.key});
  @override
  State<BookRideVehicleScreen> createState() => _BookRideVehicleScreenState();
}

class _BookRideVehicleScreenState extends State<BookRideVehicleScreen>
    with SingleTickerProviderStateMixin {
  GoogleMapController? mapController;

  // Animation
  late AnimationController sheetCtrl;
  late Animation<double> slideAnim;
  late Animation<double> bounceAnim;
  final MapService mapService = MapService();

  int selectedFare = 0;
  List<int> fareOptions = [10, 20, 30];

  @override
  void initState() {
    super.initState();
    // mapService.loadVehicleMarkers().then((value) {
    //   setState(() => markers = value);
    // });
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
    context.read<BookRideProvider>().initSocket();
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

  @override
  void dispose() {
    sheetCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.read<BookRideProvider>();
    final text = Theme.of(context).textTheme;
    return CustomScaffold(
      body: Stack(
        children: [
          /// TOP ORANGE
          Container(height: 120, color: AppColors.primaryColor),

          const Positioned(
            top: 30,
            left: 18,
            right: 18,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomBack(),
              ],
            ),
          ),

          /// GOOGLE MAP
          Stack(
            children: [
              Positioned.fill(
                top: 90,
                bottom: screenHeight * .45,
                child: GoogleMap(
                  onMapCreated: (controller) async {
                    mapService.initController(controller);

                    await mapService.loadMapIcons(
                        startLocationIcon: 'assets/images/green_marker.png',
                        endLocationIcon:
                            'assets/images/red_marker.png'); // MUST finish first

                    await mapService.setupRoute(
                      pickup: bookingProvider.pickupLocation!.latLng,
                      drop: bookingProvider.dropLocation!.latLng,
                    );
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  initialCameraPosition: CameraPosition(
                    target: bookingProvider.pickupLocation?.latLng ??
                        const LatLng(17.4075, 78.4764),
                    zoom: 13.5,
                  ),
                  markers: mapService.markers,
                  polylines: mapService.polylines,
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  mapToolbarEnabled: true,
                  onTap: (LatLng latLng) async {},
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * .52 + 20,
                right: 16,
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.my_location, color: Colors.black),
                  onPressed: () async {
                    await mapService.setupRoute(
                      pickup: bookingProvider.pickupLocation!.latLng,
                      drop: bookingProvider.dropLocation!.latLng,
                    );
                  }
                ),
              ),
            ],
          ),

          /// BOTTOM SHEET
          // AnimatedBuilder(
          //   animation: sheetCtrl,
          //   builder: (context, child) => Transform.translate(
          //     offset: Offset(0, (slideAnim.value * 550) + bounceAnim.value),
          //     child: child!,
          //   ),
          //   child: _vehicleBottomSheet(context, text),
          // ),
          Consumer<BookRideProvider>(builder: (context, provider, _) {
            // if (bookingProvider.selectedCategory?.isEmpty ?? true) {
            //   return AnimatedBuilder(
            //     animation: sheetCtrl,
            //     builder: (context, child) => Transform.translate(
            //       offset: Offset(0, (slideAnim.value * 550) + bounceAnim.value),
            //       child: child!,
            //     ),
            //     child: _categoryBottomSheet(context, text),
            //   );
            // } else

            // if (bookingProvider.selectedVehicle == null ||
            //     bookingProvider.selectedVehicle?.id == null ||
            //     bookingProvider.selectedVehicle?.id == '')
            if (!bookingProvider.isFareNavigated) {
              return AnimatedBuilder(
                animation: sheetCtrl,
                builder: (context, child) => Transform.translate(
                  offset: Offset(0, (slideAnim.value * 550) + bounceAnim.value),
                  child: child!,
                ),
                child: _vehicleBottomSheet(context, text),
              );
            } else {
              return AnimatedBuilder(
                animation: sheetCtrl,
                builder: (context, child) => Transform.translate(
                  offset: Offset(0, (slideAnim.value * 550) + bounceAnim.value),
                  child: child!,
                ),
                child: _fareBottomSheet(context, text),
              );
            }
          }),
        ],
      ),
    );
  }

  // -----------------------------
  // BOTTOM SHEET
  // -----------------------------
  Widget _vehicleBottomSheet(BuildContext context, TextTheme text) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * .52,
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
            _topHandle(),
            const SizedBox(height: 10),
            _locationCard(text),
            const SizedBox(height: 10),
            Expanded(
              child: Consumer<BookRideProvider>(
                  builder: (context, bookProvider, _) {
                return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: SingleChildScrollView(
                      child: isStatusLoadingOrError(
                              bookProvider.calculateState.status)
                          ? Column(
                              children: List.generate(5, (index) {
                              return vehicleItemShimmer();
                            }))
                          : Column(
                              children: List.generate(
                                  bookProvider.calculateState.data?.calDriver
                                          .length ??
                                      0, (index) {
                              final data = bookProvider
                                  .calculateState.data?.calDriver[index];
                              return _vehicleItem(
                                arrivalTime: data?.driPicTime,
                                isDriversAvailable:
                                    data?.availableDrivers != null &&
                                        data?.availableDrivers != 0,
                                ontap: () {
                                  if (data?.availableDrivers != null &&
                                      data?.availableDrivers != 0) {
                                    bookProvider.setVehicle(
                                        data?.id.toString() ?? '',
                                        data?.pricing.baseFarePerUnit
                                                .toString() ??
                                            "",
                                        data?.pricing.finalFare.toString() ??
                                            "");
                                    bookProvider.setCategory(
                                        data?.serviceCategory ?? '');
                                    bookProvider.assignDriverId(data?.drivers);
                                    if (kDebugMode) {
                                      print(data?.drivers);
                                    }
                                  } else {
                                    showCustomToast(
                                        title:
                                            'No driver available for this vehicle',
                                        backgroundColor: AppColors.red,
                                        textColor: AppColors.white);
                                  }
                                },
                                isSelected: bookProvider.selectedVehicle?.id ==
                                    data?.id.toString(),
                                text,
                                iconImage:
                                    AppUrl.imageUrl + (data?.image ?? ""),
                                title: data?.name ?? "",
                                price: "₹${data?.pricing.finalFare}",
                                cutPrice: data?.pricing.discount != null
                                    ? "₹${data?.pricing.baseFarePerUnit ?? ""}"
                                    : null,
                              );
                            })),
                    ));
              }),
            ),
            _paymentBar(text),
            const SizedBox(
              height: 6,
            ),
            CustomButton(
              onPressed: () {
                // print(context.read<BookRideProvider>().selectedCoupon?.id);
                // print(context.read<BookRideProvider>().selectedCoupon?.couponCode);
                // print(context.read<BookRideProvider>().selectedCoupon?.title);
                // return;

                if (context.read<BookRideProvider>().selectedVehicle?.id !=
                        null &&
                    (context
                            .read<BookRideProvider>()
                            .selectedVehicle
                            ?.id
                            .isNotEmpty ??
                        false)) {
                  context.read<BookRideProvider>().changeFareNaviagate(true);
                } else {
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: "Select a vehicle",
                    barrierColor: Colors.black.withOpacity(0.45),
                    transitionDuration: const Duration(milliseconds: 300),
                    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
                    transitionBuilder: (context, animation, _, __) {
                      final curved = CurvedAnimation(
                          parent: animation, curve: Curves.easeOutBack);

                      return ScaleTransition(
                        scale: curved,
                        child: FadeTransition(
                          opacity: animation,
                          child: Center(
                            child: Container(
                              width: 300,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 25,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  /// ICON
                                  Container(
                                    height: 56,
                                    width: 56,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor
                                          .withOpacity(0.12),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.directions_car_filled,
                                      size: 28,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  /// TITLE
                                  Text(
                                    "Vehicle Required",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),

                                  const SizedBox(height: 8),

                                  /// MESSAGE
                                  Text(
                                    "Please select a vehicle before continuing.",
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.black54),
                                  ),

                                  const SizedBox(height: 22),

                                  /// ACTION
                                  GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: Container(
                                      height: 44,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Text(
                                        "OK, Got it",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
              text: "Book a ride",
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryBottomSheet(BuildContext context, TextTheme text) {
    final bookRideProvider = context.read<BookRideProvider>();
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * .52,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(.22),
              blurRadius: 18,
              offset: const Offset(0, -4),
            )
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),

            /// 🔹 GRID VIEW HERE
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: Consumer<BookRideProvider>(
                    builder: (context, homeProvider, _) {
                  return isStatusLoadingOrError(
                          homeProvider.categoryState.status)
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
                          key: const ValueKey("category_grid"),
                          itemCount: homeProvider
                                  .categoryState.data?.categoryList?.length ??
                              0,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 14,
                                  crossAxisSpacing: 14,
                                  childAspectRatio: 0.85),
                          itemBuilder: (context, index) {
                            final data = homeProvider
                                .categoryState.data?.categoryList?[index];
                            return _categoryGridItem(
                              text: text,
                              title: data?.name ?? "",
                              icon: "assets/images/bike_book.png",
                              isSelected: false,
                              onTap: () async {
                                homeProvider
                                    .setCategory(data?.serviceCategory ?? '');
                                homeProvider.getCalculatedPrice();
                              },
                            );
                          },
                        );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fareBottomSheet(BuildContext context, TextTheme text) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * .52,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(.22),
              blurRadius: 18,
              offset: const Offset(0, -4),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _topHandle(),
            const SizedBox(height: 20),

            Text(
              "Choose your tip amount",
              style: text.titleMedium!.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Text(
              "Select a tip to appreciate your rider’s service.",
              style: text.bodySmall!.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            /// FARE OPTIONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: fareOptions.map((value) {
                    bool isSelected = value == selectedFare;
                    return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (selectedFare == value) {
                              selectedFare = 0;
                            } else {
                              selectedFare = value;
                            }
                          });
                        },
                        child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 40,
                            width: 70,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : Colors.grey.shade300),
                              boxShadow: [
                                if (isSelected)
                                  BoxShadow(
                                      color: AppColors.primaryColor
                                          .withOpacity(.3),
                                      blurRadius: 10)
                              ],
                            ),
                            child: Center(
                                child: Text(
                              "+₹$value",
                              style: text.titleMedium!.copyWith(
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ))));
                  }).toList() +
                  [
                    GestureDetector(
                      onTap: () async {
                        bool isSelected = !fareOptions.contains(selectedFare) &&
                            selectedFare != 0;
                        if (isSelected) {
                          setState(() {
                            selectedFare = 0;
                          });

                          return;
                        }

                        final TextEditingController controller =
                            TextEditingController();

                        await showDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierColor: Colors.black.withOpacity(0.45),
                          builder: (context) {
                            final text = Theme.of(context).textTheme;

                            return Dialog(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              child: Container(
                                width: 280,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(26),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.18),
                                      blurRadius: 25,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    /// ICON
                                    Container(
                                      height: 54,
                                      width: 54,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor
                                            .withOpacity(0.12),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.currency_rupee,
                                        color: AppColors.primaryColor,
                                        size: 28,
                                      ),
                                    ),

                                    const SizedBox(height: 14),

                                    /// TITLE
                                    Text(
                                      "Add Tip",
                                      style: text.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    /// SUBTITLE
                                    Text(
                                      "Add your tip for fastly ride book",
                                      style: text.bodySmall
                                          ?.copyWith(color: Colors.black54),
                                    ),

                                    const SizedBox(height: 18),

                                    /// INPUT FIELD
                                    Container(
                                      height: 46,
                                      width: 200,
                                      alignment: Alignment.center,
                                      child: TextField(
                                        controller: controller,
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        maxLength: 3,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(3),
                                        ],
                                        style: text.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                        decoration: InputDecoration(
                                          counterText: "",
                                          hintText: "₹ 000",
                                          hintStyle: text.titleMedium?.copyWith(
                                              color: Colors.grey.shade400),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 1.5,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            borderSide: const BorderSide(
                                              color: AppColors.primaryColor,
                                              width: 2,
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 10),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 22),

                                    /// ACTION BUTTONS
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () => Navigator.pop(context),
                                            child: Container(
                                              height: 44,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                border: Border.all(
                                                    color:
                                                        Colors.grey.shade300),
                                              ),
                                              child: Text(
                                                "Cancel",
                                                style: text.bodyMedium,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              final value = int.tryParse(
                                                  controller.text.trim());

                                              if (value == null || value <= 0)
                                                return;

                                              Navigator.pop(context, value);
                                            },
                                            child: Container(
                                              height: 44,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                color: AppColors.primaryColor,
                                              ),
                                              child: Text(
                                                "Add",
                                                style:
                                                    text.bodyMedium?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
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
                            );
                          },
                        ).then((value) {
                          if (value != null && mounted) {
                            setState(() {
                              selectedFare = value;
                            });
                          }
                        });
                      },
                      child: Builder(builder: (context) {
                        bool isSelected = !fareOptions.contains(selectedFare) &&
                            selectedFare != 0;
                        return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 40,
                            width: 70,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : Colors.grey.shade300),
                              boxShadow: [
                                if (isSelected)
                                  BoxShadow(
                                      color: AppColors.primaryColor
                                          .withOpacity(.3),
                                      blurRadius: 10)
                              ],
                            ),
                            child: Center(
                                child: Text(
                              !fareOptions.contains(selectedFare) &&
                                      selectedFare != 0
                                  ? '+₹$selectedFare'
                                  : "Add",
                              style: text.titleMedium!.copyWith(
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            )));
                      }),
                    )
                  ],
            ),
            const SizedBox(height: 20),
            _paymentBar(text),
            const SizedBox(
              height: 40,
            ),
            Consumer<BookRideProvider>(builder: (context, provider, _) {
              return CustomButton(
                isLoading: isStatusLoading(provider.rideCreateState.status),
                onPressed: () async {
                  await provider.createRide(tip: selectedFare);
                  provider.rideDetailState = ApiResponse.loading();
                  if (isStatusSuccess(provider.rideCreateState.status)) {
                    provider.rideDetail(
                        requestId:
                            provider.rideCreateState.data?['id']?.toString() ??
                                '');
                    // ignore: use_build_context_synchronously
                    Navigator.push(context,
                        AppAnimations.zoomOut(const PartnerOnTheWayScreen()));
                  }
                },
                text:
                    "Book a ride for ₹${toDoubleSafe(provider.selectedVehicle?.discountPrice) + toDoubleSafe(selectedFare)}",
              );
            }),
          ],
        ),
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
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : Colors.black.withOpacity(.05),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.06),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon, height: 42),
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

  // -----------------------------
  // VEHICLE ITEM (TAP TO SELECT)
  // -----------------------------
  Widget _vehicleItem(TextTheme text,
      {required String iconImage,
      required String title,
      required String price,
      required bool isSelected,
      String? arrivalTime,
      String? cutPrice,
      required bool isDriversAvailable,
      required VoidCallback ontap}) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: CustomInkWell(
        onTap: ontap,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        elevation: 1,
        decoration: BoxDecoration(
          color: isDriversAvailable
              ? AppColors.white
              : AppColors.white.withOpacity(.8),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 6,
                offset: const Offset(0, 3))
          ],
        ),
        child: Row(
          children: [
            Image.network(
              iconImage,
              height: 38,
              errorBuilder: (context, error, stackTrace) =>
                  Image.asset("assets/images/bike_book.png"),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isDriversAvailable
                      ? Text("Arrival in ${arrivalTime ?? ""}",
                          style: text.labelMedium!
                              .copyWith(color: AppColors.success, fontSize: 13))
                      : Text("No available drivers",
                          style: text.labelMedium!
                              .copyWith(color: AppColors.red, fontSize: 13)),
                  Text(title,
                      style: text.titleMedium!
                          .copyWith(fontFamily: AppFonts.semiBold)),
                ],
              ),
            ),
            Row(
              children: [
                Text(price,
                    style: text.titleMedium!
                        .copyWith(fontFamily: AppFonts.medium)),
                const SizedBox(
                  width: 5,
                ),
                if (cutPrice != null)
                  Text(cutPrice,
                      style: text.bodySmall!
                          .copyWith(decoration: TextDecoration.lineThrough)),
              ],
            ),
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 10,
              backgroundColor: Colors.white,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(
                      color: !isSelected
                          ? AppColors.grey
                          : AppColors.primaryColor),
                  shape: BoxShape.circle,
                ),
                child: Container(
                  margin: const EdgeInsets.all(3),
                  height: 18,
                  width: 18,
                  decoration: BoxDecoration(
                    color: !isSelected
                        ? AppColors.transparent
                        : AppColors.primaryColor,
                    border: Border.all(
                        color: !isSelected
                            ? AppColors.transparent
                            : AppColors.primaryColor),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget vehicleItemShimmer() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            // color: Colors.white,
            border: Border.all(),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              /// ICON
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 14),

              /// TEXT AREA
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 12,
                      width: 110,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 16,
                      width: 110,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ),

              /// PRICE
              Container(
                height: 16,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),

              const SizedBox(width: 10),

              /// RADIO
              Container(
                height: 20,
                width: 20,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // -----------------------------
  Widget _locationCard(TextTheme text) {
    final bookRideProvider = context.read<BookRideProvider>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------- LEFT SIDE COLUMN ----------------
              Column(
                children: [
                  // Green dot
                  Container(
                    height: 14,
                    width: 14,
                    decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.green, blurRadius: 7)
                        ]),
                  ),

                  const SizedBox(height: 4),

                  // Vertical line
                  Container(
                    height: 25,
                    width: 2,
                    color: Colors.black,
                  ),

                  const SizedBox(height: 4),

                  // Red dot
                  Container(
                    height: 14,
                    width: 14,
                    decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.red, blurRadius: 7)
                        ]),
                  ),
                ],
              ),

              const SizedBox(width: 14),

              // ---------------- RIGHT SIDE TEXT ----------------
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pickup
                    Text(bookRideProvider.pickupLocation?.address ?? '',
                        style: text.bodyLarge, maxLines: 1),

                    const SizedBox(height: 3),

                    // Divider (aligned to text)
                    Container(
                      height: 1,
                      width: double.infinity,
                      color: Colors.grey.shade300,
                    ),

                    const SizedBox(height: 6),

                    // Drop
                    Text(
                      bookRideProvider.dropLocation?.address ?? '',
                      style: text.bodyLarge,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _paymentBar(TextTheme text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// ---------------- CASH BUTTON ----------------
          _paymentButton(context,
              icon: "assets/images/cash.png",
              label: context.read<BookRideProvider>().selectedPayment?.title ??
                  "Cash", onTap: () {
            Navigator.push(
                context, AppAnimations.fade(const ChoosePaymentModeScreen()));
          }),
          _verticalDivider(),

          /// ---------------- OFFERS BUTTON ----------------
          _paymentButton(
            context,
            icon: "assets/images/offer.png",
            label: (context.read<BookRideProvider>().selectedCoupon?.title !=
                        null) &&
                    (context.read<BookRideProvider>().selectedCoupon?.title !=
                        null)
                ? context.read<BookRideProvider>().selectedCoupon?.title ?? ''
                : "Offers",
            onTap: () {
              Navigator.push(
                  context, AppAnimations.fade(const ApplyCouponsScreen()));
            },
          ),
          _verticalDivider(),

          /// ---------------- MY SELF BUTTON ----------------

          _paymentButton(
            context,
            icon: "assets/images/user.png",
            label: ((context.read<BookRideProvider>().selectedContact ==
                        null) ||
                    (context.read<BookRideProvider>().selectedContact?.isSelf ??
                        true))
                ? "My Self"
                : context.read<BookRideProvider>().selectedContact?.name ?? "",
            onTap: () {
              print(context.read<BookRideProvider>().selectedContact?.isSelf);
              print(context.read<BookRideProvider>().selectedContact?.name);
              _showRideForSomeoneSheet(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(
      height: 32,
      width: 1.2,
      color: Colors.grey.shade300,
      margin: const EdgeInsets.symmetric(horizontal: 6),
    );
  }

  Widget _paymentButton(
    BuildContext context, {
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        splashColor: Colors.orange.withOpacity(.2),
        child: Container(
          height: 35,
          width: MediaQuery.of(context).size.width * 0.23,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(icon, height: 18),
              const SizedBox(width: 6),
              Flexible(
                child: AutoSizeText(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//  _showRideForSomeoneSheet(context);
  Widget _topHandle() {
    return Container(
      height: 4,
      width: 40,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _roundIcon(IconData icon, {bool white = false}) {
    return CircleAvatar(
      backgroundColor: Colors.white.withOpacity(.3),
      child: Icon(icon, color: white ? Colors.white : Colors.black),
    );
  }

  Widget _self(TextTheme text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.2),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white),
      ),
      child: Text("My Self",
          style: text.bodyMedium!
              .copyWith(color: Colors.white, fontFamily: AppFonts.medium)),
    );
  }
}

void _showRideForSomeoneSheet(BuildContext context) {
  final text = Theme.of(context).textTheme;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Consumer<BookRideProvider>(builder: (context, provider, _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// CLOSE BUTTON
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Book a Ride for Someone Else",
                    style: text.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.black12,
                      child: Icon(Icons.close, size: 18, color: Colors.black),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 4),

              Text(
                "Booking for someone made simple.",
                style: text.bodyMedium!.copyWith(
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 20),

              /// TITLE: WHO’S TAKING THE RIDE?
              Text(
                "Who's Taking the Ride?",
                style: text.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              /// OPTION 1 — MY SELF
              Row(
                children: [
                  CustomRadioContainer(
                    isSelected: provider.selectedContact?.isSelf == true,
                    onTap: () {
                      provider.selectContact(isSelf: true);
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(Icons.person_outlined),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "My Self",
                    style: text.bodyLarge,
                  ),
                ],
              ),

              const SizedBox(height: 10),
              Consumer<BookRideProvider>(builder: (context, provider, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                      (provider.contactState.data?.length ?? 0) > 0 ? 1 : 0,
                      (index) {
                    final contact = provider.contactState.data?[index];
                    return Row(
                      children: [
                        CustomRadioContainer(
                          isSelected:
                              !(provider.selectedContact?.isSelf ?? true),
                          onTap: () {
                            provider.selectContact(
                              isSelf: false,
                              phone: contact?.phone,
                              name: contact?.name,
                              id: contact?.id,
                              cId: contact?.cId,
                              countryCode: contact?.countryCode,
                            );
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.person_outlined),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(contact?.name ?? '', style: text.bodyLarge),
                            Text(
                              contact?.phone ?? '',
                              style: text.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                );
              }),

              const SizedBox(height: 10),

              /// OPTION 3 — CHOOSE ANOTHER CONTACT
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      AppAnimations.fadeSlide(
                          const ChooseSavedContactScreen()));
                },
                child: Row(
                  children: [
                    const Icon(Icons.contacts, color: Colors.black54),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Choose another contact",
                        style: text.bodyLarge,
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios,
                        color: Colors.black54, size: 18)
                  ],
                ),
              ),
              const SizedBox(height: 18),

              /// SAVE BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Save",
                    style: text.titleMedium!.copyWith(
                      color: Colors.white,
                      fontFamily: AppFonts.semiBold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          );
        }),
      );
    },
  );
}
