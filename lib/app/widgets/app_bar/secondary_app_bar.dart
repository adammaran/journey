import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SecondaryAppBar extends AppBar {
  String label;
  List<Widget>? icons = [];
  bool showBack;
  Function()? onBack;

  SecondaryAppBar(
      {required this.label, this.icons, this.showBack = false, this.onBack})
      : super(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            elevation: 0,
            actions: icons,
            leading: showBack
                ? IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                    onPressed: onBack ?? () => Get.back(),
                  )
                : null,
            title: Text(label, style: const TextStyle(color: Colors.black)));
}
