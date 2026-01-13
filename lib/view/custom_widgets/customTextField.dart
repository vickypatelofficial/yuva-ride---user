import 'package:flutter/material.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;

  final String? errorText;
  final bool obscure;
  final bool readOnly;
  final bool enabled;
  final int maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final double? borderRadius;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final void Function(String)? onChanged;
  final void Function()? onTap;
  final String? Function(String?)? validator;

  final FocusNode? focusNode;
  final bool autofocus;
  final Color? fillColor;
  final TextStyle? hintStyle;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.borderRadius,
    this.errorText,
    this.obscure = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onTap,
    this.validator,
    this.focusNode,
    this.fillColor,
    this.autofocus = false, this.hintStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      readOnly: readOnly,
      enabled: enabled,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onTap: onTap,
      validator: validator,
      focusNode: focusNode,
      autofocus: autofocus,
      style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
      decoration: InputDecoration(
        
        hintText: hint,
        counterText: "",
        hintStyle: hintStyle?? GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: fillColor ?? Colors.grey.shade100,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius??10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius??10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius??10),
          borderSide:
              const BorderSide(color: AppColors.primaryColor, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppColors.red, width: 1.2),
        ),
        errorText: errorText,
        errorStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.red),
      ),
    );
  }
}
