import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:yuva_ride/main.dart';
import 'package:yuva_ride/provider/book_ride_provider.dart';
import 'package:yuva_ride/provider/ride_share_provider.dart';
import 'package:yuva_ride/services/map_services.dart';
import 'package:yuva_ride/services/local_storage.dart';
import 'package:yuva_ride/services/status.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/app_fonts.dart';
import 'package:yuva_ride/utils/app_urls.dart';
import 'package:yuva_ride/view/custom_widgets/cusotm_back.dart';
import 'package:yuva_ride/view/custom_widgets/custom_button.dart';
import 'package:yuva_ride/view/custom_widgets/custom_inkwell.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:yuva_ride/utils/animations.dart';
import 'package:yuva_ride/view/screens/ride_booking/book_ride/book_ride_vehicle_screen.dart';
import 'package:yuva_ride/view/screens/ride_booking/book_ride/select_location_map_screen.dart';
import 'package:yuva_ride/view/screens/ride_sharing/share_ride/ride_sharing_list_screen.dart';

class SelectLocationShareScreen extends StatefulWidget {
  const SelectLocationShareScreen({super.key});

  @override
  State<SelectLocationShareScreen> createState() =>
      _SelectLocationShareScreenState();
}

class _SelectLocationShareScreenState extends State<SelectLocationShareScreen> {
  int selectedVehicle = 1;

  final List<Map<String, dynamic>> vehicleList = [
    {"img": "vehicle.png", "name": "Bike"},
    {"img": "car_book.png", "name": "Car"},
    {"img": "auto_book.png", "name": "Auto"},
    {"img": "auto_book.png", "name": "Auto"},
  ];

  DateTime? selectedDate;
  TextEditingController dateController = TextEditingController();
  TextEditingController passengersController = TextEditingController();
  Future<void> pickDate() async {
    final DateTime now = DateTime.now();

    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.deepOrange, // calendar top bar
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (newDate != null) {
      selectedDate = newDate;

      dateController.text = "${newDate.day}/${newDate.month}/${newDate.year}";

      setState(() {});
    }
  }

  @override
  initState() {
    super.initState();

    context.read<RideSharingProvider>().fetchSignupDetail();
    _loadCurrentLocation();
  }

  LatLng? currentLatLng;
  Future<void> _loadCurrentLocation() async {
    currentLatLng = await MapService.getCurrentLatLng();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    final rideShareProvider = context.watch<RideSharingProvider>();
    final vehicleList = rideShareProvider.signupDetailState.data?.vehicles
        .where((e) => e.serviceCategory == 'ride_share')
        .toList();
    return CustomScaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              /// ORANGE HEADER
              Container(
                height: 250,
                color: AppColors.white,
              ),
              Container(
                height: 200,
                width: double.infinity,
                color: AppColors.primaryColor,
              ),
              Positioned.fill(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),

                    /// BACK BUTTON
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: CustomBack(),
                    ),

                    const SizedBox(height: 20),

