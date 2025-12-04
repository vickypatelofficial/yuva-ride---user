import 'package:flutter/material.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:yuva_ride/utils/animations.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/view/screens/home/home_screen.dart';
import 'package:yuva_ride/view/screens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> scaleAnim;
  late Animation<double> fadeAnim;
  late Animation<Offset> slideAnim;

  @override
  void initState() {
    super.initState();

    //  Animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    //  Bounce (scale)
    scaleAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    //  Fade-in
    fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    //  Slide-up text
    slideAnim = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Start animation
    _controller.forward();

    // Navigate to next screen
    Future.delayed(const Duration(seconds: 3), () async {
      await precacheImage(const AssetImage("assets/images/bike.png"), context);
      await precacheImage(const AssetImage("assets/images/auto.png"), context);
      await precacheImage(const AssetImage("assets/images/car.png"), context);
      await precacheImage(
          const AssetImage("assets/images/ride_booking.png"), context);
      await precacheImage(
          const AssetImage("assets/images/ride_sharing.png"), context);

      Future.microtask(() {
        Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            AppAnimations.fade(const OnboardingScreen(),
                transitionDuration: const Duration(milliseconds: 2300)));
      });

      // ignore: use_build_context_synchronously
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: fadeAnim,
          child: ScaleTransition(
            scale: scaleAnim,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🔥 Your Logo (with premium animate)
                Image.asset(
                  "assets/images/logo.png",
                  width: 200,
                  height: 200,
                ),

                const SizedBox(height: 20),

                // 🔥 Slide-up tagline
                SlideTransition(
                  position: slideAnim,
                  child: const Text(
                    "Yuva Ride",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
