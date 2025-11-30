import 'package:flutter/material.dart';

class CustomInkWell extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  final double borderRadius;
  final Color backgroundColor;
  final bool isLoading;
  final double elevation;
  final EdgeInsetsGeometry? padding;
  final Border? border;

  const CustomInkWell({
    super.key,
    required this.child,
    required this.onTap,
    this.borderRadius = 12,
    this.backgroundColor = Colors.transparent,
    this.isLoading = false,
    this.elevation = 0,
    this.padding, this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: elevation,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        // ignore: deprecated_member_use
        splashColor: Colors.black.withOpacity(0.15),
        // ignore: deprecated_member_use
        highlightColor: Colors.black.withOpacity(0.05),

        child: Ink(
          padding: padding ?? EdgeInsets.zero,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: border
          ),

          child: child,
        ),
      ),
    );
  }
}
