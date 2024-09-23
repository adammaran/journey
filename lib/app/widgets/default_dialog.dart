import 'package:fishing_helper/app/widgets/cta_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DefaultDialog extends Dialog {
  final String title;
  final String? description;
  final String? onConfirmText;
  final Widget? body;
  final bool showCancelBtn;
  final Function()? onConfirm;
  final VoidCallback? onCancel;
  final bool showConfirmButton;
  final bool showBackButton;
  final bool showSeparator;
  final bool showTitleIcon;
  final Color? cancelButtonBackgroundColor;
  final EdgeInsets? padding;

  Rx<bool>? isLoading = false.obs;

  DefaultDialog.show(
      {super.key,
      required this.title,
      this.description,
      this.onConfirmText,
      this.body,
      this.showCancelBtn = true,
      this.onConfirm,
      this.onCancel,
      this.isLoading,
      this.showConfirmButton = true,
      this.showBackButton = false,
      this.showSeparator = false,
      this.showTitleIcon = false,
      this.cancelButtonBackgroundColor,
      this.padding}) {
    showDialog(
      barrierDismissible: false,
      context: Get.context!,
      builder: (BuildContext context) => Center(
        child: SingleChildScrollView(
          child: Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: padding,
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Stack(alignment: Alignment.center, children: [
                            if (showBackButton)
                              Align(
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.black,
                                  ),
                                  onPressed: () => Get.back(),
                                ),
                              ),
                            Align(
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(top: 0),
                                          child: Text(title)),
                                    ])),
                          ]),
                        ),
                        body ??
                            Column(children: [
                              if (showSeparator)
                                const Divider(
                                  height: 0,
                                ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 20),
                                  child: Text(
                                    description ?? '',
                                    style: Get.theme.textTheme.titleSmall,
                                  ))
                            ]),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (showCancelBtn)
                            Expanded(
                              child: ElevatedButton(
                                onPressed: onCancel ??
                                    () {
                                      Get.back();
                                    },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  side: const BorderSide(color: Colors.grey),
                                  // backgroundColor: cancelButtonBackgroundColor,
                                ),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          if (showCancelBtn) const SizedBox(width: 12),
                          if (showConfirmButton)
                            Expanded(
                              child: CTAButton(
                                onPressed: onConfirm ??
                                    () {
                                      Get.back();
                                    },
                                label: onConfirmText ?? 'Confirm',
                              ),
                            ),
                        ],
                      ),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
