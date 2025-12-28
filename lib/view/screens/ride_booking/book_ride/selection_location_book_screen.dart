import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:yuva_ride/provider/book_ride_provider.dart';
import 'package:yuva_ride/view/custom_widgets/cusotm_back.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:yuva_ride/main.dart';
import 'package:yuva_ride/utils/animations.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/app_fonts.dart';
import 'package:yuva_ride/view/screens/ride_booking/book_ride/book_ride_vehicle_screen.dart';

import 'package:yuva_ride/view/custom_widgets/custom_inkwell.dart';
import 'package:yuva_ride/view/screens/ride_booking/book_ride/select_location_map_screen.dart';

class SelectLocationBookScreen extends StatelessWidget {
  const SelectLocationBookScreen({super.key});

  void _showRideForSomeoneSheet(BuildContext context) {
    final text = Theme.of(context).textTheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// CLOSE BUTTON
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Book a Ride for Someone Else",
                    style: text.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.black12,
                      child: Icon(Icons.close, size: 18, color: Colors.black),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 4),

              Text(
                "Booking for someone made simple.",
                style: text.bodyMedium!.copyWith(
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 20),

              /// TITLE: WHO’S TAKING THE RIDE?
              Text(
                "Who's Taking the Ride?",
                style: text.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              /// OPTION 1 — MY SELF
              Row(
                children: [
                  Radio(
                    value: "self",
                    groupValue: "self",
                    onChanged: (_) {},
                    activeColor: AppColors.primaryColor,
                  ),
                  const Icon(Icons.person_outlined),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "My Self",
                    style: text.bodyLarge,
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Radio(
                    value: "other",
                    // ignore: deprecated_member_use
                    groupValue: "self",
                    // ignore: deprecated_member_use
                    onChanged: (_) {},
                    activeColor: AppColors.primaryColor,
                  ),
                  const Icon(Icons.person_outlined),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Mukesh", style: text.bodyLarge),
                      Text(
                        "+91 76456 58566",
                        style: text.bodySmall,
                      )
                    ],
                  )
                ],
              ),

              const SizedBox(height: 10),

              /// OPTION 3 — CHOOSE ANOTHER CONTACT
              Row(
                children: [
                  const Icon(Icons.contacts, color: Colors.black54),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Choose another contact",
                      style: text.bodyLarge,
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios,
                      color: Colors.black54, size: 18)
                ],
              ),

              const SizedBox(height: 18),

              /// SAVE BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Save",
                    style: text.titleMedium!.copyWith(
                      color: Colors.white,
                      fontFamily: AppFonts.semiBold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final bookRideController = context.read<BookRideProvider>();

    return CustomScaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// ORANGE HEADER
          Container(
            height: 180,
            color: AppColors.primaryColor,
          ),

          /// MAIN CONTENT
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),

              /// BACK & PROFILE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomBack(),
                    InkWell(
                      onTap: () {
                        _showRideForSomeoneSheet(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.2),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: Text(
                          "My Self",
                          style: text.bodyMedium!.copyWith(
                              color: Colors.white, fontFamily: AppFonts.medium),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// PICKUP / DROP CARD
              Consumer<BookRideProvider>(builder: (context, provider, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Container(
                    height: 120,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 90,
                          width: 14,
                          child: Column(
                            children: [
                              _dot(Colors.green),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                width: 3,
                                height: 40,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 1,
                                        color: const Color(0xff070707),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              _dot(Colors.red),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * .7,
                          child: Column(
                            children: [
                              CustomInkWell(
                                elevation: 0,
                                backgroundColor: AppColors.white,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      AppAnimations.fade(
                                          SelectLocationMapScreen(
                                        latLng: bookRideController
                                            .pickupLocation?.latLng,
                                        onSelectLocation: (LatLng latLng,
                                            String address,
                                            String title,
                                            String subititle) {
                                          print('++++++========+++++++++');
                                          print('$address, $title, $subititle');
                                          bookRideController.setPickupLocation(
                                              LocationModel(latLng, address,
                                                  title: title,
                                                  subtitle: subititle));
                                        },
                                      )));
                                },
                                child: Row(
                                  children: [
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Text(
                                        provider.pickupLocation?.address ??
                                            "Select your Pickup location",
                                        style: text.bodyLarge!.copyWith(
                                            fontFamily: AppFonts.medium),
                                        maxLines: 1,
                                      ),
                                    ),
                                    // Image.asset(
                                    //   'assets/images/gps.png',
                                    //   height: 20,
                                    //   width: 20,
                                    //   errorBuilder:
                                    //       (context, error, stackTrace) {
                                    //     return SizedBox();
                                    //   },
                                    // )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 1,
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    child: Icon(Icons.swap_vert,
                                        color: AppColors.primaryColor),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 1,
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              CustomInkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      AppAnimations.fade(
                                          SelectLocationMapScreen(
                                        latLng: bookRideController
                                            .dropLocation?.latLng,
                                        onSelectLocation: (LatLng latLng,
                                            String address,
                                            String title,
                                            String subititle) {
                                          bookRideController.setDropLocation(
                                              LocationModel(latLng, address,
                                                  title: title,
                                                  subtitle: subititle));
                                        },
                                      )));
                                },
                                child: Row(
                                  children: [
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Text(
                                        provider.dropLocation?.address ??
                                            "Select your Drop location",
                                        style: text.bodyLarge!.copyWith(
                                            fontFamily: AppFonts.medium),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  "Recent Locations",
                  style: text.titleLarge,
                ),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  itemCount: 4,
                  itemBuilder: (_, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on,
                              color: AppColors.primaryColor, size: 22),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Madhapur",
                                  style: text.bodyLarge!
                                      .copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              SizedBox(
                                width: screenWidth * .8,
                                child: Text(
                                  "9-120, Madhapur metro station, Hyderabad, Telangana",
                                  style: text.bodySmall,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),

              /// BOTTOM BUTTON
              Container(
                height: 80,
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    if (bookRideController.dropLocation == null ||
                        bookRideController.pickupLocation == null) {
                      return;
                    }
                    // context.read<BookRideProvider>().fetchCategory();
                    final provider = context.read<BookRideProvider>();
                    provider.setCategory('taxi');
                    provider.setVehicle('', '');
                    provider.setCoupon('', '');
                    provider.changeFareNaviagate(false);
                    // 2 apis
                    provider.getCalculatedPrice();
                    provider.getPaymentCoupon();
                    Navigator.push(context,
                        AppAnimations.fadeSlide(const BookRideVehicleScreen()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border:
                          Border.all(color: AppColors.primaryColor, width: 1.5),
                      // ignore: deprecated_member_use
                      color: AppColors.primaryColor.withOpacity(.1),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.map_outlined,
                              color: AppColors.primaryColor),
                          const SizedBox(width: 8),
                          Text("Locate on map",
                              style: text.bodyLarge!.copyWith(
                                  color: AppColors.primaryColor,
                                  fontFamily: AppFonts.medium)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _dot(Color color) {
    return Container(
      height: 14,
      width: 14,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [BoxShadow(color: color, blurRadius: 7)]),
    );
  }
}
