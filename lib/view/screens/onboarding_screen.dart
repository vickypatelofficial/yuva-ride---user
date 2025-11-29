
import 'package:flutter/material.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:yuva_ride/utils/animations.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/view/screens/auth/login_screen.dart';
import 'package:yuva_ride/view/screens/auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _controller = PageController(initialPage: 0);
  int currentIndex = 0;

  late AnimationController _introController;
  late Animation<double> introFade;
  late Animation<Offset> introSlide;
  late Animation<double> introScale;

  late AnimationController _pageAnimController;
  late Animation<double> contentFade;
  late Animation<Offset> contentSlide;
  late Animation<Offset> buttonSlide;

  final List<Map<String, String>> pages = [
    {
      "image": "assets/images/onboarding1.png",
      "title": "Book Now, Ride Anytime",
      "subtitle": "Connect, Share & Ride Together."
    },
    {
      "image": "assets/images/onboarding2.png",
      "title": "Share Your Ride, Save Big",
      "subtitle": "Find riders going your way & split the cost."
    },
    {
      "image": "assets/images/onboarding3.png",
      "title": "Pay Easy, Travel Easy",
      "subtitle": "Smart rides with effortless payments."
    },
  ];

  bool _imagesPrecached = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_imagesPrecached) {
      for (var p in pages) {
        precacheImage(AssetImage(p["image"]!), context);
      }
      _imagesPrecached = true;
    }
  }

  @override
  void initState() {
    super.initState();

    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    introFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _introController, curve: Curves.easeOutQuad),
    );

    introSlide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _introController, curve: Curves.easeOutQuad),
    );

    introScale = Tween<double>(begin: 0.96, end: 1.0).animate(
      CurvedAnimation(parent: _introController, curve: Curves.easeOutBack),
    );

    _pageAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    contentFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _pageAnimController, curve: Curves.easeOut),
    );

    contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _pageAnimController, curve: Curves.easeOut),
    );

    buttonSlide = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _pageAnimController, curve: Curves.easeOut),
    );

    _introController.forward();
    _pageAnimController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _introController.dispose();
    _pageAnimController.dispose();
    super.dispose();
  }

  void _animatePageChange() {
    _pageAnimController.reset();
    _pageAnimController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: introFade,
        child: SlideTransition(
          position: introSlide,
          child: ScaleTransition(
            scale: introScale,
            child: Column(
              children: [
                const SizedBox(height: 50),
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: pages.length,
                    onPageChanged: (index) {
                      setState(() => currentIndex = index);
                      _animatePageChange();
                    },
                    itemBuilder: (_, i) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              double value = 1.0;

                              if (_controller.hasClients &&
                                  _controller.position.haveDimensions) {
                                double pageValue = _controller.page ?? 0.0;
                                value = (1 - ((pageValue - i).abs() * 0.4))
                                    .clamp(0.6, 1.0);
                              }

                              return Transform.scale(
                                scale: value,
                                child: child,
                              );
                            },
                            child: Image.asset(
                              pages[i]["image"]!,
                              height: 300,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 30),
                          FadeTransition(
                            opacity: contentFade,
                            child: SlideTransition(
                              position: contentSlide,
                              child: Column(
                                children: [
                                  Text(
                                    pages[i]["title"]!,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    pages[i]["subtitle"]!,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              pages.length,
                              (index) => indicator(index),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SlideTransition(
                  position: buttonSlide,
                  child: _mainButton(
                    currentIndex == pages.length - 1
                        ? "Start Booking"
                        : "Continue",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _mainButton(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          onPressed: () {
            if (currentIndex < pages.length - 1) {
              _controller.nextPage(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
              );
            } else {
              Navigator.of(context).pushReplacement(
               AppAnimations.slideLeftToRight(const LoginScreen())
              );
            }
          },
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget indicator(int index) {
    bool isActive = index == currentIndex;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: isActive ? 22 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.black : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
