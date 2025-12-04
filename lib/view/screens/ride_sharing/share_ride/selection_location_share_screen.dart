import 'package:flutter/material.dart';
import 'package:yuva_ride/main.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/app_fonts.dart';
import 'package:yuva_ride/view/custom_widgets/cusotm_back.dart';
import 'package:yuva_ride/view/custom_widgets/custom_button.dart';
import 'package:yuva_ride/view/custom_widgets/custom_inkwell.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:yuva_ride/utils/animations.dart';
import 'package:yuva_ride/view/screens/ride_booking/book_ride/book_ride_vehicle_screen.dart';
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
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return CustomScaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              /// ORANGE HEADER
              Container(
                height: 300,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Container(
                        height: 140,
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
                              height: 120,
                              width: 14,
                              child: Column(
                                children: [
                                  _dot(Colors.green),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: 2,
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
                                  SizedBox(
                                    height: 10,
                                  ),
                                  _dot(Colors.red),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * .7,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Text(
                                          "Select your Pickup location",
                                          style: text.bodyLarge!.copyWith(
                                              fontFamily: AppFonts.medium),
                                        ),
                                      ),
                                      const ImageIcon(
                                        AssetImage('assets/images/gps.png'),
                                        size: 20,
                                        color: AppColors.primaryColor,
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 1,
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(left: 5, right: 5),
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
                                  const SizedBox(height: 14),
                                  Row(
                                    children: [
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Text(
                                          "Select your Drop location",
                                          style: text.bodyLarge!.copyWith(
                                              fontFamily: AppFonts.medium),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
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
                    return TextField(
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
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: const Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.black45,
                        ),
                      ),
                      onTap: pickDate,
                    );
                  }),
                  const SizedBox(height: 24),

                  Text(
                    "Passengers capacity",
                    style: text.titleMedium!
                        .copyWith(fontFamily: AppFonts.semiBold),
                  ),
                  const SizedBox(height: 10),

                  TextField(
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
                  const SizedBox(height: 24),

                  /// Select Vehicle
                  Text(
                    "Select vehicle",
                    style: text.titleMedium!
                        .copyWith(fontFamily: AppFonts.semiBold),
                  ),
                  const SizedBox(height: 14),

                  SizedBox(
                    height: 110,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: vehicleList.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 14),
                      itemBuilder: (_, i) {
                        bool active = selectedVehicle == i;
                        return GestureDetector(
                          onTap: () => setState(() => selectedVehicle = i),
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
                                Image.asset(
                                  "assets/images/${vehicleList[i]["img"]}",
                                  height: 40,
                                ),
                                const SizedBox(height: 10),
                                Text(vehicleList[i]["name"],
                                    style: text.bodyMedium),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// SEARCH BUTTON
                  CustomInkWell(
                    borderRadius: 30,
                    onTap: () {
                      Navigator.push(
                        context,
                        AppAnimations.fade(const RideListScreen()),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.search,
                              size: 25,
                              color: AppColors.white,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Search",
                              style: text.titleMedium!.copyWith(
                                color: Colors.white,
                                fontFamily: AppFonts.semiBold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
