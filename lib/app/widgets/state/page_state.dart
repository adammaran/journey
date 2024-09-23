import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class ErrorState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Error state widget'));
  }
}
