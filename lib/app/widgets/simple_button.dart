import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SimpleButton extends StatelessWidget {
  Function() onPressed;
  String label;

  SimpleButton(this.onPressed, this.label);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: Text(label));
  }
}
