import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:yuva_ride/view/custom_widgets/cusotm_back.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:flutter/services.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/app_fonts.dart';

class ReferAndEarnScreen extends StatelessWidget {
  ReferAndEarnScreen({super.key});

  final String referralCode = "#9548678";

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

              /// ---------------- HEADER ----------------
              Row(
                children: [
                  CustomBack(),
                  SizedBox(width: w * 0.04),
                  AutoSizeText(
                    "Refer and earn",
                    maxLines: 1,
                    style: text.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.medium,
                    ),
                  ),
                ],
              ),

              SizedBox(height: h * 0.030),

              /// ---------------- REFER CARD (same as wallet card) ----------------
              _referAndEarnCard(text, w, h),

              SizedBox(height: h * 0.030),

              /// ---------------- TITLE ----------------
              AutoSizeText(
                "Invite all your friend to Yuva rider",
                maxLines: 2,
                style: text.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.medium,
                ),
              ),

              SizedBox(height: h * 0.020),

              /// ---------------- SUBTITLE ----------------
              AutoSizeText(
                "Refer & Earn in 3 Easy Steps",
                maxLines: 1,
                style: text.titleMedium!.copyWith(
                  fontFamily: AppFonts.medium,
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(height: h * 0.015),

              _stepsText(text, w),

              SizedBox(height: h * 0.030),

              _referralBox(context, text, w, h),

              SizedBox(height: h * 0.050),

              GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: h * 0.016),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: AutoSizeText(
                      "Continue",
                      maxLines: 1,
                      style: text.titleMedium!.copyWith(
                        color: Colors.white,
                        fontFamily: AppFonts.medium,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: h * 0.030),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------- REFER CARD ------------------------------
  Widget _referAndEarnCard(TextTheme text, double w, double h) {
    return Container(
      height: w * .45,
      decoration: BoxDecoration(
        color: AppColors.yellow,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // -------- LEFT TEXT AREA ----------
          Expanded(
            flex: 65,
            child: Padding(
              padding: EdgeInsets.all(w * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText(
                    "Invite. Share. Earn",
                    style: text.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    minFontSize: 12,
                  ),
                  SizedBox(height: h * 0.006),
                  AutoSizeText(
                    "Get exciting benefits for each referral.",
                    style: text.bodyMedium!.copyWith(
                      color: Colors.black87,
                    ),
                    maxLines: 3,
                    minFontSize: 11,
                  ),
                  SizedBox(height: h * 0.018),

                  // Elevated, decorated InkWell button
                  Material(
                    color: Colors.transparent,
                    elevation: 4,
                    borderRadius: BorderRadius.circular(30),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {
                          // TODO: handle refer action
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: w * 0.035,
                            vertical: h * 0.010,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: w * 0.3,
                                child: AutoSizeText(
                                  "Refer and earn",
                                  maxLines: 1,
                                  minFontSize: 10,
                                  style: text.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(width: w * 0.02),
                              const Icon(Icons.arrow_right_alt, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // -------- IMAGE --------
          Container(
            height: w * .45,
            width: w * .3,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(w * .4),
                bottomLeft: Radius.circular(w * .4),
                bottomRight: const Radius.circular(20),
                topRight: const Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  offset: const Offset(-6, 0),
                  blurRadius: 12,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  offset: const Offset(-2, 0),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(w * 0.02),
              child: Image.asset(
                "assets/images/raferAndEarn.png",
                height: w * .2,
                width: w * 0.2,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------- STEPS TEXT ------------------------------
  Widget _stepsText(TextTheme text, double w) {
    return AutoSizeText(
      """1. Share your unique referral link with friends, 
   family, or anyone you know.

2. Invite them to sign up and place their first 
   ride through Yuva rider

3. Earn ₹100 cashback instantly when their 
   ride is completed successfully.""",
      style: text.bodyMedium!.copyWith(
        height: 1.5,
        fontSize: w * 0.038,
      ),
      maxLines: 20,
    );
  }

  // --------------------------- REFERRAL BOX -----------------------------
  Widget _referralBox(
      BuildContext context, TextTheme text, double w, double h) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: w * 0.04,
        vertical: h * 0.014,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: AutoSizeText(
              referralCode,
              maxLines: 1,
              style: text.bodyLarge!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: referralCode));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Copied!"),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: AutoSizeText(
              "Copy",
              maxLines: 1,
              style: text.bodyMedium!.copyWith(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
