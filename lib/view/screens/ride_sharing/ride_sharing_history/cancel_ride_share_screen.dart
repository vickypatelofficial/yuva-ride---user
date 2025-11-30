import 'package:flutter/material.dart';
import 'package:yuva_ride/utils/animations.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/app_fonts.dart';
import 'package:yuva_ride/view/custom_widgets/custom_button.dart';
import 'package:yuva_ride/view/screens/home/home_screen.dart';

class CancelledRidesShareScreen extends StatelessWidget {
  const CancelledRidesShareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/cancelled_ride.png", // Export image here
              height: 230, width: double.infinity,
            ),
            const SizedBox(height: 20),
            Text(
              "Ride cancelled",
              style: text.titleLarge!.copyWith(
                fontFamily: AppFonts.medium,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "We're sorry your ride didn't work out. Hope\nto see you on the next one!",
              textAlign: TextAlign.center,
              style: text.bodyMedium!.copyWith(color: Colors.black54),
            ),
            const SizedBox(height: 40),
            CustomButton(
                text: 'Explore more rides',
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context,
                      AppAnimations.fade(const HomeScreen()), (value) => false);
                })
          ],
        ),
      ),
    );
  }
}
