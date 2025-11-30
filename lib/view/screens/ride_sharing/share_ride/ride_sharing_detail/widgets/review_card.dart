import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  final String name;
  final String reviewText;
  final double rating;
  final String daysAgo;
  final TextTheme textTheme;
  final String? userImage;

  const ReviewCard({
    super.key,
    required this.name,
    required this.reviewText,
    required this.rating,
    required this.daysAgo,
    required this.textTheme,
    this.userImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 130,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.09),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// USER + RATING ROW
          Row(
            children: [
              ClipOval(
                child: userImage == null
                    ? Container(
                        color: Colors.grey.shade200,
                        width: 36,
                        height: 36,
                        child: const Icon(Icons.person, color: Colors.grey),
                      )
                    : Image.asset(
                        userImage!,
                        width: 36,
                        height: 36,
                        fit: BoxFit.cover,
                      ),
              ),

              const SizedBox(width: 8),

              /// NAME — Expanded to prevent overflow
              Expanded(
                child: Text(
                  name,
                  style: textTheme.bodyMedium!
                      .copyWith(fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(width: 6),

              /// RATING
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    "$rating",
                    style: textTheme.bodyMedium!
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// REVIEW TEXT
          Text(
            reviewText,
            style: textTheme.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const Spacer(),

          /// DAYS AGO
          Text(
            daysAgo,
            style: textTheme.bodySmall!.copyWith(color: Colors.black45),maxLines: 1,
          ),
        ],
      ),
    );
  }
}
