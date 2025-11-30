import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yuva_ride/utils/animations.dart';
import 'package:yuva_ride/utils/navigation_function.dart';
import 'package:yuva_ride/view/custom_widgets/customAppBar.dart';
import 'package:yuva_ride/view/custom_widgets/custom_button.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/app_fonts.dart';
import 'package:yuva_ride/view/screens/home/home_screen.dart';
import 'package:yuva_ride/view/screens/ride_sharing/ride_sharing_history/cancel_ride_share_screen.dart';
import 'package:yuva_ride/view/screens/ride_sharing/ride_sharing_history/widgets/cancel_bottom_sheet.dart';
import 'package:yuva_ride/view/screens/ride_sharing/ride_sharing_history/widgets/custom_ride_detail_card.dart';

class RideSharingDetailsScreen extends StatefulWidget {
  const RideSharingDetailsScreen({super.key, required this.status});
  final String status;

  @override
  State<RideSharingDetailsScreen> createState() =>
      _RideSharingDetailsScreenState();
}

class _RideSharingDetailsScreenState extends State<RideSharingDetailsScreen> {
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final double mapHeight = size.height * 0.33;

    return CustomScaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "#25",
        actions: [
          _statusTag(),
          const SizedBox(width: 10),
        ],
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            SizedBox(
              height: mapHeight,
              width: size.width,
              child: GoogleMap(
                onMapCreated: (c) => mapController = c,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(17.4065, 78.4772),
                  zoom: 14.5,
                ),
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
              ),
            ),
            Positioned(
              top: mapHeight - 25,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height - (mapHeight - 40),
                width: size.width,
                constraints: BoxConstraints(
                  minHeight: size.height - (mapHeight - 25),
                ),
                padding: const EdgeInsets.fromLTRB(18, 25, 18, 18),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(22),
                    topRight: Radius.circular(22),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Fri, Aug 08,2025",
                        style: text.bodyLarge!.copyWith(
                          fontSize: 15,
                          fontFamily: AppFonts.semiBold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("15:30",
                                  style:
                                      text.bodyLarge!.copyWith(fontSize: 14)),
                              const SizedBox(height: 5),
                              Text("2hrs",
                                  style: text.bodyLarge!.copyWith(
                                      fontSize: 14, color: Colors.grey)),
                              const SizedBox(height: 5),
                              Text("15:30",
                                  style:
                                      text.bodyLarge!.copyWith(fontSize: 14)),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Column(
                            children: [
                              const CircleAvatar(
                                  radius: 7, backgroundColor: Colors.green),
                              Container(
                                height: 35,
                                width: 2,
                                color: Colors.grey.shade600,
                              ),
                              const CircleAvatar(
                                  radius: 7, backgroundColor: Colors.red),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "9-120, Madhapur metro station, Hyderabad",
                                  style: text.bodyMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 14),
                                Container(
                                  height: 1,
                                  color: Colors.grey.shade300,
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  "9-120, Hitech metro station, Hyderabad",
                                  style: text.bodyMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      CustomRideDetailsCard(
                        title: "Ride Details",
                        seats: "1 seat",
                        amount: "₹350.00",
                        paymentMode: "Cash",
                        note: "Pay in the car",
                        text: text,
                      ),

                      const SizedBox(height: 30),

                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Image.asset(
                              "assets/images/user_pic.png",
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Suresh Kumar",
                              style: text.bodyLarge!.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star_border, size: 20),
                              const SizedBox(width: 4),
                              Text("4.5 / 6", style: text.bodyMedium),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      Row(
                        children: [
                          Image.asset(
                            "assets/images/vehicle.png",
                            height: 32,
                            width: 32,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Mahindra Thar",
                              style: text.bodyLarge!.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            "Vehicle",
                            style: text.bodyMedium!.copyWith(
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Other Passengers",
                            style: text.bodyLarge!.copyWith(
                              color: const Color(0xff1A73E8),
                            ),
                          ),
                          const Icon(Icons.arrow_forward, color: Colors.blue),
                        ],
                      ),

                      const SizedBox(height: 26),

                      Row(
                        children: [
                          Text(
                            "I need support ?",
                            style: text.bodyMedium!
                                .copyWith(fontFamily: AppFonts.medium),
                          ),
                          const Spacer(),
                          Text(
                            "Contact us",
                            style: text.bodyMedium!.copyWith(
                              fontFamily: AppFonts.medium,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      /// ---------------- INVOICE BUTTON ----------------
                      if (widget.status == 'progress')
                        CustomButton(
                          backgroundColor: const Color(0xffFADCDC),
                          borderColor: AppColors.primaryColor,
                          textColor: AppColors.primaryColor,
                          text: "Cancel",
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => CancelRideBottomSheet(
                                ontapConfirm: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      AppAnimations.fade(
                                          const CancelledRidesShareScreen()));
                                },
                              ),
                            );
                          },
                        )
                      else if (widget.status == 'cancelled')
                        CustomButton(
                            text: 'Explore more rides',
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  AppAnimations.fade(const HomeScreen()),
                                  (value) => false);
                            })
                      else if (widget.status == 'completed')
                        CustomButton(
                            borderRadius: 8,
                            text: 'Completed',
                            backgroundColor: AppColors.success,
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  AppAnimations.fade(const HomeScreen()),
                                  (value) => false);
                            }),

                      const SizedBox(height: 150),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: const [
          Icon(Icons.check_circle, color: Colors.green, size: 16),
          SizedBox(width: 6),
          Text(
            "Completed",
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
