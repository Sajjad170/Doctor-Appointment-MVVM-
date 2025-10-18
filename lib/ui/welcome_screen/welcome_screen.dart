
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth/login.dart';
import 'components/dot_indicator.dart';
import 'components/onboarding_buttons.dart';
import 'components/onboarding_content.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'imageUrl': 'assets/images/doctor_1.png',
      'description':
      'Welcome to our Doctor Booking App! Get ready to take control of your healthcare journey',
    },
    {
      'imageUrl': 'assets/images/doctor_2.png',
      'description':
      'Easily find and book appointments with trusted doctors in just a few taps. Say goodbye to long waiting times and hello to hassle-free appointments.',
    },
    {
      'imageUrl': 'assets/images/doctor_3.png',
      'description':
      'Start your journey to better health by finding and booking appointments with top doctors in your area',
    },
  ];

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingContent(
                    imageUrl: _onboardingData[index]['imageUrl']!,
                    description: _onboardingData[index]['description']!,
                  );
                },
              ),
            ),
            DotIndicator(
              currentIndex: _currentPage,
              dotCount: _onboardingData.length,
            ),
            const SizedBox(height: 32),
            OnboardingButtons(
              onDoctorPressed: () {
                Get.to(() => LoginPage(role: 'Doctor'), binding: LoginBinding());
              },
              onPatientPressed: _currentPage < _onboardingData.length - 1
                  ? _nextPage
                  : () {
                Get.to(() => LoginPage(role: 'Patient'), binding: LoginBinding());
              },
            ),
          ],
        ),
      ),
    );
  }
}