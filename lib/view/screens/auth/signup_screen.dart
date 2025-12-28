import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yuva_ride/provider/auth_provider.dart';
import 'package:yuva_ride/services/local_storage.dart';
import 'package:yuva_ride/services/status.dart';
import 'package:yuva_ride/utils/animations.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/view/custom_widgets/customTextField.dart';
import 'package:yuva_ride/view/custom_widgets/custom_button.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:yuva_ride/utils/app_fonts.dart';
import 'package:yuva_ride/view/screens/auth/login_screen.dart';
import 'package:yuva_ride/view/screens/home/home_screen.dart';
import 'otp_verification_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key, required this.userId});
  final String userId;
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
  final passwordCtrl = TextEditingController(text: '123456');
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
    passwordCtrl.dispose();
    mobileCtrl.dispose();
    _controller.dispose();
    super.dispose();
  }

  // ------------------ VALIDATION ------------------

  bool showErr(String msg) {
    setState(() {
      errorText = msg;
      showError = true;
    });
    return false;
  }

  final _formKey = GlobalKey<FormState>();

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
              child: SingleChildScrollView(
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
          ),

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
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
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

                        /// 🔹 FIRST NAME ----------------
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "First Name",
                              style: TextStyle(
                                fontFamily: AppFonts.medium,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 6),
                            CustomTextField(
                              hint: "Enter First name",
                              controller: firstCtrl,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "First name is required";
                                }
                                if (value.trim().length < 2) {
                                  return "First name must be at least 2 characters";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        /// 🔹 LAST NAME ----------------
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Last Name",
                              style: TextStyle(
                                fontFamily: AppFonts.medium,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 6),
                            CustomTextField(
                              hint: "Enter Last name",
                              controller: lastCtrl,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Last name is required";
                                }
                                if (value.trim().length < 2) {
                                  return "Last name must be at least 2 characters";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        /// 🔹 EMAIL ----------------
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Email address",
                              style: TextStyle(
                                fontFamily: AppFonts.medium,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 6),
                            CustomTextField(
                              hint: "Enter email address",
                              controller: emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Email is required";
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(value)) {
                                  return "Enter a valid email address";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),

                        // _field("Password", "Enter password", emailCtrl,
                        //     type: TextInputType.visiblePassword),

                        const SizedBox(height: 14),

                        /// ---------------- MOBILE ----------------
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Mobile Number",
                              style: TextStyle(
                                fontFamily: AppFonts.medium,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 6),
                            CustomTextField(
                              hint: "Enter mobile number",
                              controller: mobileCtrl,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Mobile number is required";
                                }
                                if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
                                  return "Enter valid 10 digit number";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),

                        /// ---------------- ERROR TEXT ----------------
                        AnimatedSlide(
                          offset:
                              showError ? Offset.zero : const Offset(0, -0.3),
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
                        Consumer<AuthProvider>(
                          builder: (context, provider, _) {
                            return CustomButton(
                              width: double.infinity,
                              height: 52,
                              text: "Continue",
                              isLoading:
                                  isStatusLoading(provider.signupState.status),
                              onPressed: () async {
                                if (!(_formKey.currentState?.validate() ??
                                    false)) {
                                  return;
                                }
                                await provider.signup(
                                  userId: widget.userId,
                                  ccode: '+91',
                                  name: '${firstCtrl.text} ${lastCtrl.text}',
                                  password: passwordCtrl.text.isEmpty
                                      ? "123456"
                                      : passwordCtrl.text,
                                  phone: mobileCtrl.text,
                                  email: emailCtrl.text,
                                );
                                if (isStatusSuccess(
                                    provider.signupState.status)) {
                                  LocalStorage.saveRequireSignup(false);
                                  Navigator.pushAndRemoveUntil(
                                    // ignore: use_build_context_synchronously
                                    context,
                                    AppAnimations.fade(
                                      const HomeScreen(),
                                      transitionDuration:
                                          const Duration(milliseconds: 2300),
                                    ),
                                    (value) => false,
                                  );
                                  // ignore: use_build_context_synchronously
                                  // Navigator.of(context).push(
                                  //   AppAnimations.slideBottomToTop(
                                  //     OTPVerificationScreen(
                                  //        userId: provider.requestOtpState
                                  //                 .data?['user_id']?.toString() ??
                                  //             "",
                                  //       otp: provider.signupState.data['otp'] ??
                                  //           '',
                                  //       mobile: mobileCtrl.text,
                                  //     ),
                                  //   ),
                                  // );
                                }
                              },
                            );
                          },
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
                              onTap: (){
                                 Navigator.pushAndRemoveUntil(
                                    // ignore: use_build_context_synchronously
                                    context,
                                    AppAnimations.fade(
                                      const LoginScreen(),
                                      transitionDuration:
                                          const Duration(milliseconds: 2300),
                                    ),
                                    (value) => false,
                                  );
                              },
                              
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
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // CUSTOM FIELD WIDGET (RESPONSIVE + CLEAN)
  // =====================================================
}
