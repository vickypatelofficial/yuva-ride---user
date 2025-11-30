import 'package:flutter/material.dart';
import 'package:yuva_ride/utils/animations.dart';
import 'package:yuva_ride/utils/app_fonts.dart';
import 'package:yuva_ride/view/custom_widgets/customAppBar.dart';
import 'package:yuva_ride/view/custom_widgets/custom_button.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:yuva_ride/view/screens/ride_sharing/ride_sharing_history/widgets/custom_ride_detail_card.dart';
import 'package:yuva_ride/view/screens/ride_sharing/share_ride/booking_success_screen.dart.dart';

class CheckDetailsScreen extends StatelessWidget {
  const CheckDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return CustomScaffold(
      appBar: const CustomAppBar(
        title: 'Check Details',
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          /// ---------------------- BODY ----------------------
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// DATE LABEL
                  Text(
                    "Fri, Aug 08,2025",
                    style: text.titleMedium!.copyWith(
                        fontFamily: AppFonts.semiBold,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),

                  /// TIMELINE UI
                  _timelineSection(text),

                  const SizedBox(height: 26),

                  /// RIDE DETAILS CARD
                  Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.09),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// ---------- TITLE ----------
                        Text(
                          "Ride Details",
                          style: text.titleMedium!.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// ---------- SEAT + AMOUNT ----------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset("assets/images/seat_icon.png",
                                    height: 20, width: 20),
                                const SizedBox(width: 8),
                                Text("1 seat", style: text.bodyLarge),
                              ],
                            ),
                            Text(
                              "₹350.00",
                              style: text.bodyLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        /// ---------- PAYMENT MODE ----------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset("assets/images/payment_icon.png",
                                    height: 22, width: 22),
                                const SizedBox(width: 8),
                                Text("Payment mode", style: text.bodyLarge),
                              ],
                            ),
                            Text(
                              "Cash",
                              style: text.bodyLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        /// ---------- NOTE ----------
                        Text(
                          "Note : Pay in the car",
                          style: text.bodySmall!.copyWith(
                            color: Colors.black54,
                          ),
                        ),

                        const SizedBox(height: 18),

                        /// ---------- TEXTFIELD (inside same container) ----------
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            "Sent  message to Suresh kumar",
                            style: text.bodyMedium!.copyWith(
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// MESSAGE BOX
                ],
              ),
            ),
          ),

          /// ---------------------- CONFIRM BUTTON ----------------------
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            width: double.infinity,
            child: CustomButton(
              text: "Confirm",
              onPressed: () {
                Navigator.push(context, AppAnimations.fade(const BookingSuccessScreen()));
              },
              height: 48,
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------------- TIMELINE SECTION ----------------------
  Widget _timelineSection(TextTheme text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// TIMES COLUMN
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("15:30", style: text.bodyLarge),
            const SizedBox(height: 12),
            Text(
              "2hrs",
              style: text.bodySmall!.copyWith(color: Colors.black45),
            ),
            const SizedBox(height: 12),
            Text("15:30", style: text.bodyLarge),
          ],
        ),

        const SizedBox(width: 14),

        /// DOTS + LINES
        Column(
          children: [
            const CircleAvatar(radius: 6, backgroundColor: Colors.green),
            Container(
                height: 38, width: 2, color: Colors.black.withOpacity(.4)),
            const CircleAvatar(radius: 6, backgroundColor: Colors.red),
          ],
        ),

        const SizedBox(width: 14),

        /// LOCATIONS
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Peddamma talli temple",
                style: text.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Shri Peddamma talli Devalayam, Hyderabad, Telangana",
                style: text.bodySmall!.copyWith(color: Colors.black54),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 20),
              Text(
                "Peddamma talli temple",
                style: text.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Shri Peddamma talli Devalayam, Hyderabad, Telangana",
                style: text.bodySmall!.copyWith(color: Colors.black54),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
