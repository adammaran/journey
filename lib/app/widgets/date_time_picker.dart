import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DateTimePicker {
  Future<String> showDateTimePicker() async => await showDatePicker(
          builder: (context, child) => Theme(
              data: ThemeData.dark().copyWith(
                  colorScheme: const ColorScheme.dark(
                      primary: Colors.black, onPrimary: Colors.white)),
              child: child!),
          context: Get.context!,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)))
      .then((dateValue) async => await showTimePicker(
              builder: (context, child) =>
                  Theme(data: ThemeData.dark().copyWith(colorScheme: const ColorScheme.dark(primary: Colors.white, onPrimary: Colors.white, onSecondary: Colors.white)), child: child!),
              context: Get.context!,
              initialTime: TimeOfDay.now())
          .then((timeValue) => '${DateFormat('yyyy/MM/dd').format(dateValue!)} - ${DateFormat('HH:mm').format(DateTime(0, 0, 0, timeValue!.hour, timeValue.minute))}'));
}
