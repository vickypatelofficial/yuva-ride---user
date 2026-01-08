import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yuva_ride/provider/book_ride_provider.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:yuva_ride/utils/animations.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/app_fonts.dart';
import 'package:yuva_ride/view/screens/home/home_screen.dart';

class RideCompletedScreen extends StatefulWidget {
  const RideCompletedScreen({super.key});

  @override
  State<RideCompletedScreen> createState() => _RideCompletedScreenState();
}

class _RideCompletedScreenState extends State<RideCompletedScreen> {
  bool showDialog = true;
  @override
  void initState() {
    super.initState();

    // AUTO NAVIGATE AFTER 3 SECONDS
    Future.delayed(const Duration(seconds: 3), () {
      goToHome();
    });
  }

  void goToHome() {
    if (showDialog) {
      showDialog = false;
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: "Rating",
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, anim1, anim2) {
          return const SizedBox.shrink();
        },
        transitionBuilder: (context, anim, _, child) {
          return Transform.scale(
            scale: anim.value,
            child: Opacity(
              opacity: anim.value,
              child: _RatingDialog(),
            ),
          );
        },
      );
    } else {
      Future.microtask(() {
        Navigator.pushAndRemoveUntil(
            // ignore: use_build_context_synchronously
            context,
            AppAnimations.fade(const HomeScreen(),
                transitionDuration: const Duration(milliseconds: 2300)),
            (value) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookRideProvider = context.read<BookRideProvider>();
    final text = Theme.of(context).textTheme;

    double w = MediaQuery.of(context).size.width; // screen width
    double h = MediaQuery.of(context).size.height; // screen height

    return CustomScaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ---------------- TOP CURVED AREA ----------------
          Stack(
            children: [
              Container(
                height: h * 0.40,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xffFFEDD5),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(w * 0.55),
                  ),
                ),
              ),
              Positioned(
                top: h * 0.07,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/ride_completed.png",
                      height: w * 0.38,
                    ),
                    SizedBox(height: h * 0.015),
                    Text(
                      "Successfully\nRide completed",
                      textAlign: TextAlign.center,
                      style: text.headlineSmall!.copyWith(
                        fontFamily: AppFonts.medium,
                        fontWeight: FontWeight.bold,
                        fontSize: w * 0.055,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: h * 0.03),

          // ---------------- PAYMENT SUMMARY ----------------
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.08),
            child: Column(
              children: [
                _summaryRow(
                    "Ride far",
                    "₹${bookRideProvider.rideDetailState.data?.requestData?.price}",
                    text,
                    w),
                _summaryRow("Coupon", "₹0", text, w),
                _summaryRow("Ride charge", "₹45", text, w),
                Divider(
                  color: Colors.grey.shade400,
                  height: h * 0.03,
                ),
                _summaryRow(
                    "Amount Paid",
                    "₹${bookRideProvider.rideDetailState.data?.requestData?.finalPrice}",
                    text,
                    w,
                    bold: true),
              ],
            ),
          ),

          SizedBox(height: h * 0.03),

          // ---------------- RIDE DETAILS ----------------
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.06),
            child: _rideDetails(text, w, h),
          ),

          const Spacer(),

          // ---------------- BACK TO HOME BUTTON ----------------
          Padding(
            padding: EdgeInsets.only(
                bottom: h * 0.03, left: w * 0.05, right: w * 0.05),
            child: GestureDetector(
              // onTap: goToHome,
              onTap: () {
                bookRideProvider.emitPaymentSuccess();
              },
              child: Container(
                height: h * 0.065,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(w * 0.08),
                ),
                child: Center(
                  child: Text(
                    "Back to Home",
                    style: text.titleMedium!.copyWith(
                      color: Colors.white,
                      fontSize: w * 0.045,
                      fontFamily: AppFonts.medium,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // PAYMENT SUMMARY ROW
  Widget _summaryRow(String title, String value, TextTheme text, double w,
      {bool bold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: w * 0.015),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: text.bodyLarge!.copyWith(
                fontSize: w * 0.04,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(
            value,
            style: text.bodyLarge!.copyWith(
              fontSize: w * 0.04,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- RIDE DETAILS SECTION ----------------
  Widget _rideDetails(TextTheme text, double w, double h) {
    final bookRideProvider = context.read<BookRideProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Ride Details",
          style: text.titleMedium!.copyWith(
            fontFamily: AppFonts.medium,
            fontSize: w * 0.05,
          ),
        ),
        SizedBox(height: h * 0.015),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LEFT DOTS + LINE
            Column(
              children: [
                Container(
                  height: w * 0.04,
                  width: w * 0.04,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(height: h * 0.008),
                Container(
                  height: h * 0.06,
                  width: 2,
                  color: Colors.black,
                ),
                SizedBox(height: h * 0.008),
                Container(
                  height: w * 0.04,
                  width: w * 0.04,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),

            SizedBox(width: w * 0.04),

            // RIGHT TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    " ${bookRideProvider.rideDetailState.data?.requestData?.picAddress}",
                    style: text.bodyLarge!.copyWith(fontSize: w * 0.04),
                  ),
                  SizedBox(height: h * 0.01),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.grey.shade300,
                  ),
                  SizedBox(height: h * 0.01),
                  Text(
                    " ${bookRideProvider.rideDetailState.data?.requestData?.dropAddress}",
                    style: text.bodyLarge!.copyWith(fontSize: w * 0.04),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _RatingDialog extends StatelessWidget {
  const _RatingDialog();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: w * 0.88,
          padding: EdgeInsets.all(w * 0.05),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.15),
                blurRadius: 20,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// CLOSE ICON
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, size: w * 0.065),
                ),
              ),

              SizedBox(height: h * 0.005),

              /// DRIVER PROFILE + TITLE
              Row(
                children: [
                  /// DRIVER IMAGE
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.asset(
                      "assets/images/driver.png",
                      height: w * 0.16,
                      width: w * 0.16,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: w * 0.04),

                  /// TITLE
                  Expanded(
                    child: Text(
                      "How was your ride with\nSuresh Kumar",
                      style: text.titleMedium!.copyWith(
                        fontSize: w * 0.047,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.medium,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: h * 0.02),

              /// STAR RATING
              Row(
                children: List.generate(5, (i) {
                  return Padding(
                    padding: EdgeInsets.only(right: w * 0.02),
                    child: Icon(
                      i < 4 ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: w * 0.075,
                    ),
                  );
                }),
              ),

              SizedBox(height: h * 0.02),

              /// SMALL SUBTEXT
              Text(
                "Great, what did you like most",
                style: text.bodyMedium!.copyWith(
                  fontSize: w * 0.04,
                  color: Colors.black87,
                ),
              ),

              SizedBox(height: h * 0.02),

              /// TEXTFIELD
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade300),
                  color: Colors.grey.shade100,
                ),
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                child: TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                    hintText: "Describe about your experience, Here",
                    hintStyle: text.bodySmall!.copyWith(
                      fontSize: w * 0.038,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),

              SizedBox(height: h * 0.02),

              /// SUBMIT BUTTON
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    // close dialog then navigate to home
                    Navigator.pop(context);
                    Future.microtask(() {
                      Navigator.pushAndRemoveUntil(
                        context,
                        AppAnimations.fade(
                          const HomeScreen(),
                          transitionDuration:
                              const Duration(milliseconds: 2300),
                        ),
                        (v) => false,
                      );
                    });
                  },
                  child: Container(
                    height: 40,
                    width: 150,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        "Submit",
                        style: text.titleMedium!.copyWith(
                          color: Colors.white,
                          fontSize: w * 0.045,
                          fontFamily: AppFonts.medium,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: h * 0.01),
            ],
          ),
        ),
      ),
    );
  }
}
