import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/appbar.dart';
import '../logic/user_repository.dart';
import '../logic/water_repository.dart';
import '../widgets/week_calendar.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late DateTime _selectedDate;
  late DateTime _weekStart;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _weekStart = _getWeekStart(DateTime.now());
  }

  // начало недели (понедельник)
  DateTime _getWeekStart(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  // литры за день
  double _getLitersForDate(DateTime date, WaterRepository waterRepo) {
    final key = date.toIso8601String().substring(0, 10);
    if (key == DateTime.now().toIso8601String().substring(0, 10)) {
      return waterRepo.drankLiters; // сегодня берём из текущего счётчика
    }
    return waterRepo.waterHistory[key] ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width;
    double titleSize = screenW * 0.04;
    final user = context.watch<UserRepository>().currentUser!;
    final waterRepo = context.watch<WaterRepository>();

    return Scaffold(
      appBar: buildMainAppBar(context: context, isHistoryEnabled: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenW * 0.05),
          child: Column(
            children: [
              SizedBox(height: screenW * 0.05),
              // строка с неделей и иконкой календаря
              WeekCalendar(
                selectedDate: _selectedDate,
                weekStart: _weekStart,
                onDaySelected: (day) => setState(() => _selectedDate = day),
                onCalendarTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate.isAfter(DateTime.now()) ? DateTime.now() : _selectedDate,
                    firstDate: DateTime(2025),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                      _weekStart = _getWeekStart(picked);
                    });
                  }
                },
              ),
              SizedBox(height: screenW * 0.08),
              // данные за выбранный день
              Text(
                "${_selectedDate.day}.${_selectedDate.month.toString().padLeft(2, '0')}.${_selectedDate.year}",
                style: TextStyle(fontSize: titleSize, color: Colors.grey),
              ),
              SizedBox(height: screenW * 0.05),
              Text(
                "${_getLitersForDate(_selectedDate, waterRepo).toStringAsFixed(2)} л",
                style: TextStyle(
                  fontSize: screenW * 0.15,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 15, 11, 218),
                ),
              ),
              SizedBox(height: screenW * 0.02),
              Text(
                "из ${user.dailyGoal.toStringAsFixed(2)} л",
                style: TextStyle(fontSize: titleSize, color: Colors.grey),
              ),
              SizedBox(height: screenW * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}