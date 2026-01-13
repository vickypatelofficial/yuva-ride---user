import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yuva_ride/main.dart';
import 'package:yuva_ride/models/ride_detail_model.dart';
import 'package:yuva_ride/provider/book_ride_provider.dart';
import 'package:yuva_ride/services/local_storage.dart';
import 'package:yuva_ride/services/map_services.dart';
import 'package:yuva_ride/services/status.dart';
import 'package:yuva_ride/utils/app_urls.dart';
import 'package:yuva_ride/utils/globle_func.dart';
import 'package:yuva_ride/view/custom_widgets/cusotm_back.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yuva_ride/utils/animations.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/app_fonts.dart';
import 'package:yuva_ride/view/screens/ride_booking/after_booking/cancel_ride_screen.dart';
import 'package:yuva_ride/view/screens/ride_booking/after_booking/chat_screen_new.dart';
import 'package:yuva_ride/view/screens/ride_booking/after_booking/widgets/ripple_loader.dart';
import 'package:yuva_ride/view/screens/ride_booking/after_booking/widgets/shimmer_card_driver.dart';

class PartnerOnTheWayScreen extends StatefulWidget {
  const PartnerOnTheWayScreen({super.key});

  @override
  State<PartnerOnTheWayScreen> createState() => _PartnerOnTheWayScreenState();
}

class _PartnerOnTheWayScreenState extends State<PartnerOnTheWayScreen> {
  Timer? rideTimer;

