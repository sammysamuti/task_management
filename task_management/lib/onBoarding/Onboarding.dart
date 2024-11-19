import 'dart:async';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management/auth/Login.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding>
    with SingleTickerProviderStateMixin {
  Timer? _autoSlideTimer;
  int _currentIndex = 0;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _checkIfOnboardingCompleted();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  _checkIfOnboardingCompleted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isOnboardingCompleted = prefs.getBool('onboarding_completed');
    if (isOnboardingCompleted ?? false) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }
  }

  _setOnboardingCompleted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Expanded(
            flex: 7,
            child: _buildCarouselContent(),
          ),
          Expanded(
            flex: 3,
            child: SlideTransition(
              position: _offsetAnimation,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        _buildPageIndicator(),
                        const SizedBox(height: 10),
                        Text(
                          _getTitleForIndex(_currentIndex),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _getDescriptionForIndex(_currentIndex),
                          style: const TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                            height: 1.5,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSkipButton(screenWidth),
                        _buildNextOrGetStartedButton(screenWidth),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselContent() {
    return CarouselSlider.builder(
      itemCount: 3,
      itemBuilder: (context, index, realIndex) {
        return Image.asset(
          _getImageForIndex(index),
          fit: BoxFit.contain,
        );
      },
      options: CarouselOptions(
        height: double.infinity,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        enlargeCenterPage: true,
        viewportFraction: 1.0,
        onPageChanged: (index, reason) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          height: 6.0,
          width: _currentIndex == index ? 24.0 : 6.0,
          decoration: BoxDecoration(
            color: _currentIndex == index ? Color.fromARGB(255, 91, 90, 90) : Colors.grey[300],
            borderRadius: BorderRadius.circular(3.0),
          ),
        );
      }),
    );
  }

  Widget _buildSkipButton(double screenWidth) {
    return Flexible(
      flex: 3,
      child: SizedBox(
        width: screenWidth * 0.35,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            _setOnboardingCompleted();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFEEEFF0),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
          ).copyWith(
            side: MaterialStateProperty.all(
              BorderSide(color: Colors.grey[300]!, width: 1),
            ),
          ),
          child: const Text(
            'Skip',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 14,
              height: 20 / 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNextOrGetStartedButton(double screenWidth) {
    final isLastPage = _currentIndex == 2;
    return Flexible(
      flex: 3,
      child: SizedBox(
        width: screenWidth * 0.35,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            if (isLastPage) {
              _setOnboardingCompleted();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              );
            } else {
              setState(() {
                _currentIndex++;
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 91, 90, 90),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
          ),
          child: Text(
            isLastPage ? 'Get Started' : 'Next',
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 14,
              height: 20 / 14,
            ),
          ),
        ),
      ),
    );
  }

  String _getTitleForIndex(int index) {
    switch (index) {
      case 0:
        return 'Manage your tasks';
      case 1:
        return 'Create daily routine';
      case 2:
        return 'Organize your tasks';
      default:
        return '';
    }
  }

  String _getDescriptionForIndex(int index) {
    switch (index) {
      case 0:
        return 'You can easily manage all of your daily tasks for free';
      case 1:
        return 'Create your personalized routine to stay productive';
      case 2:
        return 'Organize your daily tasks by adding them to separate categories';
      default:
        return '';
    }
  }

  String _getImageForIndex(int index) {
    switch (index) {
      case 0:
        return 'Assets/images/board1.png';
      case 1:
        return 'Assets/images/board2.png';
      case 2:
        return 'Assets/images/board3.png';
      default:
        return '';
    }
  }
}
