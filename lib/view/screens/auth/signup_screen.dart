import 'package:flutter/material.dart';
import 'package:yuva_ride/utils/animations.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:yuva_ride/utils/app_fonts.dart';
import 'otp_verification_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<Offset> topSlide;
  late Animation<Offset> sheetSlide;

  /// TEXT CONTROLLERS
  final firstCtrl = TextEditingController();
  final lastCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();

  /// Error Texts
  String? errorText;
  bool showError = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    topSlide = Tween<Offset>(
      begin: const Offset(0, -1.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    sheetSlide = Tween<Offset>(
      begin: const Offset(0, 1.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    firstCtrl.dispose();
    lastCtrl.dispose();
    emailCtrl.dispose();
    mobileCtrl.dispose();
    _controller.dispose();
    super.dispose();
  }

  // ------------------ VALIDATION ------------------
  bool validate() {
    if (firstCtrl.text.trim().isEmpty) {
      return showErr("First name is required");
    }
    if (lastCtrl.text.trim().isEmpty) {
      return showErr("Last name is required");
    }
    if (emailCtrl.text.trim().isEmpty) {
      return showErr("Email is required");
    }
    if (!emailCtrl.text.contains("@")) {
      return showErr("Enter a valid email");
    }
    if (mobileCtrl.text.trim().length != 10) {
      return showErr("Mobile number must be 10 digits");
    }

    hideErr();
    return true;
  }

  bool showErr(String msg) {
    setState(() {
      errorText = msg;
      showError = true;
    });
    return false;
  }

  void hideErr() {
    setState(() {
      showError = false;
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!showError) errorText = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return CustomScaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          /// -------------- TOP CONTENT --------------
          SafeArea(
            child: SlideTransition(
              position: topSlide,
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  /// TITLE
                  const Text(
                    "Create Your\nAccount",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Sign up to get started with\neasy and affordable rides.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// IMAGE
                  Image.asset(
                    "assets/images/vehicles.png",
                    height: w * 0.95,
                    width: w * 0.95,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ),

          /// -------------- BOTTOM SHEET --------------
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: sheetSlide,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 25),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create an account",
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// ---------------- FIRST NAME ----------------
                    _field("First Name", "Enter First name", firstCtrl),

                    const SizedBox(height: 14),

                    /// ---------------- LAST NAME ----------------
                    _field("Last Name", "Enter Last name", lastCtrl),

                    const SizedBox(height: 14),

                    /// ---------------- EMAIL ----------------
                    _field("Email address", "Enter email address", emailCtrl,
                        type: TextInputType.emailAddress),

                    const SizedBox(height: 14),

                    /// ---------------- MOBILE ----------------
                    _field("Mobile Number", "Enter mobile number", mobileCtrl,
                        type: TextInputType.phone, maxLen: 10),

                    /// ---------------- ERROR TEXT ----------------
                    AnimatedSlide(
                      offset: showError ? Offset.zero : const Offset(0, -0.3),
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      child: AnimatedOpacity(
                        opacity: showError ? 1 : 0,
                        duration: const Duration(milliseconds: 250),
                        child: errorText == null
                            ? const SizedBox()
                            : Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  errorText!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    /// ---------------- CONTINUE BUTTON ----------------
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          if (validate()) {
                            Navigator.push(
                                context,
                                AppAnimations.slideBottomToTop(
                                    OTPVerificationScreen(
                                        mobile: mobileCtrl.text)));
                          }
                        },
                        child: const Text(
                          "Continue",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// ---------------- LOGIN LINK ----------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?",
                            style: TextStyle(
                                fontSize: 15, color: Colors.black54)),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text(
                            " Login",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.orange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // CUSTOM FIELD WIDGET (RESPONSIVE + CLEAN)
  // =====================================================
  Widget _field(
    String label,
    String hint,
    TextEditingController ctrl, {
    TextInputType type = TextInputType.text,
    int? maxLen,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontFamily: AppFonts.medium,
                fontWeight: FontWeight.w600,
                fontSize: 15)),
        const SizedBox(height: 6),
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: ctrl,
            maxLength: maxLen,
            keyboardType: type,
            decoration: InputDecoration(
              hintText: hint,
              counter: const SizedBox(),
              border: InputBorder.none,
            ),
            onChanged: (_) => hideErr(),
          ),
        ),
      ],
    );
  }
}
