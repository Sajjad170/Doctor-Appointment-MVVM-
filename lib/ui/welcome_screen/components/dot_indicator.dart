import 'package:flutter/material.dart';

import '../colors/colors.dart';

class DotIndicator extends StatelessWidget {
  final int currentIndex;
  final int dotCount;

  const DotIndicator({
    Key? key,
    required this.currentIndex,
    required this.dotCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(dotCount, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: index == currentIndex ? AppColors.greenDark : AppColors.greyDot,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}