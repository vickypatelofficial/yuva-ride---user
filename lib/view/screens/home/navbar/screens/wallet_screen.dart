import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:yuva_ride/view/custom_widgets/cusotm_back.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/app_fonts.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

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
                  Expanded(
                    child: AutoSizeText(
                      "Wallet",
                      maxLines: 1,
                      minFontSize: 14,
                      style: text.titleMedium!.copyWith(
                        fontFamily: AppFonts.medium,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: w * 0.03,
                      vertical: h * 0.006,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.help_outline,
                            size: 16, color: Colors.black87),
                        SizedBox(width: w * 0.01),
                        AutoSizeText(
                          "Help",
                          maxLines: 1,
                          style: text.bodySmall!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: h * 0.02),

              // ---------------- BALANCE ----------------
              AutoSizeText(
                "Total Balance",
                maxLines: 1,
                style: text.bodyMedium!.copyWith(color: Colors.black54),
              ),
              SizedBox(height: h * 0.006),

              AutoSizeText(
                "₹0",
                maxLines: 1,
                minFontSize: 32,
                style: text.headlineMedium!.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: h * 0.012),

              // TOP UP BUTTON
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.08,
                  vertical: h * 0.014,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: AutoSizeText(
                  "Top-up",
                  maxLines: 1,
                  style: text.bodyMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              SizedBox(height: h * 0.025),

              // ---------------- REFER CARD ----------------
              _referAndEarnCard(text, w, h),

              SizedBox(height: h * 0.03),

              AutoSizeText(
                "Transaction History",
                maxLines: 1,
                minFontSize: 14,
                style: text.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.medium,
                ),
              ),

              SizedBox(height: h * 0.015),

              // ---------------- TRANSACTIONS ----------------
              _transactionCard(text, w, h),
              _transactionCard(text, w, h),
              _transactionCard(text, w, h),

              SizedBox(height: h * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------
  // REFER & EARN CARD — FULLY RESPONSIVE
  // -------------------------------------------------------
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

  // -------------------------------------------------------
  // TRANSACTION CARD — FULLY RESPONSIVE & AUTO-SCALED
  // -------------------------------------------------------
  Widget _transactionCard(TextTheme text, double w, double h) {
    return Container(
      margin: EdgeInsets.only(bottom: h * 0.018),
      padding: EdgeInsets.symmetric(
        horizontal: w * 0.035,
        vertical: h * 0.018,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
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
        children: [
          Row(
            children: [
              Container(
                height: w * 0.10,
                width: w * 0.10,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    "assets/images/doller_pot.png",
                    height: w * 0.06,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(width: w * 0.03),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: w * .23,
                    child: AutoSizeText("Razor pay",
                        style: text.titleMedium!.copyWith(
                          fontSize: w * 0.04,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  AutoSizeText(
                    "Credited",
                    style: text.bodySmall!.copyWith(
                      color: Colors.grey.shade600,
                      fontSize: w * 0.034,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FittedBox(
                child: Row(
                  children: [
                    SizedBox(
                      width: w * .3,
                      child: AutoSizeText(
                        "Mon, Jul 19,2025,",
                        style: text.bodySmall!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: w * 0.034,
                        ),
                      ),
                    ),
                    SizedBox(width: w * 0.01),
                    SizedBox(
                      width: w * .17,
                      child: AutoSizeText(
                        "10:00 AM",
                        style: text.bodySmall!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: w * 0.034,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: h * 0.004),
              AutoSizeText(
                "+ ₹100",
                style: text.titleMedium!.copyWith(
                  fontSize: w * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
