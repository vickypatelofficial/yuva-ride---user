import 'package:flutter/material.dart';
import 'package:yuva_ride/utils/animations.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/app_fonts.dart';
import 'package:yuva_ride/view/custom_widgets/custom_button.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:yuva_ride/view/screens/home/home_screen.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return CustomScaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),

          /// SUCCESS IMAGE
          Image.asset(
            "assets/images/completed_badge.png",
            height: 90,
            width: 90,
          ),

          const SizedBox(height: 24),

          /// TITLE
          Text(
            "Successfully",
            style: text.titleMedium!.copyWith(
              fontFamily: AppFonts.semiBold,
              fontSize: 20,
            ),
          ),
          Text(
            "Booking completed",
            style: text.titleMedium!.copyWith(
              fontFamily: AppFonts.semiBold,
              fontSize: 20,
            ),
          ),

          const SizedBox(height: 80),

          /// BUTTON
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: CustomButton(
              text: "Review Bookings",
              onPressed: () {},
              height: 48,
            ),
          ),

          const SizedBox(height: 18),

          /// BACK TEXT
          InkWell(
            onTap: () {
              Navigator.pushAndRemoveUntil(context,
                  AppAnimations.fade(const HomeScreen()), (value) => false);
            },
            child: Text(
              "Back",
              style: text.bodyLarge!.copyWith(
                color: AppColors.primaryColor,
                fontFamily: AppFonts.medium,
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
