import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:yuva_ride/view/custom_widgets/cusotm_back.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/app_fonts.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return CustomScaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: w * 0.045),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: h * 0.015),

              // ---------------- HEADER ----------------
              Row(
                children: [
                  CustomBack(),
                  SizedBox(width: w * 0.03),
                  Text(
                    "Help",
                    style: text.titleMedium!.copyWith(
                      fontFamily: AppFonts.medium,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              SizedBox(height: h * 0.030),

              // ---------------- DESCRIPTION ----------------
              AutoSizeText(
                "Got a question or facing an issue? Our support team is available 24×7 to assist you with anything — from ride concerns to payments, deliveries, or app troubles.",
                maxLines: 4,
                style: text.bodyMedium!.copyWith(
                    height: 1.4,
                    color: Colors.black87,
                    fontFamily: AppFonts.regular),
              ),

              SizedBox(height: h * 0.035),

              Center(
                child: Text(
                  "Choose how you’d like to reach us:",
                  style: text.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.medium,
                  ),
                ),
              ),

              SizedBox(height: h * 0.040),

              // ---------------- CHAT SECTION ----------------
              Center(
                child: Image.asset(
                  "assets/images/chat_help.png",
                  height: h * 0.12,
                ),
              ),
              SizedBox(height: h * 0.015),

              Center(
                child: AutoSizeText(
                  "Get instant help through live chat",
                  maxLines: 1,
                  style: text.bodyMedium,
                ),
              ),

              SizedBox(height: h * 0.015),

              Center(
                child: _orangeButton(
                  context,
                  text: "Chat with us",
                  icon: Image.asset(
                    'assets/images/chat.png',
                    height: 20,
                    width: 20,
                  ),
                ),
              ),

              SizedBox(height: h * 0.055),

              // ---------------- CALL SECTION ----------------
              Center(
                child: Image.asset(
                  "assets/images/call_support.png",
                  height: h * 0.14,
                ),
              ),
              SizedBox(height: h * 0.015),

              Center(
                child: AutoSizeText(
                  "Speak directly with our support team",
                  maxLines: 2,
                  style: text.bodyMedium,
                ),
              ),

              SizedBox(height: h * 0.015),

              Center(
                child: _orangeButton(
                  context,
                  text: "Call Us",
                  icon: Image.asset(
                    'assets/images/call.png',
                    height: 20,
                    width: 20,
                  ),
                ),
              ),

              SizedBox(height: h * 0.050),

              Center(
                child: AutoSizeText(
                  "Need Help? We're Here for You!",
                  maxLines: 2,
                  style: text.bodyMedium!.copyWith(fontFamily: AppFonts.bold),
                ),
              ),
              SizedBox(height: h * 0.050),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------- ORANGE BUTTON -------------------------
  Widget _orangeButton(BuildContext context,
      {required String text, required Widget icon}) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final themeText = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: w * 0.12,
        vertical: h * 0.014,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(width: w * 0.015),
          AutoSizeText(
            text,
            maxLines: 1,
            style: themeText.titleMedium!.copyWith(
              color: Colors.white,
              fontFamily: AppFonts.medium,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
