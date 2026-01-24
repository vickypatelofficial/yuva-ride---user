import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yuva_ride/models/ride_list_response.dart';
import 'package:yuva_ride/provider/book_ride_provider.dart';
import 'package:yuva_ride/services/status.dart';
import 'package:yuva_ride/utils/globle_func.dart';
import 'package:yuva_ride/view/custom_widgets/cusotm_back.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:yuva_ride/utils/animations.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/app_fonts.dart';
import 'package:yuva_ride/view/screens/ride_booking/ride_booking_history/ride_booking_detail_screen.dart';

class RideBookingHistoryScreen extends StatefulWidget {
  const RideBookingHistoryScreen({super.key});

  @override
  State<RideBookingHistoryScreen> createState() =>
      _RideBookingHistoryScreenState();
}

class _RideBookingHistoryScreenState extends State<RideBookingHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabCtrl;
  @override
  void initState() {
    super.initState();
    tabCtrl = TabController(length: 3, vsync: this);

    Future.microtask(() {
      context.read<BookRideProvider>().fetchRideList("upcoming");
    });

    tabCtrl.addListener(() {
      if (!tabCtrl.indexIsChanging) {
        final provider = context.read<BookRideProvider>();

        if (tabCtrl.index == 0) {
          provider.fetchRideList("upcoming");
        } else if (tabCtrl.index == 1) {
          provider.fetchRideList("completed");
        } else {
          provider.fetchRideList("cancelled");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return CustomScaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 10),

        /// ---------------- HEADER ----------------
        Row(
          children: [
            const SizedBox(
              width: 10,
            ),
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
                physics: const BouncingScrollPhysics(),
                children: [
              _rideList(text),
              _rideList(text),
              _rideList(text),
            ]))
      ])),
    );
  }

  /// ====================================================
  ///  LIST BUILDER
  /// ====================================================
  Widget _rideList(TextTheme text) {
    return Consumer<BookRideProvider>(
      builder: (context, provider, _) {
        final state = provider.rideListState;

        if (isStatusLoading(state.status)) {
          return const Center(child: CircularProgressIndicator());
        }

        if (isStatusError(state.status)) {
          return Center(child: Text(state.message ?? 'Error'));
        }

        final list = state.data?.data ?? [];

        if (list.isEmpty) {
          return const Center(child: Text("No rides found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _rideCard(context, text,
                  ride: list[index],
                  type: tabCtrl.index == 0
                      ? 'upcoming'
                      : tabCtrl.index == 1
                          ? 'completed'
                          : 'cancelled'
                              ''),
            );
          },
        );
      },
    );
  }

  /// ====================================================
  ///  RIDE CARD WIDGET
  /// ====================================================
  Widget _rideCard(
    BuildContext context,
    TextTheme text, {
    required RideItem ride,
    required String type, // progress | completed | cancelled
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          AppAnimations.zoomIn(const RideBookingDetailsScreen()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            /// ----------------------------------------------------
            /// TOP HEADER BAR
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
                  /// ---- RIDE NUMBER + VEHICLE ----
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   "#${ride.id}",
                      //   style: text.titleMedium!.copyWith(
                      //     fontFamily: AppFonts.medium,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/bike_book.png",
                            height: 26,
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 100,
                            child: Text(
                              ride.vehicleName ?? '',
                              style: text.titleMedium!.copyWith(
                                fontFamily: AppFonts.medium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const Spacer(),

                  /// ---- STATUS + TIME ----
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (type == "completed")
                        _statusBadge(
                          text: "Completed",
                          color: AppColors.green,
                          icon: "assets/images/completed_badge.png",
                        )
                      else if (type == "cancelled")
                        _statusBadge(
                          text: "Cancelled",
                          color: AppColors.red,
                          icon: "assets/images/cancelled_badge.png",
                        ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            formatDateTime(ride.createdAt.toString()),
                            style: text.bodyMedium!.copyWith(
                              fontFamily: AppFonts.medium,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            // ride.formattedDate ?? "--"
                            '',
                            style: text.bodyMedium!.copyWith(
                              fontFamily: AppFonts.medium,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// ----------------------------------------------------
            /// PICKUP & DROP
            /// ----------------------------------------------------
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// DOTS
                  Column(
                    children: [
                      const CircleAvatar(
                        radius: 7,
                        backgroundColor: Colors.green,
                      ),
                      Container(
                        height: 35,
                        width: 2,
                        color: Colors.grey.shade700,
                      ),
                      const CircleAvatar(
                        radius: 7,
                        backgroundColor: Colors.red,
                      ),
                    ],
                  ),

                  const SizedBox(width: 14),

                  /// ADDRESS
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ride.pickupAddress ?? "--",
                          style: text.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Container(height: 1, color: Colors.grey.shade300),
                        const SizedBox(height: 8),
                        Text(
                          ride.dropAddress ?? "--",
                          style: text.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// ----------------------------------------------------
            /// PRICE + VIEW DETAILS
            /// ----------------------------------------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Row(
                children: [
                  Text(
                    "Cash ₹${ride.price?.toStringAsFixed(0) ?? '0'}",
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
                  const Icon(
                    Icons.arrow_right_alt,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _statusBadge({
  required String text,
  required Color color,
  required String icon,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      children: [
        Image.asset(icon, height: 18, width: 18),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontFamily: AppFonts.medium,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}
