
import 'package:flutter/material.dart';
import 'package:yuva_ride/view/custom_widgets/cusotm_back.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/app_fonts.dart';

class RideBookingDetailsScreen extends StatefulWidget {
  const RideBookingDetailsScreen({super.key});

  @override
  State<RideBookingDetailsScreen> createState() => _RideBookingDetailsScreenState();
}

class _RideBookingDetailsScreenState extends State<RideBookingDetailsScreen> {
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return CustomScaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          /// --------------
          /// -- TOP BAR ----------------
          Container(
            height: h * 0.13,
            width: double.infinity,
            color: AppColors.primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
               CustomBack(),
                const SizedBox(width: 14),
                Text(
                  "#25",
                  style: text.titleMedium!.copyWith(
                    color: Colors.white,
                    fontFamily: AppFonts.medium,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                _statusTag(),
              ],
            ),
          ),

          /// ---------------- MAP SECTION ----------------
          Container(
            height: h * 0.28,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(20)),
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
          ),

          const SizedBox(height: 14),

          /// ---------------- MAIN CONTENT SCROLL ----------------
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ---------------- BIKE ROW ----------------
                    Row(
                      children: [
                        Image.asset("assets/images/bike_book.png", height: 24),
                        const SizedBox(width: 8),
                        Text(
                          "Bike",
                          style: text.titleMedium!
                              .copyWith(fontFamily: AppFonts.medium),
                        ),
                        const Spacer(),
                        Text("5:30 PM", style: text.bodyMedium),
                        const SizedBox(width: 8),
                        Text("12/07/2025", style: text.bodyMedium),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// ---------------- RIDE DETAILS CARD ----------------
                    _rideDetailsCard(text),

                    const SizedBox(height: 20),

                    /// ---------------- PAYMENT DETAILS CARD ----------------
                    _paymentDetailsCard(text),

                    const SizedBox(height: 20),

                    /// ---------------- SUPPORT ----------------
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
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 48,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Center(
                          child: Text(
                            "Invoice",
                            style: text.titleMedium!.copyWith(
                              color: Colors.white,
                              fontFamily: AppFonts.medium,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// COMPLETED STATUS TAG
  /// ----------------------------------------------------
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

  /// ----------------------------------------------------
  /// RIDE DETAILS CARD
  /// ----------------------------------------------------
  Widget _rideDetailsCard(TextTheme text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.06),
              blurRadius: 8,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ride Details",
                style:
                    text.titleMedium!.copyWith(fontFamily: AppFonts.medium),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------------- LEFT SIDE COLUMN ----------------
                  Column(
                    children: [
                      // Green dot
                      Container(
                        height: 16,
                        width: 16,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
          
                      const SizedBox(height: 4),
          
                      // Vertical line
                      Container(
                        height: 35,
                        width: 2,
                        color: Colors.black,
                      ),
          
                      const SizedBox(height: 4),
          
                      // Red dot
                      Container(
                        height: 16,
                        width: 16,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
          
                  const SizedBox(width: 14),
          
                  // ---------------- RIGHT SIDE TEXT ----------------
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pickup
                        Text(
                          "9-120, Madhapur metro station,\nHyderabad",
                          style: text.bodyLarge,
                        ),
          
                        const SizedBox(height: 6),
          
                        // Divider (aligned to text)
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: Colors.grey.shade300,
                        ),
          
                        const SizedBox(height: 6),
          
                        // Drop
                        Text(
                          "9-120, Hitech metro station,\nHyderabad",
                          style: text.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// OTHER DETAILS
          _detailRow("Vehicle type", "Bike", text),
          _detailRow("Hours/minutes", "0 hours 5 minutes", text),
          _detailRow("Date & time", "5:30 PM,12/07/2025", text),
          _detailRow("Distance", "4.5 Kms", text),
          _detailRow("Ride ID", "PL234865734656", text),
        ],
      ),
    );
  }

  Widget _detailRow(String left, String right, TextTheme text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Text(left, style: text.bodyMedium),
          const Spacer(),
          Text(right,
              style: text.bodyMedium!.copyWith(fontFamily: AppFonts.semiBold)),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// PAYMENT CARD
  /// ----------------------------------------------------
  Widget _paymentDetailsCard(TextTheme text) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Payment Details  Details",
              style: text.titleMedium!.copyWith(fontFamily: AppFonts.medium)),
          const SizedBox(height: 12),
          _detailRow("Ride fair", "₹80", text),
          _detailRow("Payment ( cash )", "₹80", text),
        ],
      ),
    );
  }
}
