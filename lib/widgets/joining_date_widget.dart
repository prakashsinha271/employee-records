import 'package:flutter/material.dart';
import 'package:employee_records/screens/add_emp_screen.dart';
import 'package:table_calendar/table_calendar.dart';

class JoiningDateWidget extends StatefulWidget {
  final ValueChanged<String> onDateSelected;

  const JoiningDateWidget({Key? key, required this.onDateSelected})
      : super(key: key);

  @override
  _JoiningDateWidgetState createState() => _JoiningDateWidgetState();
}

class _JoiningDateWidgetState extends State<JoiningDateWidget> {
  String selectedDate = DateTime.now().toLocal().toString().split(" ")[0];

  bool todayButtonTapped = true;
  bool noDateButtonTapped = false;
  bool nextTuesdayButtonTapped = false;
  bool after1WeekButtonTapped = false;
  bool currentDateButtonTapped = false;

  late DateTime currentLocalDate;
  late DateTime tempDate;

  double calculateOverlayHeight(double tableCalendarHeight) {
    // Calculate the total height by considering the height of the TableCalendar and other elements
    double totalHeight =
        tableCalendarHeight + 160.0; // Adjust this value as needed
    return totalHeight;
  }

  @override
  void initState() {
    super.initState();
    currentLocalDate = DateTime.now().toLocal();
    tempDate = currentLocalDate;
  }

  void _updateSelectedDate(String date) {
    setState(() {
      selectedDate = date;
      todayButtonTapped = !todayButtonTapped;
      noDateButtonTapped = !noDateButtonTapped;
      nextTuesdayButtonTapped = !nextTuesdayButtonTapped;
      after1WeekButtonTapped = !after1WeekButtonTapped;
      currentDateButtonTapped = !currentDateButtonTapped;
    });
    widget.onDateSelected(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: calculateOverlayHeight(450.0),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _updateSelectedDate(
                        currentLocalDate.toString().split(" ")[0]);
                    todayButtonTapped = true;
                    noDateButtonTapped = false;
                    nextTuesdayButtonTapped = false;
                    after1WeekButtonTapped = false;
                    currentDateButtonTapped = false;
                  },
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
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    DateTime nextMonday = currentLocalDate;
                    while (nextMonday.weekday != DateTime.monday) {
                      nextMonday = nextMonday.add(const Duration(days: 1));
                    }
                    if (nextMonday.toLocal().toString().split(" ")[0] ==
                        tempDate.toLocal().toString().split(" ")[0]) {
                      nextMonday = nextMonday.add(const Duration(days: 7));
                    }
                    _updateSelectedDate(
                        nextMonday.toLocal().toString().split(" ")[0]);
                    noDateButtonTapped = true;
                    todayButtonTapped = false;
                    nextTuesdayButtonTapped = false;
                    after1WeekButtonTapped = false;
                    currentDateButtonTapped = false;
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            noDateButtonTapped ? Colors.blue : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color:
                          noDateButtonTapped ? Colors.blue : Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        'Next Monday',
                        style: TextStyle(
                            color: noDateButtonTapped
                                ? Colors.white
                                : Colors.blue,
                            fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    DateTime nextTuesday = currentLocalDate;
                    while (nextTuesday.weekday != DateTime.tuesday) {
                      nextTuesday = nextTuesday.add(const Duration(days: 1));
                    }
                    if (nextTuesday.toLocal().toString().split(" ")[0] ==
                        tempDate.toLocal().toString().split(" ")[0]) {
                      nextTuesday = nextTuesday.add(const Duration(days: 7));
                    }
                    _updateSelectedDate(
                        nextTuesday.toLocal().toString().split(" ")[0]);
                    nextTuesdayButtonTapped = true;
                    noDateButtonTapped = false;
                    todayButtonTapped = false;
                    after1WeekButtonTapped = false;
                    currentDateButtonTapped = false;
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            nextTuesdayButtonTapped ? Colors.blue : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color:
                          nextTuesdayButtonTapped ? Colors.blue : Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        'Next Tuesday',
                        style: TextStyle(
                            color: nextTuesdayButtonTapped
                                ? Colors.white
                                : Colors.blue,
                            fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    DateTime next7thDate = currentLocalDate;
                      next7thDate = next7thDate.add(const Duration(days: 7));
                    _updateSelectedDate(
                        next7thDate.toLocal().toString().split(" ")[0]);
                    after1WeekButtonTapped = true;
                    todayButtonTapped = false;
                    nextTuesdayButtonTapped = false;
                    noDateButtonTapped = false;
                    currentDateButtonTapped = false;
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            after1WeekButtonTapped ? Colors.blue : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color:
                          after1WeekButtonTapped ? Colors.blue : Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        'After 1 week',
                        style: TextStyle(
                            color: after1WeekButtonTapped
                                ? Colors.white
                                : Colors.blue,
                            fontSize: 12),
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
              String selectedDateOnCal = selectedDay.toString();
              nextTuesdayButtonTapped = true;
              noDateButtonTapped = true;
              todayButtonTapped = true;
              after1WeekButtonTapped = true;
              currentDateButtonTapped = true;
              _updateSelectedDate(selectedDateOnCal
                  .toString()
                  .split(" ")[0]); // Call your _updateSelectedDate method
            },
            focusedDay: DateTime.parse(selectedDate),
            selectedDayPredicate: (day) {
              // Return true if the day is the selected date
              return isSameDay(DateTime.parse(selectedDate), day);
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
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        _updateSelectedDate(
                            currentLocalDate.toString().split(" ")[0]);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(240, 255, 255, 1.0),
                        onPrimary: Colors.blue, // Text color
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
