import 'dart:ui'; // Для BackdropFilter (glass effect)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

class StudentDetailPage extends StatefulWidget {
  final Map<String, String> student;

  const StudentDetailPage({Key? key, required this.student}) : super(key: key);

  @override
  State<StudentDetailPage> createState() => _StudentDetailPageState();
}

class _StudentDetailPageState extends State<StudentDetailPage> {
  /// Календарь
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  /// Общее количество занятий (например, 8)
  final int totalLessons = 8;

  /// Дни, когда студент присутствовал (зелёные)
  final Set<DateTime> _presentDays = {
    DateTime(2025, 2, 2),
    DateTime(2025, 2, 4),
    DateTime(2025, 2, 5),
  };

  /// Дни, когда студент отсутствовал (красные)
  final Set<DateTime> _absentDays = {
    DateTime(2025, 2, 6),
    DateTime(2025, 2, 7),
    DateTime(2025, 2, 10),
    DateTime(2025, 2, 12),
  };

  /// Геттер для подсчёта, сколько уроков реально «использовано» (присутствовал)
  int get usedLessons => _presentDays.length;

  /// Геттер для подсчёта, сколько уроков «пропущено»
  int get missedLessons => _absentDays.length;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final String name = widget.student['name'] ?? 'Студент';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Волна сверху
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: WaveClipperTop(),
              child: Container(
                height: 300,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF3CC18E), Color(0xFF1C5B43)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          // Волна снизу
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: WaveClipperBottom(),
              child: Container(
                height: 300,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF3CC18E), Color(0xFF1C5B43)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
              child: Column(
                children: [
                  // Кнопка "Назад"
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // «Плавающая» аватарка
                  Center(
                    child: CircleAvatar(
                      radius: 58,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 54,
                        backgroundColor: const Color(0xFF4A90E2),
                        child: Text(
                          name.isNotEmpty ? name[0] : '',
                          style: GoogleFonts.roboto(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Имя
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  // Тип курса (если есть)
                  if (widget.student['course'] != null && widget.student['course']!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        widget.student['course']!,
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  // Полупрозрачная карточка c информацией
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildInfoTile(
                              icon: Icons.location_city,
                              label: 'Город',
                              value: widget.student['city'],
                            ),
                            const Divider(),
                            _buildInfoTile(
                              icon: Icons.phone,
                              label: 'Телефон',
                              value: widget.student['phone'],
                            ),
                            const Divider(),
                            _buildInfoTile(
                              icon: Icons.cake,
                              label: 'Возраст',
                              value: widget.student['age'],
                            ),
                            const Divider(),
                            _buildInfoTile(
                              icon: Icons.school,
                              label: 'Статус',
                              value: widget.student['status'],
                            ),
                            if (widget.student['course'] != null && widget.student['course']!.isNotEmpty)
                              Column(
                                children: [
                                  const Divider(),
                                  _buildInfoTile(
                                    icon: Icons.menu_book,
                                    label: 'Тип курса',
                                    value: widget.student['course'],
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Заголовок календаря
                  Text(
                    'Календарь посещаемости',
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Календарь - стеклянный, некликабельный
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        color: Colors.white.withOpacity(0.2),
                        padding: const EdgeInsets.all(16),
                        child: IgnorePointer(
                          ignoring: true,
                          child: TableCalendar(
                            focusedDay: _focusedDay,
                            firstDay: DateTime.utc(2022, 1, 1),
                            lastDay: DateTime.utc(2030, 12, 31),
                            headerStyle: const HeaderStyle(
                              formatButtonVisible: false,
                              leftChevronVisible: false,
                              rightChevronVisible: false,
                              titleCentered: true,
                            ),
                            calendarBuilders: CalendarBuilders(
                              defaultBuilder: (context, day, focusedDay) {
                                final dayWithoutTime = DateTime(day.year, day.month, day.day);
                                if (_presentDays.contains(dayWithoutTime)) {
                                  return Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      '${day.day}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                } else if (_absentDays.contains(dayWithoutTime)) {
                                  return Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      '${day.day}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }
                                return null;
                              },
                            ),
                            selectedDayPredicate: (day) =>
                                isSameDay(_selectedDay, day),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // --- ИНДИКАТОР (учитывает присутствие/пропущенные) ---
                  Text(
                    'Осталось уроков: ${totalLessons - (usedLessons + missedLessons)}',
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildLessonsIndicator(totalLessons, usedLessons, missedLessons),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Индикатор:
  ///  - первые [usedLessons] кружочков — зелёные
  ///  - следующие [missedLessons] кружочков — красные
  ///  - остальные — серые
  Widget _buildLessonsIndicator(int total, int used, int missed) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: Colors.white.withOpacity(0.2),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(total, (index) {
              if (index < used) {
                return _buildCircle(Colors.green);
              } else if (index < used + missed) {
                return _buildCircle(Colors.red);
              } else {
                return _buildCircle(Colors.grey);
              }
            }),
          ),
        ),
      ),
    );
  }

  /// Помощник для рисования одного кружочка
  Widget _buildCircle(Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: CircleAvatar(
        radius: 10,
        backgroundColor: color,
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    String? value,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: const Color(0xFF1C5B43),
        size: 28,
      ),
      title: Text(
        label,
        style: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        value ?? '-',
        style: GoogleFonts.roboto(
          fontSize: 16,
          color: Colors.black54,
        ),
      ),
    );
  }
}

// ------------ Классы для волнообразного фона -------------
class WaveClipperTop extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()..lineTo(0, size.height - 50);

    path.quadraticBezierTo(
      size.width * 0.25,
      size.height,
      size.width * 0.5,
      size.height - 30,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height - 60,
      size.width,
      size.height - 10,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class WaveClipperBottom extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()..moveTo(0, 50);

    path.quadraticBezierTo(
      size.width * 0.25,
      0,
      size.width * 0.5,
      30,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      60,
      size.width,
      10,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}