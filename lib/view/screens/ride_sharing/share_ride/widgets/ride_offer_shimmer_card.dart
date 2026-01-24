import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RideOfferShimmerCard extends StatelessWidget {
  const RideOfferShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      padding: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          children: [
            /// ---------- TOP SECTION (Pickup/Drop) ----------
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  /// TIMINGS + DOTS
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 16, width: 40, color: Colors.white),
                      const SizedBox(height: 6),
                      Container(height: 12, width: 30, color: Colors.white),
                      const SizedBox(height: 6),
                      Container(height: 16, width: 40, color: Colors.white),
                    ],
                  ),

                  const SizedBox(width: 14),

                  /// DOTS + LINE
                  Column(
                    children: [
                      Container(
                        height: 12,
                        width: 12,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(height: 40, width: 2, color: Colors.white),
                      Container(
                        height: 12,
                        width: 12,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 14),

                  /// PICKUP + DROP LOCATION
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 14, width: double.infinity, color: Colors.white),
                        const SizedBox(height: 14),
                        Container(height: 1, color: Colors.white),
                        const SizedBox(height: 14),
                        Container(height: 14, width: double.infinity, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// ---------- VEHICLE AND PRICE ROW ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(height: 16, width: double.infinity, color: Colors.white),
                  ),
                  Container(height: 16, width: 50, color: Colors.white),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(height: 16, width: double.infinity, color: Colors.white),
                  ),
                  Container(height: 16, width: 40, color: Colors.white),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 45,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
