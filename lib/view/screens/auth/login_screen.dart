import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yuva_ride/controller/auth_provider.dart';
import 'package:yuva_ride/services/local_storage.dart';
import 'package:yuva_ride/services/status.dart';
import 'package:yuva_ride/utils/globle_func.dart';
import 'package:yuva_ride/view/custom_widgets/custom_button.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:yuva_ride/utils/animations.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/view/screens/auth/otp_verification_screen.dart';
import 'package:yuva_ride/view/screens/auth/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<Offset> topSlide;
  late Animation<Offset> sheetSlide;

  final TextEditingController mobileController = TextEditingController();
  String? errorText; // error message
  bool showError = false; // for animation

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
    _controller.dispose();
    mobileController.dispose();
    super.dispose();
  }

  /// ---------------- SMART VALIDATION FUNCTION ----------------
  bool validateMobile() {
    String mobile = mobileController.text.trim();

    if (mobile.isEmpty) {
      return showErrorAnimated("Mobile number is required");
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(mobile)) {
      return showErrorAnimated("Only digits allowed");
    }

    if (mobile.length != 10) {
      return showErrorAnimated("Mobile number must be 10 digits");
    }

    if (!RegExp(r'^[6-9]').hasMatch(mobile)) {
      return showErrorAnimated("Enter a valid Indian mobile number");
    }

    hideErrorAnimated();
    return true;
  }

  /// ANIMATED ERROR SHOW
  bool showErrorAnimated(String msg) {
    setState(() {
      errorText = msg;
      showError = true;
    });
    return false;
  }

  /// ANIMATED ERROR HIDE
  void hideErrorAnimated() {
    setState(() {
      showError = false;
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!showError) {
        setState(() => errorText = null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AuthProvider>();
    // ignore: deprecated_member_use
    return CustomScaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          /// ------------------- TOP CONTENT -------------------
          SafeArea(
            child: SlideTransition(
              position: topSlide,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    "Book Rides, Share\nRides – All In One App",
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
                    "Easy, Affordable, And Eco-\nFriendly Travel.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Image.asset(
                    "assets/images/vehicles.png",
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ),

          /// ------------------- BOTTOM SHEET -------------------
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: sheetSlide,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 25),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Login with Mobile Number",
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    /// ------------------ MOBILE FIELD ------------------
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade100,
                        border: Border.all(
                          width: 1.4,
                          color: showError ? Colors.red : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            "+91",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 1.3,
                            height: 22,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: mobileController,
                              maxLength: 10,
                              keyboardType: TextInputType.phone,
                              onChanged: (value) {
                                hideErrorAnimated();
                              },
                              decoration: const InputDecoration(
                                hintText: "Enter Mobile number",
                                contentPadding: EdgeInsets.only(top: 6),
                                disabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                border: InputBorder.none,
                                counter: SizedBox(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// ANIMATED ERROR TEXT
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
                                child: Align(
                                  alignment: Alignment.centerLeft,
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
                    ),

                    const SizedBox(height: 18),

                    /// ------------------ CONTINUE BUTTON ------------------
                    Consumer<AuthProvider>(builder: (context, provider, _) {
                      return SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: CustomButton(
                            isLoading: isStatusLoading(
                                    provider.requestOtpState.status) ||
                                isStatusLoading(
                                    provider.mobileCheckState.status),
                            onPressed: () async {
                              if (validateMobile()) {
                                await provider.requestOtp(
                                    phone: mobileController.text, ccode: '+91');
                                if (isStatusSuccess(
                                    provider.requestOtpState.status)) {
                                  Navigator.of(context).push(
                                      AppAnimations.slideBottomToTop(
                                          OTPVerificationScreen(
                                    isUserExist: provider.requestOtpState
                                            .data?['is_existing_user'] ??
                                        false,
                                    userId: provider
                                            .requestOtpState.data?['user_id']
                                            ?.toString() ??
                                        "",
                                    otp:
                                        provider.requestOtpState.data?['otp'] ??
                                            "",
                                    mobile: mobileController.text,
                                  )));
                                }
                              }
                            },
                            text: 'Continue'),
                      );
                    }),

                    const SizedBox(height: 16),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     const Text(
                    //       "Don’t have an account?",
                    //       style: TextStyle(fontSize: 15, color: Colors.black54),
                    //     ),
                    //     GestureDetector(
                    //       onTap: () {
                    //         Navigator.push(
                    //             context,
                    //             AppAnimations.slideTopToBottom(
                    //                 const SignupScreen()));
                    //       },
                    //       child: const Text(
                    //         " Sign up",
                    //         style: TextStyle(
                    //           fontSize: 15,
                    //           color: Colors.orange,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
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
}
