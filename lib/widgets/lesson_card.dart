import 'package:flutter/material.dart';

class LessonCard extends StatelessWidget {
  final int index;
  final String time;
  final String lesson;

  LessonCard({
    required this.index,
    required this.time,
    required this.lesson,
  });

  @override
  Widget build(BuildContext context) {
    final isLessonAssigned = lesson.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: isLessonAssigned
                  ? [Color(0xFF3CC18E), Color(0xFF1C5B43)]
                  : [Colors.white, Colors.grey[200]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: isLessonAssigned
                    ? Colors.white.withOpacity(0.8)
                    : Colors.grey[300],
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isLessonAssigned ? Color(0xFF1C5B43) : Colors.black54,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isLessonAssigned ? lesson : 'Свободно',
                      style: TextStyle(
                        fontSize: 16,
                        color: isLessonAssigned ? Colors.white70 : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      time,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isLessonAssigned ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}