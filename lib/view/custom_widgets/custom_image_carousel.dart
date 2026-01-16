import 'dart:async';
import 'package:flutter/material.dart';
import 'package:yuva_ride/main.dart';

class CustomImageCarousel extends StatefulWidget {
  final List<String> images;
  final double height;
  final Duration slideDuration;

  const CustomImageCarousel({
    super.key,
    required this.images,
    this.height = 180,
    this.slideDuration = const Duration(seconds: 2),
  });

  @override
  State<CustomImageCarousel> createState() => _CustomImageCarouselState();
}

class _CustomImageCarouselState extends State<CustomImageCarousel>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _progressController;

  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
    _progressController =
        AnimationController(vsync: this, duration: widget.slideDuration);

    _startAutoSlide();
  }

  void _startAutoSlide() {
    _progressController.forward(from: 0);

    _timer = Timer.periodic(widget.slideDuration, (_) {
      if (_currentIndex < widget.images.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }

      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );

      _progressController.forward(from: 0);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) {
              _currentIndex = index;
              _progressController.forward(from: 0);
              setState(() {});
            },
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  widget.images[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              );
            },
          ),

          // Progress Indicators (Top overlay)
          Positioned(
            bottom: 8,
            left: screenWidth*.3,
            right:  screenWidth*.3, 
            child: SizedBox( 
              child: Row(
                children: List.generate(widget.images.length, (index) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: index == _currentIndex
                            ? AnimatedBuilder(
                                animation: _progressController,
                                builder: (context, _) {
                                  return FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: _progressController.value,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : index < _currentIndex
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  )
                                : const SizedBox()
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
