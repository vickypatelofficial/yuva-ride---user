import 'package:flutter/material.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:yuva_ride/view/custom_widgets/cusotm_back.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/app_fonts.dart';
import 'package:yuva_ride/view/screens/ride_sharing/share_ride/ride_sharing_detail/widgets/review_card.dart';

class PassengerDetailsScreen extends StatelessWidget {
    PassengerDetailsScreen({super.key});

    final reviews = [
    {
      "name": "Manoj",
      "text": "Great experience! Saved money and met cool people on the way",
      "rating": 5.0,
      "days": "2 days ago"
    },
    {
      "name": "Ravi",
      "text": "Safe and comfy ride",
      "rating": 4.5,
      "days": "5 days ago"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return CustomScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: CustomBack(),
        ),
        title: const Text(
          "Passenger Details",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: AppFonts.semiBold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Container(
                    height: 60,
                    width: 60,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.person, size: 32),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Sumanth",
                          style: text.titleMedium!
                              .copyWith(fontWeight: FontWeight.w700)),
                      Row(
                        children: [
                          const Icon(Icons.verified,
                              color: Colors.blue, size: 16),
                          const SizedBox(width: 4),
                          Text("Verified profile",
                              style:
                                  text.bodySmall!.copyWith(color: Colors.blue)),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 18),
                    const SizedBox(width: 6),
                    Text("4.5",
                        style: text.bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),
            Container(height: 1, color: Colors.grey.shade300),

            const SizedBox(height: 20),

            Text("About Suresh Kumar",
                style: text.titleMedium!.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),

            Text(
              "I am a working as a employee a",
              style:
                  text.bodySmall!.copyWith(color: Colors.black54, height: 1.4),
            ),

            const SizedBox(height: 22),

            Text("Profile verified",
                style: text.titleMedium!.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 14),

            Row(
              children: [
                const Icon(Icons.verified, color: Colors.green, size: 18),
                const SizedBox(width: 8),
                Text("Documents verified", style: text.bodyMedium),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.verified, color: Colors.green, size: 18),
                const SizedBox(width: 8),
                Text("Email ID verified", style: text.bodyMedium),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.verified, color: Colors.green, size: 18),
                const SizedBox(width: 8),
                Text("Mobile number verified", style: text.bodyMedium),
              ],
            ),

            const SizedBox(height: 16),

            Text("Member since 2024",
                style: text.bodySmall!.copyWith(color: Colors.orange.shade800)),

            const SizedBox(height: 30),

            Text("Reviews & ratings",
                    style: text.titleMedium!
                        .copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(top: 20,bottom: 20),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(reviews.length, (i) {
                        final r = reviews[i];
                        return Padding(
                          padding:const EdgeInsetsGeometry.only(right: 5,top: 10,bottom: 10),
                          child: ReviewCard(
                            textTheme: text,
                            name: r["name"] as String,
                            reviewText: r["text"] as String,
                            rating: r["rating"] as double,
                            daysAgo: r["days"] as String,
                            userImage: null, // or "assets/images/user_pic.png"
                          ),
                        );
                      }),
                      // separatorBuilder: (_, __) => const SizedBox(width: 12),
                    ),
                  ),
                ),

            const SizedBox(height: 20),

            // ----------------------------------------------------
            // REPORT USER
            // ----------------------------------------------------
            InkWell(
              onTap: () {},
              child: Text(
                "Report this person",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
