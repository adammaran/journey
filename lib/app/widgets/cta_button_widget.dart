import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CTAButton extends StatelessWidget {
  Function() onPressed;
  String label;
  bool isLoading;

  CTAButton(
      {required this.onPressed, required this.label, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: Get.width * 0.4,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: const RoundedRectangleBorder()),
          onPressed: onPressed,
          child: Center(
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Text(label))),
    );
  }
}
