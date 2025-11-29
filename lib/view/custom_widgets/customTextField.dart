
import 'package:flutter/material.dart';
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

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final void Function(String)? onChanged;
  final void Function()? onTap;
  final String? Function(String?)? validator;

  final FocusNode? focusNode;
  final bool autofocus;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.controller,
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
    this.autofocus = false,
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
        hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),

        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,

        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),

        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xff0077CC), width: 1.2),
        ),

        errorText: errorText,
        errorStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.red),
      ),
    );
  }
}