  int elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    context.read<BookRideProvider>().mapService.clearMap();
    _startPopupTimer(context);
    // startRideTimer();
  }

  void startRideTimer() async {
    await Future.delayed(const Duration(seconds: 10));
    // isDriverFound = true;
    rideTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        elapsedSeconds++;
      });
    });
  }

  Timer? _popupTimer;

  void _startPopupTimer(BuildContext context) {
    //
    final provider = context.read<BookRideProvider>();
    _popupTimer = Timer(const Duration(minutes: 1), () async {
      if (provider.rideDetailState.data?.cartTableId == null ||
          (provider.rideDetailState.data?.cartTableId ?? '').isEmpty &&
              mounted) {
        await provider.removeRideRequest(
            provider.rideDetailState.data?.requestTableId ?? '');
        if (isStatusSuccess(provider.removeRideRequestState.status)) {
          Future.delayed(const Duration(seconds: 1), () {
            showAddMoreTipDialog(context: navigatorKey.currentContext!);
          });
          Navigator.maybePop(context);
        }
      } else {
        _stopPopupTimer();
      }
    });
  }

  void _stopPopupTimer() {
    _popupTimer?.cancel();
    _popupTimer = null;
  }

  @override
  void dispose() {
    rideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookRideProvider = context.read<BookRideProvider>();
    final text = Theme.of(context).textTheme;
    return CustomScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        toolbarHeight: 70,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 10),
            CustomBack(onTap: () async {
              Navigator.pop(context);
              return;
            }),
            const SizedBox(width: 12),
            InkWell(
              onTap: () {
                // bookRideProvider.initMapFeatures();
                // bookRideProvider.getDriverProfile(driverId: '225');
                // bookRideProvider.getAvailableDrivers();
                // bookRideProvider.initMapFeatures(startLocation, endLocation);
                // final startLocation = LatLng(
                //     bookRideProvider.rideDetailModel.data?.driverToCustomer
                //             ?.driverLocation?.latitude ??
                //         17.438911,
                //     bookRideProvider.rideDetailModel.data?.driverToCustomer
                //             ?.driverLocation?.longitude ??
                //         78.3983894);
                // // const startLocation = LatLng(, 78.481039);
                // final endLocation = MapService.parseLatLngSafe(bookRideProvider
                //         .rideDetailModel.data?.requestData?.picLatLong) ??
                //     const LatLng(17.438911, 78.3983894);
                // print('map is creating');
                // bookRideProvider.initMapFeatures(startLocation, endLocation);
              },
              child: Text(
                "Partner on the way",
                style: text.titleMedium!.copyWith(
                  color: Colors.white,
                  fontFamily: AppFonts.medium,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Consumer<BookRideProvider>(
          builder: (context, bookRideProvider, child) {
        return Stack(
          children: [
            /// MAP
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Stack(
                children: [
                  Stack(
                    children: [
                      Consumer<BookRideProvider>(
                          builder: (context, provider, child) {
                        return SizedBox(
                          height: 300,
                          child: GoogleMap(
                            onMapCreated: (c) {
                              print('+++++++++map initialize here++++');
                              bookRideProvider.mapService.initController(c);
                              final requestData = bookRideProvider
                                  .rideDetailState.data!.requestData;
                              if (requestData?.status == '0') {
                                print(
                                    '🔹user checkActiveRide: Status 0 - Ride accepted');
                                if (parseLatLng(requestData?.picLatLong) !=
                                        null &&
                                    parseLatLng(requestData?.dropLatLong) !=
                                        null) {
                                  print(
                                      '🔹user checkActiveRide: Valid pickup/drop coordinates');
                                }
                              } else if (requestData?.status == '1') {
                                print(
                                    '🔹user checkActiveRide: Status ${requestData?.status} - Driver on way');
                                bookRideProvider.initMapFeatures();
                              } else if (requestData?.status == '2' ||
                                  requestData?.status == '3') {
                                bookRideProvider.arrivedPickup();
                              } else if (requestData?.status == '5' ||
                                  requestData?.status == '6') {
                                print('user pickup drops');
                                bookRideProvider.pickuDropMapFeatures();
                              } else {
                                bookRideProvider.setDropFeature();
                                showRideEndNotifyDialog(
                                    navigatorKey.currentContext!);
                                print(
                                    '🔹 checkActiveRide: Unknown status - ${requestData?.status}');
                              }
                              Future.delayed(const Duration(seconds: 2), () {
                                setState(() {
                                  if (requestData?.status == '1') {
                                    bookRideProvider.initMapFeatures(
                                        fitBoundOnly: true);
                                  }
                                });
                              });
                            },
                            initialCameraPosition: CameraPosition(
                              target: bookRideProvider.pickupLocation?.latLng ??
                                  const LatLng(17.4065, 78.4772),
                              zoom: 14.5,
                            ),
                            markers: bookRideProvider.mapService.markers,
                            polylines: bookRideProvider.mapService.polylines,
                            zoomControlsEnabled: false,
                            myLocationButtonEnabled: false,
                            myLocationEnabled: true,
                          ),
                        );
                      }),
                      Positioned(
                        bottom: 10,
                        right: 16,
                        child: FloatingActionButton(
                          backgroundColor: Colors.white,
                          child: const Icon(Icons.my_location,
                              color: Colors.black),
                          onPressed: () async {
                            final requestData = bookRideProvider
                                .rideDetailState.data!.requestData;
                            if (requestData?.status == '0') {
                              print(
                                  '🔹 checkActiveRide: Status 0 - Ride accepted');
                              if (parseLatLng(requestData?.picLatLong) !=
                                      null &&
                                  parseLatLng(requestData?.dropLatLong) !=
                                      null) {
                                print(
                                    '🔹 checkActiveRide: Valid pickup/drop coordinates');
                              }
                            } else if (requestData?.status == '1') {
                              print(
                                  '🔹 checkActiveRide: Status ${requestData?.status} - Driver on way');
                              bookRideProvider.initMapFeatures(
                                  fitBoundOnly: true);
                            } else if (requestData?.status == '2' ||
                                requestData?.status == '3') {
                              bookRideProvider.arrivedPickup(
                                  fitBoundOnly: true);
                            } else if (requestData?.status == '5' ||
                                requestData?.status == '6') {
                              bookRideProvider.pickuDropMapFeatures(
                                  fitBoundOnly: true);
                            } else {
                              bookRideProvider.setDropFeature(
                                  fitBoundOnly: true);
                              showRideEndNotifyDialog(
                                  navigatorKey.currentContext!);
                              print(
                                  '🔹 checkActiveRide: Unknown status - ${requestData?.status}');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  if (!isStatusSuccess(
                      bookRideProvider.driverProfileState.status))
                    Positioned.fill(
                        top: -screenHeight * .4,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: const RippleLoader())
                ],
              ),
            ),

            /// WHITE CONTENT BELOW MAP
            Positioned(
              top: 300,
              left: 0,
              right: 0,
              bottom: 0,
              child: SingleChildScrollView(
                child: Container(
                  color: AppColors.white,
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      !isStatusSuccess(
                              bookRideProvider.driverProfileState.status)
                          ? Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    showAddMoreTipDialog(context: context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Text(
                                      "Matching with your rider… don't go anywhere...",
                                      style: text.titleMedium!.copyWith(
                                          fontFamily: AppFonts.bold,
                                          fontSize: 17),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const ShimmerDriverCard()
                              ],
                            )
                          : Column(
                              children: [
                                TripAndDistanceCard(
                                    text: text, elapsedSeconds: elapsedSeconds),
                                const SizedBox(height: 12),
                                Builder(builder: (context) {
                                  if (bookRideProvider.otp == null ||
                                      (bookRideProvider.rideDetailState.data
                                              ?.requestData?.status !=
                                          '2')) {
                                    return SizedBox(
                                        // child: Text(bookRideProvider
                                        //         .rideDetailState
                                        //         .data
                                        //         ?.requestData
                                        //         ?.id
                                        //         .toString() ??
                                        //     ''
                                        //     ),
                                        // child: Text
                                        // (
                                        //   bookRideProvider
                                        //         .rideDetailState
                                        //         .data
                                        //         ?.requestData
                                        //         ?.status
                                        //         .toString() ??
                                        //     ''),
                                        );
                                  }
                                  return Container(
                                    padding: const EdgeInsets.all(14),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 18),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: [
                                        BoxShadow(
                                          // ignore: deprecated_member_use
                                          color: Colors.black.withOpacity(.05),
                                          blurRadius: 12,
                                          offset: const Offset(0, 3),
                                        )
                                      ],
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            "Share the code to unlock\nyour ride.",
                                            style: text.bodyMedium),
                                        const SizedBox(height: 6),
                                        Text(
                                          bookRideProvider.otp ?? '',
                                          style: text.headlineSmall!.copyWith(
                                              fontFamily: AppFonts.medium,
                                              letterSpacing: 2),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.all(14),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 18),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(.05),
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// ---------------- DRIVER ROW ----------------
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: InkWell(
                                              onTap: () {
                                                print(AppUrl.imageUrl +
                                                    (bookRideProvider
                                                            .driverProfileState
                                                            .data
                                                            ?.dDetail
                                                            ?.profileImage ??
                                                        ''));
                                              },
                                              child: Image.network(
                                                AppUrl.imageUrl +
                                                    (bookRideProvider
                                                            .driverProfileState
                                                            .data
                                                            ?.dDetail
                                                            ?.profileImage ??
                                                        ''),
                                                height: 60,
                                                width: 60,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Image.asset(
                                                    "assets/images/driver.png",
                                                    height: 60,
                                                    width: 60,
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                bookRideProvider
                                                        .driverProfileState
                                                        .data
                                                        ?.dDetail
                                                        ?.vehicleNumber ??
                                                    '',
                                                style:
                                                    text.titleMedium!.copyWith(
                                                  fontFamily: AppFonts.medium,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                bookRideProvider
                                                        .driverProfileState
                                                        .data
                                                        ?.dDetail
                                                        ?.carName ??
                                                    '',
                                                style: text.bodySmall!.copyWith(
                                                    color:
                                                        Colors.grey.shade700),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                bookRideProvider
                                                        .driverProfileState
                                                        .data
                                                        ?.dDetail
                                                        ?.firstName ??
                                                    ' ${bookRideProvider.driverProfileState.data?.dDetail?.firstName ?? ''}',
                                                style:
                                                    text.bodyMedium!.copyWith(
                                                  fontFamily: AppFonts.medium,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 14),

                                      /// ---------------- CALL + MESSAGE BAR ----------------
                                      Row(
                                        children: [
                                          /// CALL ICON BUTTON
                                          InkWell(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            onTap: () {
                                              openDialer(bookRideProvider
                                                      .driverProfileState
                                                      .data
                                                      ?.dDetail
                                                      ?.primaryPhoneNo ??
                                                  '');
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade100,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(Icons.call,
                                                  size: 20),
                                            ),
                                          ),

                                          const SizedBox(width: 12),

                                          /// MESSAGE BUTTON FULL WIDTH
                                          Expanded(
                                            child: InkWell(
                                              onTap: () async {
                                                // Navigator.push(
                                                //     context,
                                                //     AppAnimations.fade(
                                                //         const ChatScreen()));
                                                Navigator.push(
                                                    // ignore: use_build_context_synchronously
                                                    context,
                                                    AppAnimations.fade(
                                                        ChatScreenNew(
                                                      userId: await LocalStorage
                                                              .getUserId() ??
                                                          '',
                                                      driverId: bookRideProvider
                                                          .driverCurrentId!,
                                                    )));
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 12),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade100,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                        Icons
                                                            .chat_bubble_outline,
                                                        size: 18),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Text(
                                                        "Message ${bookRideProvider.driverProfileState.data?.dDetail?.firstName} ${bookRideProvider.driverProfileState.data?.dDetail?.lastName}",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: text.bodyMedium!
                                                            .copyWith(
                                                          color: Colors.black87,
                                                          fontFamily:
                                                              AppFonts.medium,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                      const SizedBox(height: 12),
                      _rideDetails(text, bookRideProvider),
                      const SizedBox(height: 12),
                      // _partnerDetails(text),
                      // const SizedBox(height: 12),
                      _paymentSection(text),
                      const SizedBox(height: 30),
                      Consumer<BookRideProvider>(
                          builder: (context, provider, _) {
                        String status = bookRideProvider
                                .rideDetailState.data?.requestData?.status ??
                            '';
                        if (status == '1' || status == '2') {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: InkWell(
                              onTap: () {
                                {
                                  Navigator.push(
                                      context,
                                      AppAnimations.slideBottomToTop(
                                          const CancelRideReasonScreen()));
                                }
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xffFADCDC).withOpacity(.7),
                                  borderRadius: BorderRadius.circular(30),
                                  border:
                                      Border.all(color: Colors.red, width: 1.4),
                                ),
                                child: Center(
                                  child: Text(
                                    "Cancel ride",
                                    style: text.titleMedium!.copyWith(
                                        color: Colors.red,
                                        fontFamily: AppFonts.medium),
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return SizedBox();
                        }
                      }),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
  }

  // ---------------------------------------------------------
  // PAYMENT
  // ---------------------------------------------------------
  Widget _paymentSection(TextTheme text) {
    final bookRideProvider = context.read<BookRideProvider>();
    return InkWell(
        onTap: () {
          // bookRideProvider.createRazorpayOrder(
          //     rideOrderId: '640', amount: '19.5');
          // showModalBottomSheet(
          //   context: context,
          //   isScrollControlled: true,
          //   backgroundColor: Colors.transparent,
          //   builder: (context) {
          //     final text = Theme.of(context).textTheme;
          //     return paymentSuccessBottomSheet(context, text, bookRideProvider);
          //   },
          // );
          // Future.delayed(const Duration(seconds: 3), () {
          //   Navigator.pop(context);
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (_) => const RideCompletedScreen()),
          //   );
          // });
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          margin: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.1),
                blurRadius: 12,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  bookRideProvider.emitPaymentSuccess();
                },
                child: Text("Payment",
                    style: text.titleMedium!
                        .copyWith(fontFamily: AppFonts.semiBold)),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text("Price", style: text.bodyMedium),
                  const Spacer(),
                  Text(
                      "₹${bookRideProvider.rideDetailState.data?.requestData?.finalPrice ?? ''}",
                      style: text.titleMedium!
                          .copyWith(fontFamily: AppFonts.medium)),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1, color: AppColors.grey.withOpacity(.5)),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        // showPaymentDialog(navigatorKey.currentContext!,
                        //     onYes: () {},
                        //     price:
                        //         '${bookRideProvider.rideDetailState.data?.requestData?.finalPrice}',
                        //     onNo: () {});
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Pay After Ride",
                              style: text.bodyMedium!
                                  .copyWith(fontFamily: AppFonts.medium)),
                          const SizedBox(
                            height: 5,
                          ),
                          Text("Pay with Cash/Online",
                              style: text.bodyMedium!.copyWith(
                                  fontFamily: AppFonts.medium, fontSize: 10)),
                        ],
                      ),
                    ),
                    const Icon(Icons.check_circle,
                        color: AppColors.primaryColor, size: 26),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class TripAndDistanceCard extends StatelessWidget {
  final TextTheme text;
  final int elapsedSeconds;

  const TripAndDistanceCard(
      {super.key, required this.text, required this.elapsedSeconds});
  String formatTime(int seconds) {
    int h = seconds ~/ 3600;
    int m = (seconds % 3600) ~/ 60;
    int s = seconds % 60;
    return "${h.toString().padLeft(2, '0')}:"
        "${m.toString().padLeft(2, '0')}:"
        "${s.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formatTime(elapsedSeconds),
            style: text.titleMedium!.copyWith(fontFamily: AppFonts.medium),
          ),
          // const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Partner on the way",
                style: text.titleMedium!
                    .copyWith(fontFamily: AppFonts.bold, fontSize: 17),
              ),
              Text(
                "Nearby 500 m",
                style: text.titleMedium!.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void showPaymentDialog(
  BuildContext context, {
  required VoidCallback onYes,
  required String price,
  required VoidCallback onNo,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 300,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Text(
                  "You have to pay the rupees $price",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // YES BUTTON (ORANGE)
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        onYes();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 35),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          "Pay",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // NO BUTTON (OUTLINE)
                    // GestureDetector(
                    //   onTap: () {
                    //     onNo();
                    //   },
                    //   child: Container(
                    //     padding: const EdgeInsets.symmetric(
                    //         vertical: 12, horizontal: 35),
                    //     decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(30),
                    //       border: Border.all(
                    //           color: AppColors.primaryColor, width: 2),
                    //     ),
                    //     child: const Text(
                    //       "No",
                    //       style: TextStyle(
                    //         fontSize: 15,
                    //         color: AppColors.primaryColor,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget paymentSuccessBottomSheet(
    BuildContext context, TextTheme text, BookRideProvider bookRideProvider) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// SUCCESS ICON
        Image.asset(
          "assets/images/successfully.png",
          height: 60,
        ),

        const SizedBox(height: 12),

        /// TITLE
        Text(
          "Successfully paid ₹65",
          style: text.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 20),

        /// PAYMENT BREAKUP
        Column(
          children: [
            _amountRow(
                "Ride far",
                "₹${bookRideProvider.rideDetailState.data?.requestData?.price}",
                text),
            _amountRow("Coupon", "₹0", text),
            _amountRow("Ride charge", "0", text),
            _amountRow("Wallet", "₹0", text),
            const SizedBox(height: 6),
            Divider(color: Colors.grey.shade300),
            const SizedBox(height: 6),
            _amountRow(
                "Amount to be paid",
                "₹${bookRideProvider.rideDetailState.data?.requestData?.finalPrice}",
                text,
                isBold: true),
          ],
        ),

        const SizedBox(height: 22),

        /// RIDE DETAILS CARD
        _rideDetails(text, bookRideProvider),

        const SizedBox(height: 20),
      ],
    ),
  );
}

/// ONE ROW FOR AMOUNT ITEMS
Widget _amountRow(String title, String value, TextTheme text,
    {bool isBold = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Text(
          title,
          style: text.bodyMedium!.copyWith(
            color: Colors.black87,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: text.bodyMedium!.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    ),
  );
}

Widget _rideDetails(TextTheme text, BookRideProvider bookRideProvider) {
  return Container(
    padding: const EdgeInsets.all(14),
    margin: const EdgeInsets.symmetric(horizontal: 18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.05),
          blurRadius: 12,
          offset: const Offset(0, 3),
        )
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            bookRideProvider.initMapFeatures();
            // bookRideProvider.emitPaymentSuccess();
          },
          child: Text(
            "Ride Details",
            style: text.titleMedium!.copyWith(fontFamily: AppFonts.medium),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- LEFT SIDE COLUMN ----------------
            Column(
              children: [
                // Green dot
                Container(
                  height: 16,
                  width: 16,
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
                  height: 35,
                  width: 2,
                  color: Colors.black,
                ),

                const SizedBox(height: 4),

                // Red dot
                Container(
                  height: 16,
                  width: 16,
                  decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.red, blurRadius: 7)]),
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
                  Text(
                    bookRideProvider
                            .rideDetailState.data?.requestData?.picAddress ??
                        bookRideProvider.pickupLocation?.address ??
                        '',
                    style: text.bodyLarge,
                  ),

                  const SizedBox(height: 6),

                  // Divider (aligned to text)
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.grey.shade300,
                  ),

                  const SizedBox(height: 6),

                  // Drop
                  Text(
                    bookRideProvider
                            .rideDetailState.data?.requestData?.dropAddress ??
                        bookRideProvider.dropLocation?.address ??
                        '',
                    style: text.bodyLarge,
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

void showAddMoreTipDialog({
  required BuildContext context,
}) {
  if (!context.mounted) return;

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 18,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Stack(
              children: [
                // 🧾 Content
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      "Want faster ride acceptance?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Adding a small extra tip may help drivers accept your ride sooner.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 22),

                    // ✅ OK Button
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () => Navigator.maybePop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Okay",
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.white,
                            fontWeight: FontWeight.w500,
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
      );
    },
  );
}

void showRideEndNotifyDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: "RideEndNotify",
    transitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (_, __, ___) {
      // auto close after 2.5 seconds
      Future.delayed(const Duration(milliseconds: 2500), () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      });

      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Success Icon Animation
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutBack,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.green,
                          size: 46,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                const Text(
                  "Ride Completed",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  "You’ve reached your destination safely.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },

    /// Entry animation
    transitionBuilder: (_, animation, __, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          ),
          child: child,
        ),
      );
    },
  );
}
