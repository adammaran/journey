import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'bottom_nav_bar/bottom_nav_bar_widget.dart';

enum PageState { loading, success, failed, empty }

// ignore: must_be_immutable
class PageWidget extends StatelessWidget {
  Widget child;
  bool isScrollable;
  bool showBottomNav;

  PageWidget({required this.child, this.isScrollable = true, this.showBottomNav = true, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: showBottomNav ? BottomActionBarWidget() : null,
      body: SingleChildScrollView(
        physics: isScrollable
            ? const AlwaysScrollableScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0), child: child),
            SizedBox(height: 48)
          ],
        ),
      ),
    );
  }
}
