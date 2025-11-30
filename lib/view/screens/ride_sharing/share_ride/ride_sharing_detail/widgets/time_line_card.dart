import 'package:flutter/material.dart';
import 'package:yuva_ride/utils/app_colors.dart';

class TimelineSection extends StatelessWidget {
  final TextTheme text;

  final String time1;
  final String time2;
  final String time3;

  final String loc1Title;
  final String loc1Sub;

  final String loc2Title;
  final String loc2Sub;

  final String loc3Title;
  final String loc3Sub;

  const TimelineSection({
    super.key,
    required this.text,
    required this.time1,
    required this.time2,
    required this.time3,
    required this.loc1Title,
    required this.loc1Sub,
    required this.loc2Title,
    required this.loc2Sub,
    required this.loc3Title,
    required this.loc3Sub,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LEFT TIMES --------------------------
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(time1, style: text.bodyLarge),
              const SizedBox(height: 40),
              Text(time2, style: text.bodyLarge),
              const SizedBox(height: 40),
              Text(time3, style: text.bodyLarge),
            ],
          ),

          const SizedBox(width: 20),

          // DOTS / LINE --------------------------
          Column(
            children: [
              Container(
                height: 12,
                width: 12,
                decoration: const BoxDecoration(
                    color: Color(0xffD2D2D2), shape: BoxShape.circle),
              ),
              Container(height: 50, width: 2, color: Colors.black.withOpacity(.5)),

              Container(
                height: 12,
                width: 12,
                decoration: const BoxDecoration(
                    color: Colors.green, shape: BoxShape.circle),
              ),
              Container(height: 50, width: 2, color: Colors.black.withOpacity(.2)),

              Container(
                height: 12,
                width: 12,
                decoration:
                    const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              ),
            ],
          ),

          const SizedBox(width: 16),

          // RIGHT TITLES --------------------------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1ST
                Text(
                  loc1Title,
                  style: text.bodyLarge!.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  loc1Sub,
                  style:
                      text.bodySmall!.copyWith(color: Colors.black54),
                  maxLines: 1,
                ),

                const SizedBox(height: 22),

                // 2ND
                Text(
                  loc2Title,
                  style: text.bodyLarge!.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                ),
                Text(
                  loc2Sub,
                  style:
                      text.bodySmall!.copyWith(color: Colors.black54),
                  maxLines: 1,
                ),

                const SizedBox(height: 22),

                // 3RD
                Text(
                  loc3Title,
                  style: text.bodyLarge!.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  loc3Sub,
                  style:
                      text.bodySmall!.copyWith(color: Colors.black54),
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
