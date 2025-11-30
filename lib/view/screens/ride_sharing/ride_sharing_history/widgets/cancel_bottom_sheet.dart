import 'package:flutter/material.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/app_fonts.dart';
import 'package:yuva_ride/view/screens/ride_sharing/ride_sharing_history/cancel_ride_share_screen.dart';

class CancelRideBottomSheet extends StatefulWidget {
  const CancelRideBottomSheet({super.key, required this.ontapConfirm});
  final VoidCallback ontapConfirm;

  @override
  State<CancelRideBottomSheet> createState() => _CancelRideBottomSheetState();
}

class _CancelRideBottomSheetState extends State<CancelRideBottomSheet> {
  int selectedIndex = 0;

  final List<String> reasons = [
    "Change in travel plans",
    "Driver not responding",
    "Wrong pickup location",
    "Trip time doesn’t suit me",
    "Emergency came up",
  ];

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      maxChildSize: 0.75,
      minChildSize: 0.40,
      builder: (context, controller) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 5,
                  width: 45,
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),

              /// Title
              Text(
                "Why do you cancel a Booking",
                style: text.titleMedium!.copyWith(
                  fontFamily: AppFonts.bold,
                  fontSize: 17,
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView.separated(
                  controller: controller,
                  itemCount: reasons.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 18),
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Expanded(
                          child: Text(
                            reasons[index],
                            style: text.bodyLarge,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => selectedIndex = index),
                          child: Icon(
                            selectedIndex == index
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: AppColors.primaryColor,
                            size: 26,
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              /// OKAY Button
              GestureDetector(
                onTap:widget.ontapConfirm,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      "Okay",
                      style: text.titleMedium!.copyWith(
                        color: Colors.white,
                        fontFamily: AppFonts.semiBold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
