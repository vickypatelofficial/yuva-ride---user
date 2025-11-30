import 'package:flutter/material.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/app_fonts.dart';
import 'package:yuva_ride/view/custom_widgets/custom_button.dart';
import 'package:yuva_ride/view/custom_widgets/custom_inkwell.dart';

class RideOfferCard extends StatelessWidget {
  final String pickupTime;
  final String dropTime;
  final String pickupLocation;
  final String dropLocation;
  final String vehicleName;
  final String price;
  final String driverName;
  final String driverImage;
  final double rating;
  final VoidCallback bookRide;

  const RideOfferCard({
    super.key,
    required this.pickupTime,
    required this.dropTime,
    required this.pickupLocation,
    required this.dropLocation,
    required this.vehicleName,
    required this.price,
    required this.driverName,
    required this.driverImage,
    required this.rating,
    required this.bookRide,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

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
                    Text(pickupTime, style: text.bodyLarge),
                    const SizedBox(height: 6),
                    Text("2hrs",
                        style: text.bodyMedium!
                            .copyWith(color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 6),
                    Text(dropTime, style: text.bodyLarge),
                  ],
                ),

                const SizedBox(width: 14),

                /// DOTS + LINE
                Column(
                  children: [
                    const CircleAvatar(
                        radius: 6, backgroundColor: Colors.green),
                    Container(height: 40, width: 2, color: Colors.black54),
                    const CircleAvatar(radius: 6, backgroundColor: Colors.red),
                  ],
                ),

                const SizedBox(width: 14),

                /// PICKUP + DROP LOCATION
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(pickupLocation,
                          style: text.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 14),
                      Container(
                        height: 1,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 14),
                      Text(dropLocation,
                          style: text.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
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
                Image.asset("assets/images/car_book.png", height: 30),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    vehicleName,
                    style: text.titleMedium!.copyWith(
                      fontFamily: AppFonts.semiBold,
                    ),
                  ),
                ),
                Text(
                  "₹$price",
                  style: text.titleMedium!.copyWith(
                    fontFamily: AppFonts.semiBold,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.asset(
                    driverImage,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    driverName,
                    style: text.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Icon(Icons.star_border, size: 20),
                const SizedBox(width: 4),
                Text("$rating / 5", style: text.bodyMedium),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomInkWell(
                onTap: bookRide,
                child: CustomButton(text: "Book now", onPressed: bookRide,height: 45,textVerticalPadding: 10,)),
          ),
        ],
      ),
    );
  }
}
