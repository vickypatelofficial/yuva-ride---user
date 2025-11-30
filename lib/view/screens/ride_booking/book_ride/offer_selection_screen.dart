import 'package:flutter/material.dart';
import 'package:yuva_ride/view/custom_widgets/cusotm_back.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/app_fonts.dart';

class ApplyCouponsScreen extends StatelessWidget {
  const ApplyCouponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return CustomScaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: 120,
            padding: const EdgeInsets.only(top: 10, left: 18, right: 18),
            width: double.infinity,
            color: AppColors.primaryColor,
            child: Row(
              children: [
                const CustomBack(),
                const SizedBox(width: 12),
                Text(
                  "Apply Coupons",
                  style: text.titleMedium!.copyWith(
                      color: Colors.white, fontFamily: AppFonts.medium),
                ),
              ],
            ),
          ),

          /// WHITE TEXT FIELD CARD OVERLAP EFFECT
          Transform.translate(
            offset: const Offset(0, -22),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Enter Coupons code",
                          hintStyle: text.bodyMedium,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          border: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    Text(
                      "Apply",
                      style: text.titleMedium!.copyWith(
                        color: AppColors.primaryColor,
                        fontFamily: AppFonts.medium,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          /// MAIN BODY
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("More Offers",
                      style: text.titleLarge!
                          .copyWith(fontFamily: AppFonts.semiBold)),
                  const SizedBox(height: 16),
                  Column(
                    children:
                        List.generate(6, (index) => _couponCard(text, context)),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _couponCard(TextTheme text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          //
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.07),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xff0F59ED),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "20% OFF",
                        style: text.labelLarge!.copyWith(
                            color: Colors.white, fontFamily: AppFonts.medium),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "On First Ride Booking",
                      style: text.titleMedium!.copyWith(
                          fontFamily: AppFonts.medium, color: Colors.black),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Valid until 22 March 2025",
                      style: text.labelMedium!
                          .copyWith(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),

                const Spacer(),

                /// APPLY BUTTON
                Text(
                  "Apply",
                  style: text.titleMedium!.copyWith(
                    color: AppColors.primaryColor,
                    fontFamily: AppFonts.medium,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
