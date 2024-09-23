import 'package:flutter/cupertino.dart';

import 'package:countup/countup.dart';

class AnimatedCounter extends StatelessWidget {
  final double endValue;

  const AnimatedCounter(this.endValue, {super.key});

  @override
  Widget build(BuildContext context) {
    return Countup(
      begin: 0,
      end: endValue,
      duration: const Duration(seconds: 2),
    );
  }
}
