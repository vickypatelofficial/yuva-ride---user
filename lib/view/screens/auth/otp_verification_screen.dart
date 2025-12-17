import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yuva_ride/controller/auth_provider.dart';
import 'package:yuva_ride/services/local_storage.dart';
import 'package:yuva_ride/services/status.dart';
import 'package:yuva_ride/view/custom_widgets/cusotm_back.dart';
import 'package:yuva_ride/view/custom_widgets/custom_button.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:pinput/pinput.dart';
import 'package:yuva_ride/utils/animations.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/view/screens/auth/signup_screen.dart';
import 'package:yuva_ride/view/screens/home/home_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String mobile;
  final String otp;
  final String userId;
  final bool isUserExist;

  const OTPVerificationScreen(
      {super.key,
      required this.mobile,
      required this.otp,
      required this.userId,
      required this.isUserExist});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen>
    with TickerProviderStateMixin {
  final pinController = TextEditingController();
  final focusNode = FocusNode();

  late AnimationController fadeController;
  late Animation<double> fadeAnim;

  int countdown = 30;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    pinController.text = widget.otp;

    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    fadeAnim = CurvedAnimation(
      parent: fadeController,
      curve: Curves.easeOut,
    );

    fadeController.forward();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    fadeController.dispose();
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (countdown > 0) {
        setState(() => countdown--);
      } else {
        timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 55,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.primaryColor, width: 2),
      borderRadius: BorderRadius.circular(12),
    );

    final submittedPinTheme = defaultPinTheme.copyDecorationWith(
      color: AppColors.primaryColor.withOpacity(.2),
      borderRadius: BorderRadius.circular(12),
    );

    return CustomScaffold(
      backgroundColor: Colors.white,

      /// TOP BAR
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: const Text("OTP Verification",
            style: TextStyle(color: Colors.white)),
        leading: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: CustomBack(),
        ),
        leadingWidth: 50,
      ),

      body: FadeTransition(
        opacity: fadeAnim,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            children: [
              const SizedBox(height: 30),

              Text(
                "We’ve sent a verification code to",
                style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 6),

              Text(
                "+91 ${widget.mobile}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 40),

              Pinput(
                controller: pinController,
                focusNode: focusNode,
                length: 6,
                // androidSmsAutofillMethod:
                //     AndroidSmsAutofillMethod.smsRetrieverApi,
                // listenForMultipleSmsOnAndroid: true,

                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,

                useNativeKeyboard: true,
                animationDuration: const Duration(milliseconds: 250),

                onCompleted: (pin) {
                  print("OTP ENTERED: $pin");
                },
              ),

              const SizedBox(height: 20),

              countdown > 0
                  ? RichText(
                      text: TextSpan(
                        text: "Resend OTP in ",
                        style: TextStyle(
                            color: Colors.grey.shade800, fontSize: 15),
                        children: [
                          TextSpan(
                            text: countdown.toString(),
                            style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          countdown = 30;
                        });
                        startTimer();
                        pinController.clear();
                        focusNode.requestFocus();
                      },
                      child: const Text(
                        "Resend OTP",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),

              const Spacer(),

              /// VERIFY BUTTON
              Consumer<AuthProvider>(builder: (context, provider, _) {
                return SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: CustomButton(
                    isLoading: isStatusLoading(provider.verifyOtpState.status),
                    onPressed: () async {
                      print(pinController.text.length);
                      if (pinController.text.length != 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter a valid OTP"),
                          ),
                        );
                        return;
                      }
                      await provider.verifyOtp(
                        otp: pinController.text,
                        userId: widget.userId,
                        ccode: '+91',
                        phone: widget.mobile,
                      );
                      if (isStatusSuccess(provider.verifyOtpState.status)) {
                        print('data gettind');
                        print(provider.verifyOtpState.data.toString());
                        String? userId;
                        if (provider.verifyOtpState.data['user_id'] != null) {
                          userId = provider.verifyOtpState.data['user_id'];
                        } else {
                          userId = provider
                                  .verifyOtpState.data['customer_data']?['id']
                                  ?.toString() ??
                              '';
                        }

                        LocalStorage.saveUserId(userId!);
                        LocalStorage.saveRequireSignup(
                            provider.verifyOtpState.data['requires_signup'] ??
                                true);
                        // return;
                        if (!(provider.verifyOtpState.data['requires_signup'] ??
                            true)) {
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
                        } else {
                          Navigator.pushAndRemoveUntil(
                            // ignore: use_build_context_synchronously
                            context,
                            AppAnimations.fade(
                              SignupScreen(
                                userId: widget.userId,
                              ),
                              transitionDuration:
                                  const Duration(milliseconds: 2300),
                            ),
                            (value) => false,
                          );
                        }

                        // ignore: use_build_context_synchronously
                      }
                    },
                    text: 'Verify OTP',
                  ),
                );
              }),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
