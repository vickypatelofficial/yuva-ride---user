import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yuva_ride/utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final double borderRadius;
  final Color backgroundColor;
  final Color? borderColor;
  final double? elevation;
  final Color? textColor;
  final double? borderWidth;
  final double? height;
  final double? width;
  final double? textVerticalPadding;

  const CustomButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.isLoading = false,
      this.borderRadius = 40.0,
      this.backgroundColor = AppColors.primaryColor,
      this.elevation,
      this.borderColor,
      this.borderWidth,
      this.textColor, this.height, this.width, this.textVerticalPadding});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
            color: borderColor ?? Colors.transparent,
            width: borderColor != null
                ? (borderWidth ?? 1.5)
                : (borderWidth ?? 0)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.22),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        elevation: elevation ?? 2,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: Colors.white.withOpacity(0.25),
          highlightColor: Colors.white.withOpacity(0.1),
          child: Ink(
            decoration: BoxDecoration(
              color: isLoading
                  ? backgroundColor.withOpacity(0.7)
                  : backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Container(
              width: double.infinity,
              padding:  EdgeInsets.symmetric(vertical:textVerticalPadding?? 15),
              alignment: Alignment.center,
              child: 
              isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : 
                  Text(
                      text,
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: (textColor ?? Colors.white),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
