import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/time_util.dart';
import '../widgets/custom_calendar.dart';
import '../widgets/lesson_card.dart';
import '../widgets/add_lesson_modal.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final Map<DateTime, List<String>> schedule = {};
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    schedule[selectedDate] = List.generate(18, (_) => '');
  }

  void _showAddLessonModal(BuildContext context) {
    final timeSlots = generateTimeSlots();

    if (!schedule.containsKey(selectedDate)) {
      schedule[selectedDate] = List.generate(18, (_) => '');
    }

    if (selectedDate.isBefore(DateTime.now().subtract(Duration(days: 1)))) {
      Get.snackbar('Ошибка', 'Нельзя добавлять уроки на прошедшие дни.');
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          width: double.infinity,
          height: MediaQuery.sizeOf(context).height * 0.7,
          child: AddLessonModal(
            timeSlots: timeSlots,
            lessons: schedule[selectedDate]!,
            onSave: (index, lesson) {
              setState(() {
                schedule[selectedDate]![index] = lesson;
              });
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildScheduleDay(),
            ),
          ),
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: () => _showAddLessonModal(context),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Color(0xFF3CC18E), Color(0xFF1C5B43)],

              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
  );
  }



  Widget _buildHeader() {
    return CustomCalendar(
      selectedDate: selectedDate,
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          selectedDate = selectedDay;
        });
      },
    );
  }

  Widget _buildScheduleDay() {
    final timeSlots = generateTimeSlots();
    final lessons = schedule[selectedDate] ?? List.generate(18, (_) => '');

    return ListView.builder(
      itemCount: timeSlots.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return LessonCard(
          index: index,
          time: timeSlots[index],
          lesson: lessons[index],
        );
      },
    );
  }
}