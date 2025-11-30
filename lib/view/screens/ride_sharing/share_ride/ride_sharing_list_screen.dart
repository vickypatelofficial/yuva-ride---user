import 'package:flutter/material.dart';
import 'package:yuva_ride/main.dart';
import 'package:yuva_ride/utils/animations.dart';
import 'package:yuva_ride/view/custom_widgets/cusotm_back.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/app_fonts.dart';
import 'package:yuva_ride/view/screens/ride_sharing/share_ride/ride_sharing_detail/ride_share_detail_screen.dart';
import 'package:yuva_ride/view/screens/ride_sharing/share_ride/widgets/ride_offer_card.dart';

class RideListScreen extends StatelessWidget {
  const RideListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return CustomScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: const Text(
          "",
          style: TextStyle(color: Colors.white),
        ),
        leading: const Padding(
          padding: EdgeInsets.only(left: 12),
          child: CustomBack(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// DATE + Edit button
          Container(
            width: double.infinity,
            color: AppColors.primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  /// DATE PART
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month, color: Colors.black54),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Fri, Aug 8, 2025",
                            style: text.bodyLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// SPACING
                  const SizedBox(width: 10),

                  /// EDIT BUTTON (RIGHT SIDE)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.edit, color: Colors.white, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          "Edit",
                          style: text.bodyLarge!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              "Fri, Aug 8,2025",
              style: text.titleLarge!
                  .copyWith(fontFamily: AppFonts.semiBold, fontSize: 18),
            ),
          ),

          const SizedBox(height: 10),

          /// LIST OF RIDE CARDS
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              children: [
                RideOfferCard(
                  pickupTime: "15:30",
                  dropTime: "15:30",
                  pickupLocation: "Peddamma talli temple, Hyderabad",
                  dropLocation: "Shri Peddamma talli Devalayam, Hyderabad",
                  vehicleName: "Mahindra thar",
                  price: "350.00",
                  driverName: "Suresh Kumar",
                  driverImage: "assets/images/user_pic.png",
                  rating: 4.5,
                  bookRide: () {
                    Navigator.push(
                        context, AppAnimations.fade(RideDetailScreen()));
                  },
                ),
                RideOfferCard(
                  pickupTime: "15:30",
                  dropTime: "15:30",
                  pickupLocation: "Peddamma talli temple, Hyderabad",
                  dropLocation: "Shri Peddamma talli Devalayam, Hyderabad",
                  vehicleName: "Mahindra thar",
                  price: "350.00",
                  driverName: "Suresh Kumar",
                  driverImage: "assets/images/user_pic.png",
                  rating: 4.5,
                  bookRide: () {
                    Navigator.push(
                        context, AppAnimations.fade(RideDetailScreen()));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
