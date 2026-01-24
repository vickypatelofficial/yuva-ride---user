import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yuva_ride/main.dart';
import 'package:yuva_ride/models/trip_model.dart';
import 'package:yuva_ride/provider/ride_share_provider.dart';
import 'package:yuva_ride/services/status.dart'; 
import 'package:yuva_ride/utils/app_urls.dart';
import 'package:yuva_ride/view/custom_widgets/cusotm_back.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/app_fonts.dart'; 
import 'package:yuva_ride/view/screens/ride_sharing/share_ride/widgets/ride_offer_card.dart';
import 'package:yuva_ride/view/screens/ride_sharing/share_ride/widgets/ride_offer_shimmer_card.dart';
import 'package:yuva_ride/services/local_storage.dart';

class RideListScreen extends StatelessWidget {
  const RideListScreen({super.key});

  Future<void> _pickDate(
      BuildContext context, RideSharingProvider provider) async {
    final DateTime now = DateTime.now();
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: provider.searchDate != null
          ? DateTime.parse(provider.searchDate!)
          : now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child){
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.deepOrange,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (newDate != null) {
      final formattedDate =
          "${newDate.year}-${newDate.month.toString().padLeft(2, '0')}-${newDate.day.toString().padLeft(2, '0')}";
      await provider.reSearchWithNewDate(formattedDate);
    }
  }

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
      body: Consumer<RideSharingProvider>(
        builder: (context, provider, child) { 
          final searchDate = provider.searchDate ?? "";
          final formattedDate = _formatDate(searchDate);
          return Stack(
            children: [
              // Main UI
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// DATE + Edit button
                  Container(
                    width: double.infinity,
                    color: AppColors.primaryColor,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                                const Icon(Icons.calendar_month,
                                    color: Colors.black54),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _pickDate(context, provider),
                                    child: Text(
                                      formattedDate,
                                      style: text.bodyLarge,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// SPACING
                          const SizedBox(width: 10),

                          /// EDIT BUTTON (RIGHT SIDE)
                          GestureDetector(
                            onTap: () => Navigator.pop(
                                context), // Navigate back to selection screen for re-filtering
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.edit,
                                      color: Colors.white, size: 18),
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
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      formattedDate,
                      style: text.titleLarge!
                          .copyWith(fontFamily: AppFonts.semiBold, fontSize: 18),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// LIST OF RIDE CARDS
                  Builder(builder: (context) {
                    if (isStatusLoading(provider.searchResponse.status)) {
                      return Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          itemCount: 5, // Show 5 shimmer cards during loading
                          itemBuilder: (context, index) =>
                              const RideOfferShimmerCard(),
                        ),
                      );
                    }
                    if (!isStatusSuccess(provider.searchResponse.status)) {
                      return  Padding(
                        padding:  EdgeInsets.only(top: screenHeight*.2),
                        child: Center(
                          child: Text(
                            provider.searchResponse.message ?? "Failed to load trips",
                            style: text.bodyLarge,
                          ),
                        ),
                      );
                    }
                    final tripsData = provider.searchResponse.data?['trip_data'] as List<dynamic>? ?? [];
                    final trips = tripsData.map((e) => TripModel.fromJson(e)).toList();

                    if (trips.isEmpty){
                      return Padding(
                        padding:  EdgeInsets.only(top: screenHeight*.2),
                        child: Center(
                          child: Image.asset(
                            "assets/images/no_ride_found.png", 
                            width: screenWidth*.4,height: screenWidth*.4
                          ),
                        ),
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        itemCount: trips.length,
                        itemBuilder: (context, index) {
                          final trip = trips[index];
                          return RideOfferCard(
                            pickupTime: trip.time ?? '',
                            dropTime: trip
                                .time ?? '', // Placeholder; use same as pickup or calculate later
                            pickupLocation: trip.source ?? '',
                            dropLocation: trip.destination ?? '',
                            vehicleName: trip.vehicleName ?? '',
                            price: trip.price?.toString() ?? '0',
                            driverName: trip.driverName ?? '',
                            driverImage: trip.driverImage?.isNotEmpty ?? false
                                ? '${AppUrl.imageUrl}/${trip.driverImage}'
                                : 'assets/images/user_pic.png',
                            vehicleImage: trip.vehicleImage?.isNotEmpty ?? false
                                ? '${AppUrl.imageUrl}/${trip.vehicleImage}'
                                : 'assets/images/user_pic.png',
                            rating: double.tryParse(trip.rating ?? '0') ?? 0.0,
                            bookRide: () async {
                              final uid = await LocalStorage.getUserId() ?? "";
                              await provider.bookSeat(
                                uid: uid,
                                tripId: trip.tripId?.toString() ?? '',
                                seats: "1", // Assuming 1 seat; adjust as needed
                                pickupAdd: trip.source ?? '',
                                dropAdd: trip.destination ?? '',
                                pickupLat: trip.routeStops.isNotEmpty ? trip.routeStops.first.lat ?? '' : "",
                                pickupLng: trip.routeStops.isNotEmpty ? trip.routeStops.first.lng ?? '' : "",
                                dropLat: trip.routeStops.length > 1 ? trip.routeStops.last.lat ?? '' : "",
                                dropLng: trip.routeStops.length > 1 ? trip.routeStops.last.lng ?? '' : "",
                                price: trip.price?.toString() ?? '0',
                                paymentId: "9", // Placeholder; derive from payment flow
                                isForOthers: false, // For self; set to true for others
                                // otherRiderName: null,
                                // otherRiderPhone: null,
                              );
                              if (isStatusSuccess(provider.bookResponse.status)) {
                                // Navigate or handle success, e.g., Navigator.pop(context);
                              } else { 
                              }
                            },
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
              // Loading overlay for booking
              if (isStatusLoading(provider.bookResponse.status))
                Container(
                  color: Colors.black.withOpacity(0.1),
                  child: const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,)),
                ),
            ],
          );
        },
      ),
    );
  }

  String _formatDate(String date) {
    if (date.isEmpty) return "Select Date";
    try {
      final parsed = DateTime.parse(date);
      return "${_getWeekday(parsed)}, ${parsed.day} ${_getMonth(parsed)}, ${parsed.year}";
    } catch (e) {
      return date;
    }
  }

  String _getWeekday(DateTime date) {
    const weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return weekdays[date.weekday - 1];
  }

  String _getMonth(DateTime date) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[date.month - 1];
  }
}
