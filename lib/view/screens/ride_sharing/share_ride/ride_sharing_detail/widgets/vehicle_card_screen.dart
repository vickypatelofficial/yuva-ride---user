import 'package:flutter/material.dart';

class VehicleCard extends StatelessWidget {
  final TextTheme text;

  final String vehicleName;
  final String vehicleLabel;
  final String vehicleImage;

  // verification title
  final String profileVerifiedText;

  // list of verification items
  final List<String> verificationList;

  const VehicleCard({
    super.key,
    required this.text,
    required this.vehicleName,
    required this.vehicleLabel,
    required this.vehicleImage,
    required this.profileVerifiedText,
    required this.verificationList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ---------------- TOP VEHICLE ROW ----------------
          Row(
            children: [
              Image.asset(vehicleImage, height: 36),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  vehicleName,
                  style: text.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                vehicleLabel,
                style: text.bodySmall!.copyWith(color: Colors.black54),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// ---------------- PROFILE VERIFIED BOX ----------------
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                /// Profile verified
                Row(
                  children: [
                    const Icon(Icons.verified, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      profileVerifiedText,
                      style: text.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                /// Verification list items
                ...verificationList.map(
                  (label) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _CheckRow(text: text, label: label),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  final TextTheme text;
  final String label;

  const _CheckRow({
    required this.text,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_circle, color: Colors.green, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(label, style: text.bodyMedium)),
      ],
    );
  }
}
