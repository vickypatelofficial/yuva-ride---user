import 'package:flutter/material.dart';
import 'package:yuva_ride/utils/app_colors.dart';

class CustomRadioContainer extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final double size;

  const CustomRadioContainer({
    super.key,
    required this.isSelected,
    required this.onTap,
    this.size = 22,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size),
      child: Container(
        height: size,
        width: size,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : Colors.grey,
            width: 2,
          ),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected
                ? AppColors.primaryColor
                : Colors.transparent,
          ),
        ),
      ),
    );
  }
}
