
import 'package:flutter/material.dart';
import 'package:yuva_ride/view/custom_widgets/cusotm_back.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:yuva_ride/utils/animations.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/app_fonts.dart';
import 'package:yuva_ride/view/screens/ride_booking/ride_booking_history/ride_booking_detail_screen.dart';

class RideBookingHistoryScreen extends StatefulWidget {
  const RideBookingHistoryScreen({super.key});
  @override
  State<RideBookingHistoryScreen> createState() => _RideBookingHistoryScreenState();
}

class _RideBookingHistoryScreenState extends State<RideBookingHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabCtrl;

  @override
  void initState() {
    super.initState();
    tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return CustomScaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            /// ---------------- HEADER ----------------
            Row(
              children: [
                const SizedBox(width: 10,),
                const CustomBack(),
                const SizedBox(width: 14),
                Text(
                  "Ride Bookings",
                  style: text.titleMedium!.copyWith(
                    fontFamily: AppFonts.medium,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            /// ---------------- TAB BAR ----------------
            TabBar(
              controller: tabCtrl,
              indicatorColor: AppColors.primaryColor,
              labelColor: AppColors.primaryColor,
              unselectedLabelColor: Colors.black54,
              labelStyle: const TextStyle(
                fontFamily: AppFonts.medium,
                fontWeight: FontWeight.bold,
              ),
              tabs: const [
                Tab(text: "In Progress"),
                Tab(text: "Completed"),
                Tab(text: "Cancelled"),
              ],
            ),

            const SizedBox(height: 10),

            /// ---------------- TAB CONTENT ----------------
            Expanded(
              child: TabBarView(
                controller: tabCtrl,
                children: [
                  _rideList(text, type: "progress"),
                  _rideList(text, type: "completed"),
                  _rideList(text, type: "cancelled"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ====================================================
  ///  LIST BUILDER
  /// ====================================================
  Widget _rideList(TextTheme text, {required String type}) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      itemCount: 2,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: _rideCard(text, type: type),
        );
      },
    );
  }

  /// ====================================================
  ///  RIDE CARD WIDGET
  /// ====================================================
  Widget _rideCard(TextTheme text, {required String type}) {
    return InkWell(
      onTap: () {
         Navigator.push(context, AppAnimations.zoomIn(const RideBookingDetailsScreen()));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          children: [
            /// ----------------------------------------------------
            ///                 TOP HEADER BAR
            /// ---------------------------------------------------- 
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xffFFE7CC),
                borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// ---- RIDE NUMBER ----
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "#25",
                        style: text.titleMedium!.copyWith(
                          fontFamily: AppFonts.medium,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Image.asset("assets/images/bike_book.png", height: 26),
      
                          const SizedBox(width: 8),
      
                          /// ---- VEHICLE TEXT ----
                          Text(
                            "Bike",
                            style: text.titleMedium!.copyWith(
                              fontFamily: AppFonts.medium,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
      
                  const SizedBox(width: 12),
      
                  const Spacer(),
                  Column(
                    children: [
                      if (type == "completed")
                        Padding(
                           padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                Image.asset(
                                  "assets/images/completed_badge.png",
                                  height: 20,
                                  width: 20,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  "Compeleted",
                                  style: TextStyle(
                                    color: AppColors.green,
                                    fontFamily: AppFonts.medium,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (type == "cancelled")
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                Image.asset(
                                  "assets/images/cancelled_badge.png",
                                  height: 20,
                                  width: 20,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  "Cancelled",
                                  style: TextStyle(
                                    color: AppColors.red,
                                    fontFamily: AppFonts.medium,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(width: 12),
                      Row(
                        children: [
                          /// ---- TIME ----
                          Text(
                            "5:30 PM",
                            style: text.bodyMedium!.copyWith(
                              fontFamily: AppFonts.medium,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      
                          const SizedBox(width: 8),
                      
                          /// ---- DATE ----
                          Text(
                            "12/07/2025",
                            style: text.bodyMedium!.copyWith(
                              fontFamily: AppFonts.medium,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
      
            /// ----------------------------------------------------
            ///                RIDE DETAILS SECTION
            /// ----------------------------------------------------
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// LEFT SIDE DOTS + LINE
                  Column(
                    children: [
                      const CircleAvatar(
                          radius: 7, backgroundColor: Colors.green),
                      Container(
                        height: 35,
                        width: 2,
                        color: Colors.grey.shade700,
                      ),
                      const CircleAvatar(radius: 7, backgroundColor: Colors.red),
                    ],
                  ),
      
                  const SizedBox(width: 14),
      
                  /// RIGHT SIDE TEXT
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "9-120, Madhapur metro station, Hyderabad",
                          style: text.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        Container(height: 1, color: Colors.grey.shade300),
                        const SizedBox(height: 8),
                        Text(
                          "9-120, Hitech metro station, Hyderabad",
                          style: text.bodyMedium,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
      
            /// ----------------------------------------------------
            ///          PRICE + VIEW DETAILS ROW
            /// ----------------------------------------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Row(
                children: [
                  Text(
                    "Cash ₹70",
                    style: text.titleMedium!.copyWith(
                      fontFamily: AppFonts.medium,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "View Details",
                    style: text.titleMedium!.copyWith(
                      fontFamily: AppFonts.medium,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_right_alt,
                      color: AppColors.primaryColor, size: 20)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
