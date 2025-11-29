import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yuva_ride/view/custom_widgets/cusotm_back.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/app_fonts.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final nameCtrl = TextEditingController(text: "Shiva Kumar");
  final emailCtrl = TextEditingController(text: "Shivakumar348@gmail.com");
  final phoneCtrl = TextEditingController(text: "+91743576796");

  File? pickedImage;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      setState(() => pickedImage = File(file.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return CustomScaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * .04),
            child: Column(
              children: [
                SizedBox(height: height * .02),

                // BACK + TITLE
                Row(
                  children: [
                   CustomBack(),
                    SizedBox(width: width * .03),
                    Text(
                      "My Profile",
                      style: text.titleMedium!.copyWith(
                        fontFamily: AppFonts.medium,
                        fontWeight: FontWeight.bold,
                        fontSize: width * .05,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: height * .05),

                // PROFILE IMAGE
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: width * .18,
                      backgroundImage: pickedImage != null
                          ? FileImage(pickedImage!)
                          : const AssetImage("assets/images/profile_image.png")
                              as ImageProvider,
                    ),
                    Positioned(
                      bottom: width * .02,
                      right: width * .02,
                      child: GestureDetector(
                        onTap: pickImage,
                        child: CircleAvatar(
                          radius: width * .05,
                          backgroundColor: AppColors.primaryColor,
                          child: Icon(Icons.edit,
                              size: width * .035, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: height * .05),

                // NAME FIELD
                _inputBox(
                  width: width,
                  child: TextField(
                    controller: nameCtrl,
                    style: text.bodyLarge!.copyWith(fontSize: width * .045),
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                ),

                SizedBox(height: height * .02),

                // EMAIL FIELD
                _inputBox(
                  width: width,
                  child: TextField(
                    controller: emailCtrl,
                    style: text.bodyLarge!.copyWith(fontSize: width * .045),
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                ),

                SizedBox(height: height * .02),

                // PHONE FIELD
                _inputBox(
                  width: width,
                  child: TextField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    style: text.bodyLarge!.copyWith(fontSize: width * .045),
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                ),

                SizedBox(height: height * .05),

                // UPDATE BUTTON
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: height * .065,
                    width: width,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        "Update",
                        style: text.titleMedium!.copyWith(
                          color: Colors.white,
                          fontFamily: AppFonts.medium,
                          fontSize: width * .05,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: height * .04),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputBox({required Widget child, required double width}) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: width * .04, vertical: width * .02),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}
