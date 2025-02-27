import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddLessonModal extends StatefulWidget {
  final List<String> timeSlots;
  final List<String> lessons;
  final Function(int, String) onSave;

  const AddLessonModal({
    required this.timeSlots,
    required this.lessons,
    required this.onSave,
  });

  @override
  _AddLessonModalState createState() => _AddLessonModalState();
}

class _AddLessonModalState extends State<AddLessonModal> {
  int selectedIndex = -1;
  final TextEditingController lessonController = TextEditingController();

  List<String> mockStudents = [
    "Иван Иванов",
    "Петр Петров",
    "Мария Смирнова",
    "Александр Сидоров",
    "Ольга Кузнецова",
    "Дмитрий Орлов",
    "Екатерина Белова"
  ];

  List<String> filteredStudents = [];
  bool isTyping = false; // Флаг, показывать ли список студентов

  @override
  void initState() {
    super.initState();
    lessonController.addListener(() {
      filterStudents(lessonController.text);
    });
  }

  void filterStudents(String query) {
    setState(() {
      if (query.isNotEmpty) {
        isTyping = true; // Начался ввод — показываем список
        filteredStudents = mockStudents
            .where((student) => student.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else {
        isTyping = false; // Если текст очищен, скрываем список
        filteredStudents = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Заголовок
              Text(
                'Добавить урок',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),
          
              // Поле ввода имени студента с поиском
              TextField(
                controller: lessonController,
                decoration: InputDecoration(
                  labelText: 'Имя студента',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF1C5B43), width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
          
              // Список результатов поиска (показывается только если пользователь что-то ввел)
              if (isTyping && filteredStudents.isNotEmpty)
                Container(
                  margin: EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: filteredStudents.map((student) {
                      return ListTile(
                        title: Text(student),
                        onTap: () {
                          lessonController.text = student;
                          setState(() {
                            isTyping = false; // Скрываем список после выбора
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
          
              SizedBox(height: 20),
          
              // Заголовок времени
              Text(
                'Выберите время',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12),
          
              // Сетка выбора времени
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 2.5,
                ),
                itemCount: widget.timeSlots.length,
                itemBuilder: (context, index) {
                  final isTaken = widget.lessons[index].isNotEmpty;
                  return GestureDetector(
                    onTap: isTaken
                        ? null
                        : () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        gradient: isTaken
                            ? null
                            : (selectedIndex == index
                            ? LinearGradient(
                          colors: [Color(0xFF3CC18E), Color(0xFF1C5B43)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                            : null),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isTaken
                              ? Colors.grey
                              : (selectedIndex == index
                              ? Colors.transparent
                              : Colors.grey[400]!),
                        ),
                        boxShadow: selectedIndex == index
                            ? [
                          BoxShadow(
                            color: Color(0xFF1C5B43).withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ]
                            : [],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.timeSlots[index],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isTaken
                              ? Colors.grey[600]
                              : (selectedIndex == index ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
          
              // Кнопка "Добавить"
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () {
                    if (selectedIndex >= 0 && lessonController.text.isNotEmpty) {
                      widget.onSave(selectedIndex, lessonController.text);
                      Navigator.pop(context);
                    } else {
                      Get.snackbar('Ошибка', 'Заполните имя студента и выберите время!');
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF3CC18E), Color(0xFF1C5B43)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        'Добавить',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}