import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class AppointmentCalendar extends StatefulWidget {
  final String name;
  final String title;
  final ImageProvider avatarImg;
  final String description;
  final Set<DateTime> disabledDays;
  final List<String> timeSlots;
  final Function(DateTime date, int timeSlot, String note) onSubmit;

  const AppointmentCalendar({
    super.key,
    required this.name,
    required this.title,
    required this.avatarImg,
    required this.description,
    required this.disabledDays,
    required this.timeSlots,
    required this.onSubmit,
  });

  @override
  State<AppointmentCalendar> createState() => _AppointmentCalendarState();
}

class _AppointmentCalendarState extends State<AppointmentCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  int _selectedTimeSlot = 0;
  final _noteController = TextEditingController();
  bool isMobile = false;

  bool _isDisabled(DateTime day) {
    // 检查是否是周末
    final isWeekend =
        day.weekday == DateTime.saturday || day.weekday == DateTime.sunday;

    // 检查是否在禁用日期列表中
    final isDisabledDate = widget.disabledDays.contains(DateTime(
      day.year,
      day.month,
      day.day,
    ));

    return isWeekend || isDisabledDate;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onPrimary = theme.colorScheme.onPrimary;
    final screenWidth = MediaQuery.of(context).size.width;
    isMobile = screenWidth < 800;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 820),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.outline,
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: isMobile
                  ? Column(
                      children: [
                        _buildProfileCard(theme),
                        const SizedBox(height: 16),
                        _buildCalendarCard(theme, primary),
                        const SizedBox(height: 16),
                        _buildAppointmentCard(
                            theme, primary, onPrimary, context),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProfileCard(theme),
                        const SizedBox(width: 16),
                        Expanded(child: _buildCalendarCard(theme, primary)),
                        const SizedBox(width: 16),
                        _buildAppointmentCard(
                            theme, primary, onPrimary, context),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard(ThemeData theme) {
    return SizedBox(
      width: isMobile ? double.infinity : 200,
      child: Card(
        color: theme.colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.outline,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 32,
                  backgroundImage: widget.avatarImg,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                widget.description,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarCard(ThemeData theme, Color primary) {
    return Card(
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              enabledDayPredicate: (day) => !_isDisabled(day),
              calendarFormat: CalendarFormat.month,
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                  fontSize: 13,
                ),
                weekendStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                  fontSize: 13,
                ),
              ),
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
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
                disabledTextStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.3),
                ),
                selectedTextStyle: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
                selectedDecoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colorScheme.primary,
                    width: 1,
                  ),
                  shape: BoxShape.circle,
                ),
                todayTextStyle: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                cellMargin: const EdgeInsets.all(2),
                tablePadding: const EdgeInsets.symmetric(horizontal: 4),
                tableBorder: TableBorder.all(
                  color: Colors.transparent,
                  width: 0,
                ),
              ),
              daysOfWeekHeight: 32,
              rowHeight: 42,
              daysOfWeekVisible: true,
              locale: Localizations.localeOf(context).languageCode,
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
    );
  }

  Widget _buildAppointmentCard(
      ThemeData theme, Color primary, Color onPrimary, BuildContext context) {
    return SizedBox(
      width: isMobile ? double.infinity : 220,
      child: Card(
        color: theme.colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat.yMMMMd(
                            Localizations.localeOf(context).languageCode)
                        .format(_selectedDay),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                runSpacing: 8,
                alignment: WrapAlignment.start,
                children: List.generate(
                  (widget.timeSlots.length / 2).ceil(),
                  (index) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: Text(
                              widget.timeSlots[index * 2],
                              style: TextStyle(
                                fontSize: 11,
                                color: _selectedTimeSlot == index * 2
                                    ? onPrimary
                                    : theme.colorScheme.onSurface,
                              ),
                            ),
                            selected: _selectedTimeSlot == index * 2,
                            selectedColor: theme.colorScheme.primary,
                            backgroundColor: theme.colorScheme.surface,
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
                            side: BorderSide(
                              color: theme.colorScheme.outline,
                              width: 1,
                            ),
                          ),
                        ),
                        if (index * 2 + 1 < widget.timeSlots.length) ...[
                          Expanded(
                            child: ChoiceChip(
                              label: Text(
                                widget.timeSlots[index * 2 + 1],
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _selectedTimeSlot == index * 2 + 1
                                      ? onPrimary
                                      : theme.colorScheme.onSurface,
                                ),
                              ),
                              selected: _selectedTimeSlot == index * 2 + 1,
                              selectedColor: theme.colorScheme.primary,
                              backgroundColor: theme.colorScheme.surface,
                              showCheckmark: false,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              labelPadding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _selectedTimeSlot = index * 2 + 1;
                                  });
                                }
                              },
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              side: BorderSide(
                                color: theme.colorScheme.outline,
                                width: 1,
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                Localizations.localeOf(context).languageCode == 'zh'
                    ? '预约说明'
                    : 'Appointment Note',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _noteController,
                maxLines: 3,
                style: const TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  hintText: Localizations.localeOf(context).languageCode == 'zh'
                      ? '请简要说明会议内容...'
                      : 'Please briefly describe the meeting content...',
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: theme.colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: theme.colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onSubmit(
                      _selectedDay,
                      _selectedTimeSlot,
                      _noteController.text,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: primary,
                    foregroundColor: onPrimary,
                    disabledBackgroundColor:
                        theme.colorScheme.onSurface.withOpacity(0.12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    Localizations.localeOf(context).languageCode == 'zh'
                        ? '提交预约'
                        : 'Submit',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }
}
