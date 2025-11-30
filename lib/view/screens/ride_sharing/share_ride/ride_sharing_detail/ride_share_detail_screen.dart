import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yuva_ride/utils/animations.dart';
import 'package:yuva_ride/view/custom_widgets/cusotm_back.dart';
import 'package:yuva_ride/view/custom_widgets/customAppBar.dart';
import 'package:yuva_ride/view/custom_widgets/custom_inkwell.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:yuva_ride/view/custom_widgets/custom_button.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/app_fonts.dart';
import 'package:yuva_ride/view/screens/ride_booking/after_booking/chat_screen.dart';
import 'package:yuva_ride/view/screens/ride_sharing/share_ride/confirm_ride_screen.dart';
import 'package:yuva_ride/view/screens/ride_sharing/share_ride/passenger_detail_screen.dart';
import 'package:yuva_ride/view/screens/ride_sharing/share_ride/ride_sharing_detail/widgets/passenger_card.dart';
import 'package:yuva_ride/view/screens/ride_sharing/share_ride/ride_sharing_detail/widgets/passenger_price_card.dart';
import 'package:yuva_ride/view/screens/ride_sharing/share_ride/ride_sharing_detail/widgets/profile_card.dart';
import 'package:yuva_ride/view/screens/ride_sharing/share_ride/ride_sharing_detail/widgets/review_card.dart';
import 'package:yuva_ride/view/screens/ride_sharing/share_ride/ride_sharing_detail/widgets/time_line_card.dart';
import 'package:yuva_ride/view/screens/ride_sharing/share_ride/ride_sharing_detail/widgets/vehicle_card_screen.dart';

class RideDetailScreen extends StatelessWidget {
  RideDetailScreen({super.key});

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
      backgroundColor: const Color(0xffF8F8F8),
      appBar: const CustomAppBar(
        title: "Suresh Kumar",
      ),
      body: Column(
        children: [
          // body
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              children: [
                // timeline + top small row (times + locations)
                TimelineSection(
                  text: text,
                  time1: "5:30",
                  time2: "15:30",
                  time3: "15:30",
                  loc1Title: "Hitech city",
                  loc1Sub: "Hitech city x road Hyderabad, Telangana",
                  loc2Title: "Peddamma talli temple",
                  loc2Sub:
                      "Shri Peddamma talli Devalayam, Hyderabad, Telangana",
                  loc3Title: "Madhapur Bus stand",
                  loc3Sub: "Madhapur metro station, madhapur, Telangana",
                ),

                const SizedBox(height: 12),

                // passenger + price pill
                PassengerPriceCard(
                  text: Theme.of(context).textTheme,
                  passengerText: "1 Passenger",
                  priceText: "₹350.00",
                ),
                const SizedBox(height: 14),
                // vehicle card
                VehicleCard(
                  text: Theme.of(context).textTheme,
                  vehicleImage: "assets/images/car_book.png",
                  vehicleName: "Mahindra thar",
                  vehicleLabel: "Vehicle",
                  profileVerifiedText: "Profile verified",
                  verificationList: const [
                    "Documents verified",
                    "Email ID verified",
                    "Mobile number verified",
                  ],
                ),
                const SizedBox(height: 14),
                // driver profile card
                ProfileCard(
                  text: Theme.of(context).textTheme,
                  userName: "Suresh Kumar",
                  userImage: "assets/images/user_pic.png",
                  rating: "4.5",
                  verifiedText: "Verified profile",
                  drivingSince: "Driving since June 20, 2025",
                  aboutTitle: "About Suresh Kumar",
                  aboutDescription:
                      "I am a working as a employee and travelling between wgl and Hyderabad",
                ),
                const SizedBox(height: 14),
                // passengers card
                PassengersCard(
                  text: Theme.of(context).textTheme,
                  passengerName: "Sumanth",
                  passengerImage: "assets/images/passenger.png",
                  routeText: "Hitech city → Madhapur",
                  onViewDetails: () {
                    Navigator.push(
                        context, AppAnimations.fade(PassengerDetailsScreen()));
                  },
                ),

                const SizedBox(height: 18),

                // reviews & ratings horizontal list
                Text("Reviews & ratings",
                    style: text.titleMedium!
                        .copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(reviews.length, (i) {
                      final r = reviews[i];
                      return Padding(
                        padding: EdgeInsetsGeometry.only(right: 5),
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

                const SizedBox(height: 36), // space before bottom
              ],
            ),
          ),

          // bottom action row
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: "Book Now",
                    onPressed: () {
                      Navigator.push(
                          context, AppAnimations.fade(const CheckDetailsScreen()));
                    },
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context, AppAnimations.fade(const ChatScreen()));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(.03),
                            blurRadius: 6,
                            offset: const Offset(0, 2))
                      ],
                    ),
                    child: const Icon(Icons.chat_bubble_outline,
                        color: AppColors.primaryColor),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
