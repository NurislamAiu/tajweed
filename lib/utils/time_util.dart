import 'package:flutter/material.dart';

List<String> generateTimeSlots() {
  final List<String> timeSlots = [];
  TimeOfDay startTime = TimeOfDay(hour: 9, minute: 0);

  for (int i = 0; i < 18; i++) {
    final endTime = TimeOfDay(
      hour: (startTime.hour + (startTime.minute + 45) ~/ 60) % 24,
      minute: (startTime.minute + 45) % 60,
    );

    timeSlots.add(
        '${startTime.formatAsString()} - ${endTime.formatAsString()}');
    startTime = endTime;
  }

  return timeSlots;
}

extension TimeOfDayExtension on TimeOfDay {
  String formatAsString() {
    final String hourStr = hour.toString().padLeft(2, '0');
    final String minuteStr = minute.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr';
  }
}