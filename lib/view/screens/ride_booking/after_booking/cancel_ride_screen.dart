import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yuva_ride/provider/book_ride_provider.dart';
import 'package:yuva_ride/services/status.dart';
import 'package:yuva_ride/utils/animations.dart';
import 'package:yuva_ride/view/custom_widgets/cusotm_back.dart';
import 'package:yuva_ride/view/custom_widgets/custom_inkwell.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/app_fonts.dart';
import 'package:yuva_ride/view/screens/home/home_screen.dart';

class CancelRideReasonScreen extends StatefulWidget {
  const CancelRideReasonScreen({super.key});

  @override
  State<CancelRideReasonScreen> createState() => _CancelRideReasonScreenState();
}

class _CancelRideReasonScreenState extends State<CancelRideReasonScreen> {
  int selectedIndex = 0;

  final List<String> reasons = [
    "The ride partner is too far away,\ntaking too long",
    "It's raining heavily, I'll go later",
    "I waited too long.",
    "I have an emergency at home.",
    "My plan has changed.",
  ];

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return CustomScaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: 100,
            color: AppColors.primaryColor,
            padding: const EdgeInsets.only(top: 30, left: 18, right: 18),
            child: Row(
              children: [CustomBack()],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18, top: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Why do you cancel a ride",
                style: text.titleMedium!.copyWith(
                  fontFamily: AppFonts.semiBold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              itemCount: reasons.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        reasons[index],
                        style: text.bodyMedium!.copyWith(
                          color: Colors.black,
                          height: 1.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => setState(() => selectedIndex = index),
                      child: Icon(
                        selectedIndex == index
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: AppColors.primaryColor,
                        size: 26,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Consumer<BookRideProvider>(
              builder: (context, bookRideProvider, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: CustomInkWell(
                onTap: () async {
                  await bookRideProvider.cancelRide(
                      cancelId: '3',
                      requestId:
                          // bookRideProvider.rideDetailState.data?.cartTableId ??
                          //     bookRideProvider
                          //         .rideDetailState.data?.requestTableId ??
                          bookRideProvider.getActiveRideRequestId(),
                      lat: bookRideProvider.pickupLocation?.latLng.latitude
                              .toString() ??
                          '',
                      lng: bookRideProvider.pickupLocation?.latLng.longitude
                              .toString() ??
                          '');
                  if (isStatusSuccess(
                      bookRideProvider.cancelRideState.status)) {
                    // ignore: use_build_context_synchronously
                    Navigator.pushAndRemoveUntil(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                        (_) => false);
                  }
                },
                padding: const EdgeInsets.symmetric(vertical: 14),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child:
                      isStatusLoading(bookRideProvider.cancelRideState.status)
                          ? const SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                              ))
                          : Text(
                              "Confirm",
                              style: text.titleMedium!.copyWith(
                                color: Colors.white,
                                fontFamily: AppFonts.medium,
                                fontSize: 16,
                              ),
                            ),
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
