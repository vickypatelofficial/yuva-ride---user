import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yuva_ride/provider/book_ride_provider.dart';
import 'package:yuva_ride/view/custom_widgets/cusotm_back.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/app_fonts.dart';

class ChoosePaymentModeScreen extends StatefulWidget {
  const ChoosePaymentModeScreen({super.key});

  @override
  State<ChoosePaymentModeScreen> createState() =>
      _ChoosePaymentModeScreenState();
}

class _ChoosePaymentModeScreenState extends State<ChoosePaymentModeScreen> {
  String selected = "Cash"; // default selected

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final bookProvider = context.read<BookRideProvider>();

    return CustomScaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ----------------------------- TOP ORANGE BAR -----------------------------
          Container(
            height: 130,
            width: double.infinity,
            color: AppColors.primaryColor,
            padding: const EdgeInsets.only(top: 50, left: 18, right: 18),
            child: Row(
              children: [
                CustomBack(),
                const SizedBox(width: 12),
                Text(
                  "Choose Payment mode",
                  style: textTheme.titleMedium!.copyWith(
                      color: Colors.white, fontFamily: AppFonts.medium),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Consumer<BookRideProvider>(
            builder: (context,provider,_) {
              return Expanded(
                child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    children: List.generate(
                        bookProvider.paymentCouponState.data?.paymentList.length ??
                            0, (index) {
                      final data =
                          bookProvider.paymentCouponState.data?.paymentList[index];
                      return Padding(
                        padding: const EdgeInsets.only(top: 5,bottom: 5),
                        child: _paymentTile(
                          textTheme,
                          title: data?.name ?? '',
                          subtitle: data?.subTitle ?? '',
                          isSelected: bookProvider.selectedPayment?.id ==
                              data?.id?.toString(),
                          iconImage: data?.image ?? '',
                          ontap: () {
                            bookProvider.setPayment(
                                data?.name ?? '', data?.id?.toString() ?? "");
                          },
                        ),
                      );
                    })
                    // [
                    //   _paymentTile(
                    //     text,
                    //     title: "Cash",
                    //     subtitle: "Pay with cash/ Qr code",
                    //     value: "Cash",
                    //     icon: Icons.currency_rupee,
                    //   ),
                    //   const SizedBox(height: 15),
                    //   _paymentTile(
                    //     text,
                    //     title: "Pay by UPI",
                    //     subtitle: "Pay using Phonepe, Googlepay",
                    //     value: "UPI",
                    //     icon: Icons.account_balance_wallet_outlined,
                    //   ),
                    //   const SizedBox(height: 15),
                    //   _paymentTile(
                    //     text,
                    //     title: "Wallet",
                    //     subtitle: "Balance ₹500",
                    //     value: "Wallet",
                    //     icon: Icons.wallet_rounded,
                    //   ),
                    // ],
                    ),
              );
            }
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    "Confirm",
                    style: textTheme.titleMedium!.copyWith(
                        color: Colors.white, fontFamily: AppFonts.medium),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // PAYMENT ITEM TILE
  // -------------------------------------------------------------------------
  Widget _paymentTile(
    TextTheme text, {
    required String title,
    required String subtitle,
    required bool isSelected,
    required String iconImage,
    required VoidCallback ontap,
  }) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
              width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.07),
              blurRadius: 10,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            Image.network(
              iconImage,
              width: 26,
              height: 26,
              errorBuilder: (context, error, _) {
                return const Icon(Icons.currency_rupee,
                    color: AppColors.primaryColor, size: 26);
              },
            ),

            const SizedBox(width: 16),

            // TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: text.titleMedium!
                          .copyWith(fontFamily: AppFonts.medium)),
                  const SizedBox(height: 3),
                  Text(subtitle,
                      style: text.bodySmall!.copyWith(color: Colors.grey)),
                ],
              ),
            ),

            // RIGHT RADIO INDICATOR
            Container(
              height: 28,
              width: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: isSelected
                        ? AppColors.primaryColor
                        : Colors.grey.shade400,
                    width: 2),
                color: isSelected ? AppColors.primaryColor : Colors.white,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
