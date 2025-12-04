import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:yuva_ride/main.dart';
import 'package:yuva_ride/services/map_services.dart';
import 'package:yuva_ride/utils/app_dimensions.dart';
import 'package:yuva_ride/view/custom_widgets/cusotm_back.dart';
import 'package:yuva_ride/view/custom_widgets/custom_button.dart';
import 'package:yuva_ride/view/custom_widgets/custom_inkwell.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yuva_ride/utils/animations.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/app_fonts.dart';
import 'package:yuva_ride/view/screens/ride_booking/after_booking/partener_on_the_way_screen.dart';
import 'package:yuva_ride/view/screens/ride_booking/book_ride/choose_payment_screen.dart';
import 'package:yuva_ride/view/screens/ride_booking/book_ride/offer_selection_screen.dart';

import 'package:flutter/services.dart';
import 'dart:ui' as ui;

class BookRideFareScreen extends StatefulWidget {
  const BookRideFareScreen({super.key});
  @override
  State<BookRideFareScreen> createState() => _BookRideFareScreenState();
}

class _BookRideFareScreenState extends State<BookRideFareScreen>
    with SingleTickerProviderStateMixin {
  GoogleMapController? mapController;

  // Animation
  late AnimationController sheetCtrl;
  late Animation<double> slideAnim;
  late Animation<double> bounceAnim;
  final MapService mapService = MapService();
  Set<Marker> markers = {};
  // VEHICLE SELECT
  String selectedVehicle = "";
  int selectedFare = 60;
  List<int> fareOptions = [60, 80, 100, 120];

  @override
  void initState() {
    super.initState();
    mapService.loadVehicleMarkers().then((value) {
      setState(() => markers = value);
    });

    sheetCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    slideAnim = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: sheetCtrl, curve: Curves.easeOutCubic),
    );

    bounceAnim = Tween<double>(begin: 25, end: 0).animate(
      CurvedAnimation(parent: sheetCtrl, curve: Curves.elasticOut),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      sheetCtrl.forward();
    });
  }

  Future<BitmapDescriptor> getResizedMarker(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final Uint8List bytes = data.buffer.asUint8List();

    final ui.Codec codec =
        await ui.instantiateImageCodec(bytes, targetWidth: width);
    final ui.FrameInfo fi = await codec.getNextFrame();

    final Uint8List resizedBytes =
        (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
            .buffer
            .asUint8List();

    // ignore: deprecated_member_use
    return BitmapDescriptor.fromBytes(resizedBytes);
  }

  @override
  void dispose() {
    sheetCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return CustomScaffold(
      body: Stack(
        children: [
          /// TOP ORANGE
          Container(height: 120, color: AppColors.primaryColor),

          const Positioned(
            top: 30,
            left: 18,
            right: 18,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomBack(),
              ],
            ),
          ),

          /// GOOGLE MAP
          Positioned.fill(
            top: 90,
            child: GoogleMap(
              onMapCreated: (controller) {
                mapService.initController(controller);

                Future.delayed(const Duration(milliseconds: 500), () {
                  mapService.runAdvancedCameraAnimation(
                      latlng:
                          const LatLng(17.401599313936217, 78.47910862416029));
                });
              },
              onTap: (argument) {
                print(argument.latitude);
                print(argument.longitude);
              },
              initialCameraPosition: const CameraPosition(
                target: LatLng(17.4075, 78.4764),
                zoom: 13.5,
              ),
              markers: markers,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
            ),
          ),

          /// BOTTOM SHEET
          AnimatedBuilder(
            animation: sheetCtrl,
            builder: (context, child) => Transform.translate(
              offset: Offset(0, (slideAnim.value * 550) + bounceAnim.value),
              child: child!,
            ),
            child: _bottomSheet(context, text),
          ),
        ],
      ),
    );
  }

  // -----------------------------
  // BOTTOM SHEET
  // -----------------------------
  Widget _bottomSheet(BuildContext context, TextTheme text) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * .38,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(.22),
              blurRadius: 18,
              offset: const Offset(0, -4),
            )
          ],
        ),
        child: Column(
          children: [
            _topHandle(),
            const SizedBox(height: 10),
            _fareBox(text),
            const SizedBox(height: 20),
            _paymentBar(text), 
             const SizedBox(height: 20,),
            CustomButton(
              onPressed: () {
                Navigator.push(context,
                    AppAnimations.zoomOut(const PartnerOnTheWayScreen()));
              },
              text: "Book a ride",
            ),
          ],
        ),
      ),
    );
  }

  Widget _vehicleList(TextTheme text, String selectedVehicle) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _vehicleItem(
            isSelected: selectedVehicle == "Bike",
            text,
            icon: "assets/images/bike_book.png",
            title: "Bike",
            price: "₹45",
            cutPrice: "₹65",
          ),
          const SizedBox(height: 10),
          _vehicleItem(
            text,
            icon: "assets/images/auto_book.png",
            title: "Auto",
            price: "₹45",
            cutPrice: "₹60",
            isSelected: selectedVehicle == "Auto",
          ),
          const SizedBox(height: 10),
          _vehicleItem(
            text,
            icon: "assets/images/cab_non_ac.png",
            title: "Cab Non AC",
            price: "₹45",
            cutPrice: "₹90",
            isSelected: selectedVehicle == "Cab Non AC",
          ),
          const SizedBox(height: 10),
          _vehicleItem(
            text,
            icon: "assets/images/cab_ac.png",
            title: "Cab AC",
            price: "₹45",
            cutPrice: "₹120",
            isSelected: selectedVehicle == "Cab AC",
          ),
        ],
      ),
    );
  }

  Widget _fareBox(TextTheme text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: screenHeight * .03),
        Text("Choose your amount",
            style: text.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
        Text("Pick your amount and pay your fare.",
            style: text.bodySmall!.copyWith(color: Colors.grey)),
        SizedBox(height: screenHeight * .03),

        /// FARE OPTIONS
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: fareOptions.map((value) {
            bool isSelected = value == selectedFare;

            return GestureDetector(
              onTap: () => setState(() => selectedFare = value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: screenHeight * .05,
                width: screenWidth * .2,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: isSelected
                          ? AppColors.primaryColor
                          : Colors.grey.shade300),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                          color: AppColors.primaryColor.withOpacity(.3),
                          blurRadius: 10)
                  ],
                ),
                child: Center(
                  child: Text(
                  isSelected?"₹$value":  "+₹$value",
                    style: text.titleMedium!.copyWith(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // -----------------------------
  // VEHICLE ITEM (TAP TO SELECT)
  // -----------------------------
  Widget _vehicleItem(TextTheme text,
      {required String icon,
      required String title,
      required String price,
      required bool isSelected,
      required String cutPrice}) {
    return CustomInkWell(
      onTap: () => setState(() => selectedVehicle = title),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 6,
              offset: const Offset(0, 3))
        ],
      ),
      child: Row(
        children: [
          Image.asset(icon, height: 38),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: text.titleMedium!
                        .copyWith(fontFamily: AppFonts.medium)),
                Text("Arrival in 2mins",
                    style: text.labelMedium!
                        .copyWith(color: AppColors.primaryColor)),
              ],
            ),
          ),
          Column(
            children: [
              Text(price,
                  style:
                      text.titleMedium!.copyWith(fontFamily: AppFonts.medium)),
              Text(cutPrice,
                  style: text.bodySmall!
                      .copyWith(decoration: TextDecoration.lineThrough)),
            ],
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            radius: 10,
            backgroundColor: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(
                    color:
                        !isSelected ? AppColors.grey : AppColors.primaryColor),
                shape: BoxShape.circle,
              ),
              child: Container(
                margin: const EdgeInsets.all(3),
                height: 18,
                width: 18,
                decoration: BoxDecoration(
                  color: !isSelected
                      ? AppColors.transparent
                      : AppColors.primaryColor,
                  border: Border.all(
                      color: !isSelected
                          ? AppColors.transparent
                          : AppColors.primaryColor),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // -----------------------------
  Widget _locationCard(TextTheme text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(.08),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                        boxShadow: [
                          BoxShadow(color: Colors.green, blurRadius: 7)
                        ]),
                  ),

                  const SizedBox(height: 4),

                  // Vertical line
                  Container(
                    height: 28,
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
                        boxShadow: [
                          BoxShadow(color: Colors.red, blurRadius: 7)
                        ]),
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
                    Text("9-120, Madhapur metro station,\nHyderabad",
                        style: text.bodyLarge, maxLines: 1),

                    const SizedBox(height: 3),

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
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _paymentBar(TextTheme text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// ---------------- CASH BUTTON ----------------
          _paymentButton(
            context,
            icon: "assets/images/cash.png",
            label: "Cash",
            onTap: () {
              Navigator.push(
                  context, AppAnimations.fade(const ChoosePaymentModeScreen()));
            },
          ),
          _verticalDivider(),

          /// ---------------- OFFERS BUTTON ----------------
          _paymentButton(
            context,
            icon: "assets/images/offer.png",
            label: "Offers",
            onTap: () {
              Navigator.push(
                  context, AppAnimations.fade(const ApplyCouponsScreen()));
            },
          ),
          _verticalDivider(),

          /// ---------------- MY SELF BUTTON ----------------
          _paymentButton(
            context,
            icon: "assets/images/user.png",
            label: "My Self",
            onTap: () {
              _showRideForSomeoneSheet(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(
      height: 32,
      width: 1.2,
      color: Colors.grey.shade300,
      margin: const EdgeInsets.symmetric(horizontal: 6),
    );
  }

  Widget _paymentButton(
    BuildContext context, {
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        splashColor: Colors.orange.withOpacity(.2),
        child: Container(
          height: 35,
          width: MediaQuery.of(context).size.width * 0.23,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(icon, height: 18),
              const SizedBox(width: 6),
              Flexible(
                child: AutoSizeText(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//  _showRideForSomeoneSheet(context);
  Widget _topHandle() {
    return Container(
      height: 4,
      width: 40,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _roundIcon(IconData icon, {bool white = false}) {
    return CircleAvatar(
      backgroundColor: Colors.white.withOpacity(.3),
      child: Icon(icon, color: white ? Colors.white : Colors.black),
    );
  }

  Widget _self(TextTheme text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.2),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white),
      ),
      child: Text("My Self",
          style: text.bodyMedium!
              .copyWith(color: Colors.white, fontFamily: AppFonts.medium)),
    );
  }
}

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
                Icon(Icons.person_outlined),
                SizedBox(
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
