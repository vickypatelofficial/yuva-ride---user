import 'package:flutter/material.dart';

class CustomRideDetailsCard extends StatelessWidget {
  final String title;
  final String seats;
  final String amount;
  final String paymentMode;
  final String note;
  final TextTheme text;

  /// ICON PATHS (Add icons inside assets/images/)
  final String seatIconPath;
  final String paymentIconPath;

  const CustomRideDetailsCard({
    super.key,
    required this.title,
    required this.seats,
    required this.amount,
    required this.paymentMode,
    required this.note,
    required this.text,
    this.seatIconPath = "assets/images/seat_icon.png",
    this.paymentIconPath = "assets/images/payment_icon.png",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.09),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ---------- TITLE ----------
          Text(
            title,
            style: text.titleMedium!.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 16),

          /// ---------- SEAT + AMOUNT ----------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(seatIconPath, height: 20, width: 20),
                  const SizedBox(width: 8),
                  Text(seats, style: text.bodyLarge),
                ],
              ),
              Text(
                amount,
                style: text.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// ---------- PAYMENT MODE ----------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(paymentIconPath, height: 22, width: 22),
                  const SizedBox(width: 8),
                  Text("Payment mode", style: text.bodyLarge),
                ],
              ),
              Text(
                paymentMode,
                style: text.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// ---------- NOTE ----------
          Text(
            "Note : $note",
            style: text.bodySmall!.copyWith(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
