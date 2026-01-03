
import 'package:flutter/material.dart';
import 'package:yuva_ride/services/local_storage.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:yuva_ride/utils/animations.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/app_fonts.dart';
import 'package:yuva_ride/view/screens/auth/login_screen.dart';
import 'package:yuva_ride/view/screens/home/navbar/screens/help_screen.dart';
import 'package:yuva_ride/view/screens/home/navbar/screens/language_screen.dart';
import 'package:yuva_ride/view/screens/home/navbar/my_ride_screen.dart';
import 'package:yuva_ride/view/screens/home/navbar/screens/notification_screen.dart';
import 'package:yuva_ride/view/screens/home/navbar/screens/profile_screen.dart';
import 'package:yuva_ride/view/screens/home/navbar/screens/rafer_and_earn_screen.dart';
import 'package:yuva_ride/view/screens/home/navbar/screens/wallet_screen.dart';

class ProfileMenuScreen extends StatelessWidget {
  const ProfileMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final divider = SizedBox(
      width: width * .80,
      child: const Divider(
        height: 1,
        color: Color(0xffFAF2F2),
      ),
    );

    return CustomScaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // **************** HEADER ****************
            Stack(
              children: [
                Container(
                  height: height * .25,
                  width: width,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(35),
                    ),
                  ),
                ),

                // Close Icon
                Positioned(
                  top: height * .02 + 30,
                  left: width * .04,
                  child: CircleAvatar(
                    radius: width * .05,
                    backgroundColor: Colors.white.withOpacity(.3),
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                ),

                // HELP
                Positioned(
                  top: height * .02 + 30,
                  right: width * .04,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          AppAnimations.slideTopToBottom(const HelpScreen()));
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.help_outline, color: Colors.white),
                        SizedBox(width: width * .015),
                        Text(
                          "Help",
                          style: text.bodyLarge!.copyWith(
                              color: Colors.white, fontFamily: AppFonts.medium),
                        ),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  top: height * .12,
                  left: width * .05,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Shiva Kumar",
                        style: text.titleLarge!.copyWith(
                            color: Colors.white, fontFamily: AppFonts.medium),
                      ),
                      SizedBox(height: height * .005),
                      Text(
                        "+917685868587",
                        style: text.bodyMedium!.copyWith(color: Colors.white70),
                      ),
                      Text(
                        "Shivakumar348@gmail.com",
                        style: text.bodyMedium!.copyWith(color: Colors.white70),
                      )
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: height * .02),

            // **************** QUICK BOXES ****************
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * .04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  quickBox(
                      image: "assets/images/wallet.png",
                      title: "Wallet",
                      ontap: () {
                        Navigator.push(
                          context,
                          AppAnimations.zoomOut(
                            const WalletScreen(),
                          ),
                        );
                      },
                      width: width),
                  quickBox(
                      image: "assets/images/my_rides.png",
                      title: "My rides",
                      ontap: () {
                        Navigator.push(
                          context,
                          AppAnimations.zoomIn(
                            const MyRidesScreen(),
                          ),
                        );
                      },
                      width: width),
                  quickBox(
                      image: "assets/images/refer_friend.png",
                      title: "Refer a friend",
                      ontap: () {
                        Navigator.push(
                          context,
                          AppAnimations.slideLeftToRight(
                            ReferAndEarnScreen(),
                          ),
                        );
                      },
                      width: width),
                ],
              ),
            ),

            SizedBox(height: height * .02),

            // **************** MENU BOX ****************
            Container(
              width: width,
              margin: EdgeInsets.symmetric(horizontal: width * .04),
              padding: EdgeInsets.symmetric(vertical: height * .01),
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
                children: [
                  menuTile(
                    text,
                    "Notification",
                    "notification.png",
                    ontap: () {
                      Navigator.push(
                        context,
                        AppAnimations.slideLeftToRight(
                          const NotificationScreen(),
                        ),
                      );
                    },
                  ),
                  divider,
                  menuTile(
                    text,
                    "Profile",
                    "profile.png",
                    ontap: () {
                      Navigator.push(
                        context,
                        AppAnimations.slideLeftToRight(
                          const MyProfileScreen(),
                        ),
                      );
                    },
                  ),
                  divider,
                  menuTile(
                    text,
                    "Languages",
                    "language.png",
                    ontap: () {
                      Navigator.push(
                        context,
                        AppAnimations.slideLeftToRight(
                          const LanguageScreen(),
                        ),
                      );
                    },
                  ),
                  divider,
                  menuTile(text, "FAQ's", "faq.png"),
                  divider,
                  menuTile(text, "Privacy Policy", "privacy.png"),
                  divider,
                  menuTile(text, "Terms and conditions", "term_condition.png"),
                  divider,
                  menuTile(text, "Cancellation Policy", "cancellation.png"),
                ],
              ),
            ),

            SizedBox(height: height * .02),

            // **************** LOGOUT BOX ****************
            Container(
              width: width,
              margin: EdgeInsets.symmetric(horizontal: width * .04),
              padding: EdgeInsets.symmetric(vertical: height * .01),
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
              child: menuTile(text, "Logout", "logout.png", hideArrow: false,
                  ontap: () {
                showLogoutDialog(context);
              }),
            ),

            SizedBox(height: height * .05),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------
  // QUICK BOX
  // ----------------------------------------------------
  Widget quickBox(
      {required String image,
      required String title,
      required double width,
      required VoidCallback ontap}) {
    return InkWell(
      onTap: ontap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: width * .32,
        width: width * .28,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              height: width * .12,
              fit: BoxFit.contain,
            ),
            SizedBox(height: width * .02),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------
  // MENU TILE
  // ----------------------------------------------------
  Widget menuTile(TextTheme text, String title, String icon,
      {bool hideArrow = false, VoidCallback? ontap}) {
    return InkWell(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Image.asset(
              "assets/images/$icon",
              height: 24,
              width: 24,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: text.bodyLarge!.copyWith(fontFamily: AppFonts.medium),
              ),
            ),
            if (!hideArrow)
              const Icon(Icons.arrow_forward_ios,
                  size: 15, color: Colors.black45),
          ],
        ),
      ),
    );
  }
}

Future<void> showLogoutDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.logout_rounded,
                size: 42,
                color: Colors.red,
              ),
              const SizedBox(height: 12),
              const Text(
                "Logout?",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Are you sure you want to logout?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        LocalStorage.clearLocalStorate();
                        Navigator.pushAndRemoveUntil(
                            context,
                            AppAnimations.fade(const LoginScreen()),
                            (value) => false);
                      },
                      child: const Text(
                        "Logout",
                        style: TextStyle(fontSize: 16, color: AppColors.white),
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
  );
}
