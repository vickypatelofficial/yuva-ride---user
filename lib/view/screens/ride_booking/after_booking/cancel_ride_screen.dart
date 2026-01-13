// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yuva_ride/main.dart';
import 'package:yuva_ride/provider/book_ride_provider.dart';
import 'package:yuva_ride/services/status.dart';
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
  int? selectedId;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    context.read<BookRideProvider>().cancelRideReason();
    return CustomScaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: 100,
            color: AppColors.primaryColor,
            padding: const EdgeInsets.only(top: 30, left: 18, right: 18),
            child: const Row(
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
          Consumer<BookRideProvider>(builder: (context, provider, _) {
            final reasons = provider.cancelRideReasonState.data?.rideCancelList;
            if (isStatusLoading(provider.cancelRideReasonState.status) ||
                isStatusError(provider.cancelRideReasonState.status)) {
              return Padding(
                  padding: EdgeInsets.only(top: screenHeight * .3),
                  child: const SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(
                          color: AppColors.primaryColor)));
            } else
              return Expanded(
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  itemCount: reasons?.length ?? 0,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            reasons?[index].title ?? '',
                            style: text.bodyMedium!.copyWith(
                              color: Colors.black,
                              height: 1.3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () =>
                              setState(() => selectedId = reasons?[index].id),
                          child: Icon(
                            selectedId == reasons?[index].id
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
              );
          }),
          const SizedBox(height: 20),
          Consumer<BookRideProvider>(builder: (context, provider, child) {
            return isStatusLoading(provider.cancelRideReasonState.status) ||
                    isStatusError(provider.cancelRideReasonState.status)
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: CustomInkWell(
                      onTap: () async {
                        // print(provider.rideDetailState.data?.requestTableId);
                        // print(provider.rideDetailState.data);
                        // return;
                        String? cartId;
                        if (provider.rideDetailState.data?.cartTableId !=
                                null &&
                            (provider.rideDetailState.data?.cartTableId
                                    .isNotEmpty ??
                                false)) {
                          cartId = provider.rideDetailState.data?.cartTableId;
                        }
                        String? requestId =
                            provider.rideDetailState.data?.requestTableId ?? '';

                        if (selectedId == null) return;
                        await provider.cancelRide(
                            cancelId: (selectedId?.toString())!,
                            requestId: cartId ?? requestId);
                        if (isStatusSuccess(provider.cancelRideState.status)) {
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
                        child: isStatusLoading(provider.cancelRideState.status)
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
