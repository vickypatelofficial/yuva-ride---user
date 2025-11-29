import 'package:flutter/material.dart';
import 'package:yuva_ride/utils/app_colors.dart';

class CustomBack extends StatelessWidget {
  final VoidCallback? onTap;
  final double radius;
  final Color backgroundColor;
  final Color iconColor;
  final IconData icon;

  const CustomBack({
    super.key,
    this.onTap, // optional
    this.radius = 22, // default size
    this.backgroundColor = AppColors.white, // default light bg
    this.iconColor = AppColors.black, // default icon color
    this.icon = Icons.arrow_back, // default icon
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        splashColor: Colors.black.withOpacity(0.1),
        highlightColor: Colors.black.withOpacity(0.05),
        onTap: onTap ?? () => Navigator.pop(context), // default action
        child: CircleAvatar(
          radius: radius,
          backgroundColor: backgroundColor,
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
