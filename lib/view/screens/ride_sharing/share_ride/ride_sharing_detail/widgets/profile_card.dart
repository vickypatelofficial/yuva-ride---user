import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final TextTheme text;

  final String userName;
  final String userImage;
  final String rating;
  final String verifiedText;

  final String drivingSince;
  final String aboutTitle;
  final String aboutDescription;

  const ProfileCard({
    super.key,
    required this.text,
    required this.userName,
    required this.userImage,
    required this.rating,
    required this.verifiedText,
    required this.drivingSince,
    required this.aboutTitle,
    required this.aboutDescription,
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
          /// ---------------- TOP USER ROW ----------------
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.asset(
                  userImage,
                  height: 56,
                  width: 56,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),

              /// USER NAME
              Expanded(
                child: Text(
                  userName,
                  style: text.titleMedium!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              /// RATING + VERIFIED
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: text.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    verifiedText,
                    style: text.bodySmall!.copyWith(
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// DRIVING SINCE
          Text(
            drivingSince,
            style: text.bodySmall!.copyWith(
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 8),

          /// ABOUT TITLE
          Text(
            aboutTitle,
            style: text.bodyLarge!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          /// ABOUT DESCRIPTION
          Text(
            aboutDescription,
            style: text.bodySmall!.copyWith(
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
