import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yuva_ride/provider/book_ride_provider.dart';
import 'package:yuva_ride/services/map_services.dart';
import 'package:yuva_ride/services/status.dart';
import 'package:yuva_ride/view/custom_widgets/cusotm_back.dart';
import 'package:yuva_ride/view/custom_widgets/cusotm_radio_container.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:yuva_ride/main.dart';
import 'package:yuva_ride/utils/animations.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/app_fonts.dart';
import 'package:yuva_ride/view/screens/ride_booking/book_ride/book_ride_vehicle_screen.dart';

import 'package:yuva_ride/view/custom_widgets/custom_inkwell.dart';
import 'package:yuva_ride/view/screens/ride_booking/book_ride/choose_contact_screen.dart';
import 'package:yuva_ride/view/screens/ride_booking/book_ride/select_location_map_screen.dart';

class SelectLocationBookScreen extends StatefulWidget {
  const SelectLocationBookScreen({super.key});

  @override
  State<SelectLocationBookScreen> createState() =>
      _SelectLocationBookScreenState();
}

class _SelectLocationBookScreenState extends State<SelectLocationBookScreen>
    with TickerProviderStateMixin {
  late AnimationController _hintController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  final MapService _mapService = MapService();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      context.read<BookRideProvider>().loadLocations();
    });

    _hintController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _hintController,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_hintController);
    _loadCurrentLocation();
  }

  LatLng? currentLatLng;
  Future<void> _loadCurrentLocation() async {
    currentLatLng = await MapService.getCurrentLatLng();
  }

  bool _showLocationHint = false;
  bool _hintInProgress = false;
  void _triggerLocationHint() {
    if (_hintInProgress) return; // prevent spam

    _hintInProgress = true;
    _showLocationHint = true;

    HapticFeedback.lightImpact();

    _hintController.forward(from: 0);

    setState(() {});

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      _hintController.reverse();
      _showLocationHint = false;
      _hintInProgress = false;

      setState(() {});
    });
  }

  @override
  void dispose() {
    _hintController.dispose();
    super.dispose();
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
          child: Consumer<BookRideProvider>(builder: (context, provider, _) {
            return Column(
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
                    CustomRadioContainer(
                      isSelected: provider.selectedContact?.isSelf == true,
                      onTap: () {
                        provider.selectContact(isSelf: true);
                      },
                    ),
                    const SizedBox(
                      width: 10,
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
                Consumer<BookRideProvider>(builder: (context, provider, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                        (provider.contactState.data?.length ?? 0) > 0 ? 1 : 0,
                        (index) {
                      final contact = provider.contactState.data?[index];
                      return Row(
                        children: [
                          CustomRadioContainer(
                            isSelected:
                                !(provider.selectedContact?.isSelf ?? true),
                            onTap: () {
                              provider.selectContact(
                                isSelf: false,
                                phone: contact?.phone,
                                name: contact?.name,
                                id: contact?.id,
                                cId: contact?.cId,
                                countryCode: contact?.countryCode,
                              );
                            },
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.person_outlined),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(contact?.name ?? '', style: text.bodyLarge),
                              Text(
                                contact?.phone ?? '',
                                style: text.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
                  );
                }),

                const SizedBox(height: 10),

                /// OPTION 3 — CHOOSE ANOTHER CONTACT
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        AppAnimations.fadeSlide(
                            const ChooseSavedContactScreen()));
                  },
                  child: Row(
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
                    onPressed: () {
                      Navigator.pop(context);
                    },
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
            );
          }),
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
                        print(context
                            .read<BookRideProvider>()
                            .selectedContact
                            ?.isSelf);
                        print(context
                            .read<BookRideProvider>()
                            .selectedContact
                            ?.name);
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
                          ((context.read<BookRideProvider>().selectedContact ==
                                      null) ||
                                  (context
                                          .read<BookRideProvider>()
                                          .selectedContact
                                          ?.isSelf ??
                                      true))
                              ? "My Self"
                              : context
                                      .read<BookRideProvider>()
                                      .selectedContact
                                      ?.name ??
                                  "",
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
                                        type: 'pickup',
                                        latLng: bookRideController
                                                .pickupLocation?.latLng ??
                                            currentLatLng,
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
                                        overflow: TextOverflow.ellipsis,
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
                                        type: 'drop',
                                        latLng: bookRideController
                                                .dropLocation?.latLng ??
                                            currentLatLng,
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
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  "Recent Locations",
                  style: text.titleLarge,
                ),
              ),

              const SizedBox(height: 10),

              // Expanded(
              //   child: ListView.builder(
              //     padding: const EdgeInsets.symmetric(horizontal: 18),
              //     itemCount: 4,
              //     itemBuilder: (_, index) {
              //       return Padding(
              //         padding: const EdgeInsets.only(bottom: 18),
              //         child: Row(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             const Icon(Icons.location_on,
              //                 color: AppColors.primaryColor, size: 22),
              //             const SizedBox(width: 12),
              //             Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Text("Madhapur",
              //                     style: text.bodyLarge!
              //                         .copyWith(fontWeight: FontWeight.bold)),
              //                 const SizedBox(height: 2),
              //                 SizedBox(
              //                   width: screenWidth * .8,
              //                   child: Text(
              //                     "9-120, Madhapur metro station, Hyderabad, Telangana",
              //                     style: text.bodySmall,
              //                     overflow: TextOverflow.ellipsis,
              //                     maxLines: 2,
              //                   ),
              //                 ),
              //               ],
              //             )
              //           ],
              //         ),
              //       );
              //     },
              //   ),
              // ),

              Expanded(
                child: Consumer<BookRideProvider>(
                  builder: (context, provider, _) {
                    final state = provider.locationState;

                    if (isStatusLoading(state.status)) {
                      return const LocationShimmer();
                    }

                    if (isStatusError(state.status)) {
                      return Center(
                        child: Text(state.message ?? "Something went wrong"),
                      );
                    }

                    final list = state.data ?? [];

                    if (list.isEmpty) {
                      return const Center(child: Text("No locations found"));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      itemCount: list.length,
                      itemBuilder: (_, index) {
                        final item = list[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: AppColors.primaryColor,
                                size: 22,
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: text.bodyLarge!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 2),
                                  SizedBox(
                                    width: screenWidth * .8,
                                    child: Text(
                                      item.subtitle,
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
                      if (bookRideController.dropLocation == null ||
                          bookRideController.pickupLocation == null) {
                        _triggerLocationHint();
                        return;
                      }

                      return;
                    }
                    // context.read<BookRideProvider>().fetchCategory();
                    final provider = context.read<BookRideProvider>();
                    provider.setCategory('all');
                    provider.setVehicle('', '', '');
                    provider.setCoupon('', null, null);
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
                          const ImageIcon(
                              AssetImage(
                                'assets/images/book_ride.png',
                              ),
                              size: 30,
                              color: AppColors.red),
                          const SizedBox(width: 8),
                          Text("Book Your Ride",
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
          ),
          if (_showLocationHint)
            Positioned.fill(
              child: locationHintUI(context),
            ),
        ],
      ),
    );
  }

  Widget locationHintUI(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Center(
          child: Container(
            width: 240,
            height: 240, // square shape
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(
                color: Colors.orange.withOpacity(0.35),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// ICON CIRCLE
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_on,
                    size: 36,
                    color: Colors.orange,
                  ),
                ),

                const SizedBox(height: 18),

                /// TITLE
                Text(
                  "Location Required",
                  style: text.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),

                /// SUBTITLE
                Text(
                  "Please select both pickup and drop locations to continue",
                  style: text.bodyMedium?.copyWith(
                    color: Colors.black54,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
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

class LocationShimmer extends StatelessWidget {
  const LocationShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      itemCount: 4,
      itemBuilder: (_, __) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Row(
              children: [
                Container(
                  height: 22,
                  width: 22,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 14, width: 120, color: Colors.white),
                    const SizedBox(height: 8),
                    Container(height: 12, width: 220, color: Colors.white),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
