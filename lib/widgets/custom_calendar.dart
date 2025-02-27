import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime, DateTime) onDaySelected;

  const CustomCalendar({
    Key? key,
    required this.selectedDate,
    required this.onDaySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.30,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        gradient: LinearGradient(
          colors: [Color(0xFF3CC18E), Color(0xFF1C5B43)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),
          Text(
            'TAJWEED',
            style: GoogleFonts.dancingScript(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          TableCalendar(
            focusedDay: selectedDate,
            firstDay: DateTime.now().subtract(Duration(days: 7)),
            lastDay: DateTime.now().add(Duration(days: 30)),
            selectedDayPredicate: (day) => isSameDay(selectedDate, day),
            onDaySelected: onDaySelected,
            calendarFormat: CalendarFormat.week,
            headerVisible: false,
            daysOfWeekVisible: true,
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Colors.white),
              weekendStyle: TextStyle(color: Colors.white54),
            ),
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              defaultTextStyle: TextStyle(color: Colors.white),
              weekendTextStyle: TextStyle(color: Colors.white70),
              disabledTextStyle: TextStyle(color: Colors.white38),
              todayTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              selectedTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              selectedDecoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF3CC18E), Color(0xFF1C5B43)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF1C5B43).withOpacity(0.5),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              todayDecoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFD1D1D1), Color(0xFF8C8B8B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF1C5B43).withOpacity(0.5),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
