import 'package:flutter/material.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/view/custom_widgets/custom_inkwell.dart';

class PassengersCard extends StatelessWidget {
  final TextTheme text;

  final String passengerName;
  final String passengerImage;
  final String routeText;
  final String viewDetailsText;
  final VoidCallback? onViewDetails;

  const PassengersCard({
    super.key,
    required this.text,
    required this.passengerName,
    required this.passengerImage,
    required this.routeText,
    this.viewDetailsText = "View Details",
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          Text(
            "Passengers",
            style: text.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: screenWidth * 0.03),

          /// PASSENGER ROW
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// PROFILE IMAGE
              Image.asset(
                passengerImage,
                height: screenWidth * 0.12,
              ),

              SizedBox(width: screenWidth * 0.03),

              /// NAME + ROUTE + VIEW DETAILS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// PASSENGER NAME
                    Text(
                      passengerName,
                      style: text.bodyLarge,
                    ),

                    SizedBox(height: screenWidth * 0.01),

                    /// ROUTE + VIEW DETAILS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// ROUTE TEXT
                        Expanded(
                          child: Text(
                            routeText,
                            style: text.bodySmall!.copyWith(
                              color: Colors.black54,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        SizedBox(width: 8),

                        /// VIEW DETAILS BUTTON
                        CustomInkWell(
                          onTap: onViewDetails,
                          child: Text(
                            viewDetailsText,
                            style: text.bodySmall!.copyWith(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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
}
