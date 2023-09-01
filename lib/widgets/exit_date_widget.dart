import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../screens/add_emp_screen.dart';

class ExitDateWidget extends StatefulWidget {
  final ValueChanged<String> onDateSelected;
  final VoidCallback onNoDateSelected;

  const ExitDateWidget({
    Key? key,
    required this.onDateSelected,
    required this.onNoDateSelected,
  }) : super(key: key);

  @override
  _ExitDateWidgetState createState() => _ExitDateWidgetState();
}

class _ExitDateWidgetState extends State<ExitDateWidget> {
  String selectedDate = "No date";

  late DateTime currentLocalDate;

  bool todayButtonTapped = false;
  bool noDateButtonTapped = false;

  double calculateOverlayHeight(double tableCalendarHeight) {
    double totalHeight = tableCalendarHeight + 220.0;
    return totalHeight;
  }

  @override
  void initState() {
    super.initState();
    currentLocalDate = DateTime.now().toLocal();
  }

  void _updateSelectedDate(String date) {
    setState(() {
      selectedDate = date;
      todayButtonTapped = false;
      noDateButtonTapped = false;
    });
    widget.onDateSelected(selectedDate);
  }

  void _handleNoDateButton() {
    setState(() {
      noDateButtonTapped = true;
      todayButtonTapped = false;
      selectedDate = "No date";
      _updateSelectedDate(selectedDate);
    });
  }

  void _handleTodayButton() {
    setState(() {
      todayButtonTapped = true;
      noDateButtonTapped = false;
      selectedDate = currentLocalDate.toString().split(" ")[0];
      _updateSelectedDate(selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: calculateOverlayHeight(400.0),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _handleNoDateButton();
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: noDateButtonTapped ? Colors.blue : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: noDateButtonTapped ? Colors.blue : Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        'No Date',
                        style: TextStyle(
                          color:
                              noDateButtonTapped ? Colors.white : Colors.blue,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: _handleTodayButton,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: todayButtonTapped ? Colors.blue : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: todayButtonTapped ? Colors.blue : Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        'Today',
                        style: TextStyle(
                          color: todayButtonTapped ? Colors.white : Colors.blue,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TableCalendar(
            firstDay: currentLocalDate.subtract(const Duration(days: 365)),
            lastDay: currentLocalDate.add(const Duration(days: 365)),
            onDaySelected: (selectedDay, focusedDay) {
              todayButtonTapped = true;
              noDateButtonTapped = true;
              String selectedDateOnCal =
                  selectedDay.toLocal().toString().split(" ")[0];
              _updateSelectedDate(selectedDateOnCal);
            },
            focusedDay: currentLocalDate,
            selectedDayPredicate: (day) {
              if (selectedDate != "No date") {
                return isSameDay(DateTime.parse(selectedDate), day);
              }
              return isSameDay(
                  DateTime.parse(
                      DateTime.now().toLocal().toString().split(" ")[0]),
                  day);
            },
            calendarStyle: CalendarStyle(
              todayTextStyle: const TextStyle(color: Colors.black),
              selectedTextStyle: const TextStyle(color: Colors.white),
              todayDecoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue),
              ),
              selectedDecoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              titleTextStyle:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(
                color: Colors.grey,
                height: 1,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.blue),
                        Text(
                          getFormatedDate(selectedDate),
                          style: TextStyle(
                            fontSize: 12,
                            color: (selectedDate == "No date" ||
                                    selectedDate == "Today")
                                ? Colors.black
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        _handleNoDateButton;
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(240, 255, 255, 1.0),
                        onPrimary: Colors.blue,
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
