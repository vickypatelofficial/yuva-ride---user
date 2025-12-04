import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yuva_ride/main.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/view/custom_widgets/custom_inkwell.dart';

class ShimmerDriverCard extends StatelessWidget {
  const ShimmerDriverCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// -------------------- TOP CONTENT ROW --------------------
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// LEFT SHIMMER TEXT BLOCKS
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      shimmerBox(width: 100, height: 14),
                      const SizedBox(height: 8),
                      shimmerBox(width: 100, height: 14),
                      const SizedBox(height: 8),
                      shimmerBox(width: 100, height: 14),
                    ],
                  ),
                ),

                const SizedBox(width: 20),

                /// RIGHT SHIMMER RECTANGLE
                shimmerBox(width: 85, height: 60, radius: 10),
              ],
            ),

            const SizedBox(height: 20),

            /// -------------------- BOTTOM AVATAR + TEXT --------------------
            Row(
              children: [
                shimmerBox(width: 40, height: 40, radius: 50), // avatar circle
                const SizedBox(width: 12),
                Expanded(
                  child: shimmerBox(width: double.infinity, height: 40),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ---------- INDIVIDUAL SHIMMER WIDGET ----------
  Widget shimmerBox({
    required double width,
    required double height,
    double radius = 6,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
