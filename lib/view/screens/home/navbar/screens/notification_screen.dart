
import 'package:flutter/material.dart';
import 'package:yuva_ride/view/custom_widgets/cusotm_back.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/app_fonts.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool pushEnabled = true;

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
              Row(
                children: [
                  const CustomBack(),
                  SizedBox(width: w * 0.03),
                  Text(
                    "Notification",
                    style: text.titleMedium!.copyWith(
                      fontFamily: AppFonts.medium,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              SizedBox(height: h * 0.03),

              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.04,
                  vertical: h * 0.018,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffF1F5FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    // TEXTS
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Push Notifications",
                            style: text.titleMedium!.copyWith(
                              fontFamily: AppFonts.medium,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: h * 0.004),
                          Text(
                            "Keep it on, if you want to receive notifications",
                            style: text.bodySmall!.copyWith(
                              color: Colors.black54,
                              fontSize: w * 0.035,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // SWITCH BUTTON
                    Switch(
                      value: pushEnabled,
                      activeColor: Colors.white,
                      activeTrackColor: AppColors.primaryColor,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.grey.shade400,
                      onChanged: (val) {
                        setState(() => pushEnabled = val);
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: h * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}
