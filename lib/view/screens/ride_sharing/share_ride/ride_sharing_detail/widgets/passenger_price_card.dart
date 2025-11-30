import 'package:flutter/material.dart';
import 'package:yuva_ride/utils/app_colors.dart';

class PassengerPriceCard extends StatelessWidget {
  final TextTheme text;

  final String passengerText;
  final String priceText;

  final IconData passengerIcon;
  final Color passengerIconColor;
  final Color leftBoxColor;
  final Color rightBoxColor;

  const PassengerPriceCard({
    super.key,
    required this.text,
    required this.passengerText,
    required this.priceText,
    this.passengerIcon = Icons.person_outline,
    this.passengerIconColor = Colors.black54,
    this.leftBoxColor = Colors.white,
    this.rightBoxColor = AppColors.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // LEFT — PASSENGER BOX
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: leftBoxColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(.03),
                    blurRadius: 8,
                    offset: const Offset(0, 4))
              ],
            ),
            child: Row(
              children: [
                Icon(passengerIcon, color: passengerIconColor),
                const SizedBox(width: 8),
                Text(passengerText, style: text.bodyLarge),
                const Spacer(),
                Text(
                  priceText,
                  style: text.titleMedium!.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
