import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yuva_ride/main.dart';
import 'package:yuva_ride/view/custom_widgets/cusotm_back.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yuva_ride/utils/animations.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/app_fonts.dart';
import 'package:yuva_ride/view/screens/ride_booking/after_booking/cancel_ride_screen.dart';
import 'package:yuva_ride/view/screens/ride_booking/after_booking/chat_screen.dart';
import 'package:yuva_ride/view/screens/ride_booking/after_booking/ride_completed_screen.dart';
import 'package:yuva_ride/view/screens/ride_booking/after_booking/widgets/ripple_loader.dart';
import 'package:yuva_ride/view/screens/ride_booking/after_booking/widgets/shimmer_card_driver.dart';

class PartnerOnTheWayScreen extends StatefulWidget {
  const PartnerOnTheWayScreen({super.key});

  @override
  State<PartnerOnTheWayScreen> createState() => _PartnerOnTheWayScreenState();
}

class _PartnerOnTheWayScreenState extends State<PartnerOnTheWayScreen> {
  GoogleMapController? mapController;
  bool isDriverFound = false;
  Timer? rideTimer;

  int elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    startRideTimer();
  }

  void startRideTimer() async {
    await Future.delayed(const Duration(seconds: 10));
    isDriverFound = true;
    rideTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        elapsedSeconds++;
      });
    });
  }

  @override
  void dispose() {
    rideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            CustomBack(),
            const SizedBox(width: 12),
            Text(
              "Partner on the way",
              style: text.titleMedium!.copyWith(
                color: Colors.white,
                fontFamily: AppFonts.medium,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          /// MAP
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Stack(
              children: [
                SizedBox(
                  height: 300,
                  child: GoogleMap(
                    onMapCreated: (c) => mapController = c,
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(17.4065, 78.4772),
                      zoom: 14.5,
                    ),
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                  ),
                ),
                if (!isDriverFound)
                  Positioned.fill(
                      top: -screenHeight * .4,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: RippleLoader())
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
                    !isDriverFound
                        ? Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Text(
                                  "Matching with your rider… don't go anywhere...",
                                  style: text.titleMedium!.copyWith(
                                      fontFamily: AppFonts.bold, fontSize: 17),
                                ),
                              ),
                              const SizedBox(height: 12),
                              const ShimmerDriverCard()
                            ],
                          )
                        : Column(
                            children: [
                              TripAndDistanceCard(text: text,elapsedSeconds: elapsedSeconds),
                              const SizedBox(height: 12),
                              _otpBox(text),
                              const SizedBox(height: 12),
                              _driverCard(text),
                            ],
                          ),
                    const SizedBox(height: 12),
                    _rideDetails(text),
                    const SizedBox(height: 12),
                    _partnerDetails(text),
                    const SizedBox(height: 12),
                    _paymentSection(text),
                    const SizedBox(height: 30),
                    _cancelButton(text),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _otpBox(TextTheme text) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.symmetric(horizontal: 18),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Share the code to unlock\nyour ride.", style: text.bodyMedium),
          const SizedBox(height: 6),
          Text(
            "9586",
            style: text.headlineSmall!
                .copyWith(fontFamily: AppFonts.medium, letterSpacing: 2),
          ),
        ],
      ),
    );
  }

  Widget _driverCard(TextTheme text) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.symmetric(horizontal: 18),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ---------------- DRIVER ROW ----------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  "assets/images/driver.png",
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 60,
                      width: 60,
                    );
                  },
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "TS26QR8833",
                    style: text.titleMedium!.copyWith(
                      fontFamily: AppFonts.medium,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Bike",
                    style:
                        text.bodySmall!.copyWith(color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Suresh Kumar",
                    style: text.bodyMedium!.copyWith(
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
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.call, size: 20),
              ),

              const SizedBox(width: 12),

              /// MESSAGE BUTTON FULL WIDTH
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context, AppAnimations.fade(const ChatScreen()));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.chat_bubble_outline, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          "Message suresh Kumar",
                          style: text.bodyMedium!.copyWith(
                            color: Colors.black87,
                            fontFamily: AppFonts.medium,
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
    );
  }

  Widget _rideDetails(TextTheme text) {
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
          Text(
            "Ride Details",
            style: text.titleMedium!.copyWith(fontFamily: AppFonts.medium),
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
                    Text(
                      "9-120, Madhapur metro station,\nHyderabad",
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
                      "9-120, Hitech metro station,\nHyderabad",
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

  // ---------------------------------------------------------
  // PARTNER DETAILS
  // ---------------------------------------------------------
  Widget _partnerDetails(TextTheme text) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP ROW — Avatar + Name + Subtitle
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: AssetImage('assets/images/profile_image.png'),
              ),
              const SizedBox(width: 14),

              /// Name + Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Partner Suresh kumar",
                      style: text.titleMedium!.copyWith(
                        fontFamily: AppFonts.medium,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),

                    /// Subtitle — overflow FIXED
                    Text(
                      "Our partner will speak in Telugu, English",
                      style: text.bodySmall!.copyWith(
                        color: Colors.black.withOpacity(.6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis, // prevents overflow
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// RATING + TRIPS
          Row(
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/images/star.png",
                    height: 18,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 18,
                      width: 18,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "2.5 Rating",
                    style: text.bodySmall!.copyWith(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 26),
              Row(
                children: [
                  Image.asset("assets/images/bike_icon.png",
                      height: 20,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox(
                            height: 18,
                            width: 18,
                          )),
                  const SizedBox(width: 6),
                  Text(
                    "5 trips",
                    style: text.bodySmall!.copyWith(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // PAYMENT
  // ---------------------------------------------------------
  Widget _paymentSection(TextTheme text) {
    return InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              final text = Theme.of(context).textTheme;
              return paymentSuccessBottomSheet(context, text);
            },
          );
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RideCompletedScreen()),
            );
          });
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
              Text("Payment",
                  style: text.titleMedium!
                      .copyWith(fontFamily: AppFonts.semiBold)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text("Price", style: text.bodyMedium),
                  const Spacer(),
                  Text("₹45",
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Pay After Ride",
                            style: text.bodyMedium!
                                .copyWith(fontFamily: AppFonts.medium)),
                        const SizedBox(
                          height: 5,
                        ),
                        Text("Pay with cash/ Qr code",
                            style: text.bodyMedium!.copyWith(
                                fontFamily: AppFonts.medium, fontSize: 10)),
                      ],
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

  Widget _cancelButton(TextTheme text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              AppAnimations.slideBottomToTop(const CancelRideReasonScreen()));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xffFADCDC).withOpacity(.7),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.red, width: 1.4),
          ),
          child: Center(
            child: Text(
              "Cancel ride",
              style: text.titleMedium!
                  .copyWith(color: Colors.red, fontFamily: AppFonts.medium),
            ),
          ),
        ),
      ),
    );
  }

  Widget paymentSuccessBottomSheet(BuildContext context, TextTheme text) {
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
              _amountRow("Ride far", "₹45", text),
              _amountRow("Coupon", "₹0", text),
              _amountRow("Ride charge", "₹10", text),
              _amountRow("Wallet", "-₹10", text),
              const SizedBox(height: 6),
              Divider(color: Colors.grey.shade300),
              const SizedBox(height: 6),
              _amountRow("Amount to be paid", "₹45", text, isBold: true),
            ],
          ),

          const SizedBox(height: 22),

          /// RIDE DETAILS CARD
          _rideDetails(text),

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
