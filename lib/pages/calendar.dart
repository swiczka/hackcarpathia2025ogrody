import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  final TextEditingController _eventController = TextEditingController();

  Map<DateTime, List<String>> _events = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();

    // 🥒 Dodajemy przypomnienie "podlej ogórki" na 17 kwietnia
    final year = DateTime.now().year;
    final reminderDate1 = DateTime(year, 4, 17);
    final reminderDate2 = DateTime(year, 4, 02);
    final reminderDate6 = DateTime(year, 4, 25);
    final reminderDate3 = DateTime(year, 4, 07);
    final reminderDate4 = DateTime(year, 4, 12);
    final reminderDate5 = DateTime(year, 4, 29);
    _events[reminderDate1] = ['Podlej ogórki'];
    _events[reminderDate2] = ['Daj nawóz do sadzonek cukinii'];
    _events[reminderDate6] = ['Kup nasiona rzodkiewki'];
    _events[reminderDate3] = ['Sprawdź donice'];
    _events[reminderDate4] = ['Zamów nawóz'];
    _events[reminderDate5] = ['Przekop grządkę'];
  }

  List<String> _getEventsForDay(DateTime day) {
    final date = DateTime(day.year, day.month, day.day);
    return _events[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: _getEventsForDay,
            calendarStyle: CalendarStyle(
              markerDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _eventController,
              decoration: InputDecoration(
                labelText: 'Dodaj przypomnienie',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    final text = _eventController.text;
                    if (text.isEmpty) return;

                    setState(() {
                      final date = DateTime(
                          _selectedDay.year, _selectedDay.month, _selectedDay.day);
                      if (_events[date] != null) {
                        _events[date]!.add(text);
                      } else {
                        _events[date] = [text];
                      }
                      _eventController.clear();
                    });
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ListView(
              children: _getEventsForDay(_selectedDay)
                  .map((event) => ListTile(
                leading: Icon(Icons.check_circle_outline, size: 18, color: Colors.green),
                title: Text(
                  event,
                  style: TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
