import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yuva_ride/view/custom_widgets/cusotm_back.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:pinput/pinput.dart';
import 'package:yuva_ride/utils/animations.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/view/screens/home/home_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String mobile;

  const OTPVerificationScreen({super.key, required this.mobile});

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
        ), leadingWidth: 50,
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
                length: 4,
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
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pinController.text.length == 4
                        ? AppColors.primaryColor
                        : Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (pinController.text.length != 4) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter a valid OTP"),
                        ),
                      );
                      return;
                    } else {
                      Future.microtask((){
                        Navigator.pushAndRemoveUntil(
                            // ignore: use_build_context_synchronously
                            context,
                            AppAnimations.fade(const HomeScreen(),
                                transitionDuration:
                                    const Duration(milliseconds: 2300)),
                            (value) => false);
                      });
                    }
                    print("Verify OTP: ${pinController.text}");
                  },
                  child: const Text(
                    "Verify OTP",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
