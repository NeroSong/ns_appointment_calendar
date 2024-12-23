import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class AppointmentCalendar extends StatefulWidget {
  const AppointmentCalendar({super.key});

  @override
  State<AppointmentCalendar> createState() => _AppointmentCalendarState();
}

class _AppointmentCalendarState extends State<AppointmentCalendar> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  int _selectedTimeSlot = 0;
  final TextEditingController _noteController = TextEditingController();

  final Set<DateTime> _disabledDays = {
    DateTime(2024, 12, 25),
    DateTime(2025, 1, 1),
  };

  final List<String> _availableTimeSlots = [
    '10:00 - 11:00',
    '11:00 - 12:00',
    '14:00 - 15:00',
    '15:00 - 16:00',
  ];

  bool _isWeekend(DateTime day) {
    return day.weekday == DateTime.saturday || day.weekday == DateTime.sunday;
  }

  bool _isDisabled(DateTime day) {
    return _isWeekend(day) ||
        _disabledDays.contains(DateTime(day.year, day.month, day.day));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onPrimary = theme.colorScheme.onPrimary;
    final surface = theme.colorScheme.surface;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_month_rounded,
                size: 28,
                color: primary,
              ),
              const SizedBox(width: 12),
              const Text(
                '预约在线会议',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 800,
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200,
                    child: Card(
                      color: surface,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: primary.withOpacity(0.2),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const CircleAvatar(
                                radius: 32,
                                backgroundImage:
                                    NetworkImage('https://picsum.photos/200'),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Sarah Johnson',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Senior Product Manager',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '10年产品经验，专注于AI与数据产品。擅长产品战略规划与团队管理，热衷于创新科技应用。',
                              style: TextStyle(
                                fontSize: 11,
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.8),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    color: theme.colorScheme.outline.withOpacity(0.2),
                  ),
                  Expanded(
                    child: Card(
                      color: surface,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TableCalendar(
                              firstDay: DateTime.now(),
                              lastDay:
                                  DateTime.now().add(const Duration(days: 365)),
                              focusedDay: _focusedDay,
                              selectedDayPredicate: (day) =>
                                  isSameDay(_selectedDay, day),
                              enabledDayPredicate: (day) => !_isDisabled(day),
                              calendarFormat: CalendarFormat.month,
                              headerStyle: HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true,
                                titleTextStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              calendarStyle: CalendarStyle(
                                outsideDaysVisible: false,
                                weekendTextStyle: TextStyle(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.4),
                                ),
                                disabledTextStyle: TextStyle(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.3),
                                ),
                                selectedDecoration: BoxDecoration(
                                  color: primary,
                                  shape: BoxShape.circle,
                                ),
                                todayDecoration: BoxDecoration(
                                  color: theme.colorScheme.secondary
                                      .withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                todayTextStyle: TextStyle(
                                  color: theme.colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                                cellMargin: const EdgeInsets.all(4),
                              ),
                              onDaySelected: (selectedDay, focusedDay) {
                                setState(() {
                                  _selectedDay = selectedDay;
                                  _focusedDay = focusedDay;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    color: theme.colorScheme.outline.withOpacity(0.2),
                  ),
                  SizedBox(
                    width: 220,
                    child: Card(
                      color: surface,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('yyyy年MM月dd日').format(_selectedDay),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '可选时间段',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              runSpacing: 8,
                              alignment: WrapAlignment.start,
                              children: List.generate(
                                (_availableTimeSlots.length / 2).ceil(),
                                (index) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        child: ChoiceChip(
                                          label: Text(
                                            _availableTimeSlots[index * 2],
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: _selectedTimeSlot ==
                                                      index * 2
                                                  ? onPrimary
                                                  : theme.colorScheme.onSurface,
                                            ),
                                          ),
                                          selected:
                                              _selectedTimeSlot == index * 2,
                                          selectedColor: primary,
                                          backgroundColor:
                                              theme.colorScheme.surface,
                                          showCheckmark: false,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          labelPadding: EdgeInsets.zero,
                                          visualDensity: VisualDensity.compact,
                                          onSelected: (selected) {
                                            if (selected) {
                                              setState(() {
                                                _selectedTimeSlot = index * 2;
                                              });
                                            }
                                          },
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                        ),
                                      ),
                                      if (index * 2 + 1 <
                                          _availableTimeSlots.length) ...[
                                        Expanded(
                                          child: ChoiceChip(
                                            label: Text(
                                              _availableTimeSlots[
                                                  index * 2 + 1],
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: _selectedTimeSlot ==
                                                        index * 2 + 1
                                                    ? onPrimary
                                                    : theme
                                                        .colorScheme.onSurface,
                                              ),
                                            ),
                                            selected: _selectedTimeSlot ==
                                                index * 2 + 1,
                                            selectedColor: primary,
                                            backgroundColor:
                                                theme.colorScheme.surface,
                                            showCheckmark: false,
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            labelPadding: EdgeInsets.zero,
                                            visualDensity:
                                                VisualDensity.compact,
                                            onSelected: (selected) {
                                              if (selected) {
                                                setState(() {
                                                  _selectedTimeSlot =
                                                      index * 2 + 1;
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ],
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '预约说明',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _noteController,
                              maxLines: 3,
                              style: TextStyle(
                                fontSize: 11,
                                color: theme.colorScheme.onSurface,
                              ),
                              decoration: InputDecoration(
                                labelText: '预约说明',
                                labelStyle: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                ),
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.all(12),
                                hintText: '请简要说明预约目的...',
                                hintStyle: TextStyle(
                                  fontSize: 11,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.4),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: primary),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text('预约已提交！'),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: primary,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  backgroundColor: primary,
                                  foregroundColor: onPrimary,
                                  disabledBackgroundColor: theme
                                      .colorScheme.onSurface
                                      .withOpacity(0.12),
                                ),
                                child: const Text(
                                  '提交预约',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