                    /// WHITE PICKUP/DROP CARD
                    Consumer<RideSharingProvider>(
                        builder: (context, provider, child) {
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
                                              type: 'pickup',
                                              latLng: provider
                                                      .pickupLocation?.latLng ??
                                                  currentLatLng,
                                              onSelectLocation: (LatLng latLng,
                                                  String address,
                                                  String title,
                                                  String subititle) {
                                                print(
                                                    '++++++========+++++++++');
                                                print(
                                                    '$address, $title, $subititle');
                                                provider.setPickupLocation(
                                                    LocationModel(
                                                        latLng, address,
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
                                              provider.pickupLocation
                                                      ?.address ??
                                                  "Select your Pickup location",
                                              style: text.bodyLarge!.copyWith(
                                                  fontFamily: AppFonts.medium),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                          Image.asset(
                                            'assets/images/gps.png',
                                            height: 20,
                                            width: 20,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return SizedBox();
                                            },
                                          )
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
                                          padding: EdgeInsets.only(
                                              left: 5, right: 5),
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
                                              type: 'drop',
                                              latLng: provider
                                                      .dropLocation?.latLng ??
                                                  currentLatLng,
                                              onSelectLocation: (LatLng latLng,
                                                  String address,
                                                  String title,
                                                  String subititle) {
                                                provider.setDropLocation(
                                                    LocationModel(
                                                        latLng, address,
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
                                              overflow: TextOverflow.ellipsis,
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
                    // const SizedBox(height: 30),
                    //  if(false)
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Select Date
                  Text(
                    "Select Date",
                    style: text.titleMedium!
                        .copyWith(fontFamily: AppFonts.semiBold),
                  ),
                  const SizedBox(height: 10),
                  Builder(builder: (context) {
                    return ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(12),
                      child: TextField(
                        controller: dateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: "Select Date",
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none),
                          suffixIcon: const Icon(
                            Icons.calendar_month_outlined,
                            color: Colors.black45,
                          ),
                        ),
                        onTap: pickDate,
                      ),
                    );
                  }),
                  const SizedBox(height: 10),

                  Text(
                    "Passengers capacity",
                    style: text.titleMedium!
                        .copyWith(fontFamily: AppFonts.semiBold),
                  ),
                  const SizedBox(height: 10),

                  ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(12),
                    child: TextField(
                      controller: passengersController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Enter Passengers capacity",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon:
                            const Icon(Icons.person, color: Colors.black45),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  /// Select Vehicle
                  Text(
                    "Select vehicle",
                    style: text.titleMedium!
                        .copyWith(fontFamily: AppFonts.semiBold),
                  ),
                  const SizedBox(height: 14),

                  Consumer<RideSharingProvider>(
                      builder: (context, provider, _) {
                    return SizedBox(
                      height: 110,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: vehicleList?.length ?? 0,
                        separatorBuilder: (_, __) => const SizedBox(width: 14),
                        itemBuilder: (_, index) {
                          bool active =
                              selectedVehicle == vehicleList?[index].id;
                          final data = vehicleList?[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() =>
                                  selectedVehicle = vehicleList![index].id);
                                  print(selectedVehicle);
                            },
                            child: Container(
                              width: 95,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: active
                                      ? AppColors.primaryColor
                                      : Colors.grey.shade300,
                                  width: active ? 2 : 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(.05),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  )
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network(
                                    '${AppUrl.imageUrl}/${data?.image ?? ''}',
                                    height: 42,
                                    errorBuilder: (context, _, __) =>
                                        Image.asset(
                                      'assets/images/bike_book.png',
                                      height: 42,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    data?.name ?? "",
                                    style: text.bodyMedium,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                  const SizedBox(height: 40),

                  /// SEARCH BUTTON
                  Consumer<RideSharingProvider>(
                    builder: (context, rideProvider, child) {
                      return Consumer<BookRideProvider>(
                        builder: (context, bookProvider, child) {
                          return CustomButton(
                            text: isStatusLoading(
                                    rideProvider.searchResponse.status)
                                ? "Searching..."
                                : "Search",
                            isLoading: isStatusLoading(
                                rideProvider.searchResponse.status),
                            onPressed: () async {
                              if (rideProvider.pickupLocation == null ||
                                  rideProvider.dropLocation == null ||
                                  selectedDate == null ||
                                  passengersController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Please fill all fields")),
                                );
                                return;
                              }

                              final uid = await LocalStorage.getUserId() ??
                                  ""; // Placeholder if not available
                              final pickupLatLon =
                                  "${rideProvider.pickupLocation!.latLng.latitude},${rideProvider.pickupLocation!.latLng.longitude}";
                              final dropLatLon =
                                  "${rideProvider.dropLocation!.latLng.latitude},${rideProvider.dropLocation!.latLng.longitude}";
                              const sourceCity =
                                  "Hyderabad"; // Placeholder; derive from geocoding if needed
                              const destCity = "Suryapet"; // Placeholder
                              final date =
                                  "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";
                              final seatsNeeded = passengersController.text;
                              final vehicleId = selectedVehicle.toString() ??
                                  "";

                              await rideProvider.searchTrips(
                                uid: uid,
                                pickupLatLon: pickupLatLon,
                                dropLatLon: dropLatLon,
                                sourceCity: sourceCity,
                                destCity: destCity,
                                date: date,
                                seatsNeeded: seatsNeeded,
                                vehicleId: vehicleId,
                              );

                              if (isStatusSuccess(
                                  rideProvider.searchResponse.status)) {
                                Navigator.push(
                                  // ignore: use_build_context_synchronously
                                  context,
                                  AppAnimations.fade(const RideListScreen()),
                                );
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color color) => Container(
        height: 14,
        width: 14,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      );
}
