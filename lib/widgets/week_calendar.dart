import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class WeekCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime weekStart;
  final ValueChanged<DateTime> onDaySelected;
  final VoidCallback onCalendarTap;

  const WeekCalendar({
    super.key,
    required this.selectedDate,
    required this.weekStart,
    required this.onDaySelected,
    required this.onCalendarTap,
  });

  List<String> _weekDays(AppLocalizations loc) => [
    loc.weekMon,
    loc.weekTue,
    loc.weekWed,
    loc.weekThu,
    loc.weekFri,
    loc.weekSat,
    loc.weekSun,
  ];

  @override
  Widget build(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width;
    double titleSize = screenW * 0.04;
    final loc = AppLocalizations.of(context)!;
    final weekDays = _weekDays(loc);

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(7, (index) {
              final day = weekStart.add(Duration(days: index));
              final isSelected = day.toIso8601String().substring(0, 10) ==
                  selectedDate.toIso8601String().substring(0, 10);
              final isToday = day.toIso8601String().substring(0, 10) ==
                  DateTime.now().toIso8601String().substring(0, 10);
              return GestureDetector(
                onTap: () => onDaySelected(day),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: screenW * 0.01),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenW * 0.03,
                    vertical: screenW * 0.02,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color.fromARGB(255, 15, 11, 218)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: isToday && !isSelected
                        ? Border.all(color: const Color.fromARGB(255, 15, 11, 218))
                        : null,
                  ),
                  child: Column(
                    children: [
                      Text(
                        weekDays[index],
                        style: TextStyle(
                          fontSize: titleSize * 0.8,
                          color: isSelected ? Colors.white : Colors.grey,
                        ),
                      ),
                      SizedBox(height: screenW * 0.01),
                      Text(
                        "${day.day}",
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        SizedBox(height: screenW * 0.02),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: const Icon(Icons.calendar_month, color: Color.fromARGB(255, 15, 11, 218)),
            iconSize: screenW * 0.07,
            onPressed: onCalendarTap,
          ),
        ),
      ],
    );
  }
}