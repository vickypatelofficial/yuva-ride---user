import 'package:flutter/material.dart';
import 'package:yuva_ride/view/custom_widgets/cusotm_back.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:yuva_ride/utils/animations.dart';
import 'package:yuva_ride/utils/app_fonts.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/view/screens/ride_booking/ride_booking_history/ride_booking_history_screen.dart';
import 'package:yuva_ride/view/screens/ride_sharing/ride_sharing_history/ride_sharing_history_screen.dart';

class MyRidesScreen extends StatelessWidget {
  const MyRidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    // SCREEN WIDTH & HEIGHT
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return CustomScaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.045),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: h * 0.015),

              /// ---------------- HEADER ----------------
              Row(
                children: [
                  CustomBack(),
                  SizedBox(width: w * 0.03),
                  Text(
                    "My rides",
                    style: text.titleMedium!.copyWith(
                      fontFamily: AppFonts.medium,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              SizedBox(height: h * 0.04),

              /// ---------------- CARD 1 ----------------
              _rideCard(
                context,
                w,
                h,
                title: "Ride Booking",
                subtitle: "View your past trips at a glance.",
                image: "assets/images/ride_booking.png",
                ontap: () {
                  Navigator.push(
                    context,
                    AppAnimations.zoomIn(
                      const RideBookingHistoryScreen(),
                    ),
                  );
                },
              ),

              SizedBox(height: h * 0.025),

              /// ---------------- CARD 2 ----------------
              _rideCard(context, w, h,
                  title: "Ride Sharing",
                  subtitle: "Check details of rides you've shared.",
                  image: "assets/images/ride_sharing2.png", ontap: () {
                Navigator.push(
                  context,
                  AppAnimations.zoomIn(
                    const RideSharingHistoryScreen(),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  /// -------------------------------------------------------
  /// REUSABLE RIDE CARD (RESPONSIVE)
  /// -------------------------------------------------------
  Widget _rideCard(BuildContext context, double w, double h,
      {required String title,
      required String subtitle,
      required String image,
      VoidCallback? ontap}) {
    final text = Theme.of(context).textTheme;

    return InkWell(
      onTap: ontap,
      child: Container(
        height: h * 0.18,
        width: double.infinity,
        padding: EdgeInsets.only(left: w * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(w * 0.045),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: w * 0.03,
              offset: Offset(0, w * 0.01),
            )
          ],
        ),
        child: Row(
          children: [
            /// ---------------- LEFT TEXT ----------------
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: h * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: text.titleMedium!.copyWith(
                              fontFamily: AppFonts.medium,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: w * 0.015),
                        const Icon(Icons.circle, size: 8, color: Colors.orange),
                      ],
                    ),
                    SizedBox(height: h * 0.007),
                    Text(
                      subtitle,
                      style: text.bodySmall!.copyWith(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// ---------------- RIGHT IMAGE CONTAINER ----------------
            Container(
              width: w * 0.28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xffFFEDD5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(w * 0.25),
                  bottomLeft: Radius.circular(w * 0.25),
                  topRight: Radius.circular(w * 0.06),
                  bottomRight: Radius.circular(w * 0.06),
                ),
              ),
              child: Image.asset(
                image,
                height: h * 0.11,
                width: w * 0.28,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
