import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:yuva_ride/view/custom_widgets/cusotm_back.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/app_fonts.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen>
    with SingleTickerProviderStateMixin {
  String selectedLang = "English";

  late AnimationController animCtrl;
  late Animation<double> scaleAnim;
  late Animation<double> fadeAnim;

  final List<Map<String, String>> languages = [
    {"name": "English", "image": "english.png"},
    {"name": "Telugu", "image": "telugu.png"},
    {"name": "Hindi", "image": "hindi.png"},
    {"name": "Tamil", "image": "tamil.png"},
  ];

  @override
  void initState() {
    super.initState();

    /// Selection animation setup
    animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    scaleAnim = Tween<double>(begin: 0.7, end: 1.1)
        .chain(CurveTween(curve: Curves.elasticOut))
        .animate(animCtrl);

    fadeAnim = Tween<double>(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.easeOut))
        .animate(animCtrl);
  }

  @override
  void dispose() {
    animCtrl.dispose();
    super.dispose();
  }

  void selectLanguage(String lang) {
    setState(() => selectedLang = lang);
    animCtrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final text = Theme.of(context).textTheme;

    return CustomScaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: h * 0.015),

              /// ---------------- HEADER ----------------
              Row(
                children: [
                  CustomBack(),
                  SizedBox(width: w * 0.03),
                  AutoSizeText(
                    "Language",
                    maxLines: 1,
                    style: text.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.medium,
                    ),
                  ),
                ],
              ),

              SizedBox(height: h * 0.030),

              Expanded(
                child: ListView.builder(
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    final lang = languages[index]["name"]!;
                    final img = languages[index]["image"]!;
                    return _languageTile(
                      w,
                      h,
                      text,
                      lang,
                      img,
                      isSelected: selectedLang == lang,
                      onTap: () => selectLanguage(lang),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _languageTile(
    double w,
    double h,
    TextTheme text,
    String lang,
    String image, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: EdgeInsets.only(bottom: h * 0.018),
        padding: EdgeInsets.symmetric(
          horizontal: w * 0.04,
          vertical: h * 0.017,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor.withOpacity(.04)
              : AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: w * 0.12,
              width: w * 0.12,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(
                child: Image.asset(
                  "assets/images/$image",
                  fit: BoxFit.contain, // << contain used as required
                ),
              ),
            ),

            SizedBox(width: w * 0.05),

            /// LANGUAGE NAME
            Expanded(
              child: AutoSizeText(
                lang,
                maxLines: 1,
                minFontSize: 14,
                style: text.titleMedium!.copyWith(
                  fontFamily: AppFonts.medium,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            /// RADIO SELECTION WITH ANIMATION
            AnimatedBuilder(
              animation: animCtrl,
              builder: (_, child) {
                return Transform.scale(
                  scale: isSelected ? scaleAnim.value : 1,
                  child: Opacity(
                    opacity: isSelected ? fadeAnim.value : 0.6,
                    child: child,
                  ),
                );
              },
              child: Container(
                height: w * 0.065,
                width: w * 0.065,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryColor
                        : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          height: w * 0.032,
                          width: w * 0.032,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
