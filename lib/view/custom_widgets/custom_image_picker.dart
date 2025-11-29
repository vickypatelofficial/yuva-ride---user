import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomImagePicker extends StatelessWidget {
  final File? file;
  final VoidCallback onPick;

  const CustomImagePicker({
    super.key,
    required this.file,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPick,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xffE7F2FF),
          borderRadius: BorderRadius.circular(18),
        ),
        child: file == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.upload, size: 35, color: Colors.black45),
                  const SizedBox(height: 8),
                  Text("Upload profile image",
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  Text("PNG, JPG",
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: Colors.grey)),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.file(file!, fit: BoxFit.cover),
              ),
      ),
    );
  }
}
