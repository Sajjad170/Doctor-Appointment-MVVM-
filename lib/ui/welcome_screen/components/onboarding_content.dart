import 'package:flutter/material.dart';

class OnboardingContent extends StatelessWidget {
  final String imageUrl;
  final String description;

  const OnboardingContent({
    Key? key,
    required this.imageUrl,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imageUrl,
          width: 240,
          height: 320,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.black,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}