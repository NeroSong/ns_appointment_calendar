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
    return widget.disabledDays.contains(DateTime(
      day.year,
      day.month,
      day.day,
    ));
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF6B4EFF).withOpacity(0.15),
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
        color: const Color.fromARGB(255, 248, 247, 255),
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
                      color: theme.colorScheme.primary.withOpacity(0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
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
      color: const Color.fromARGB(255, 248, 247, 255),
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
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                ),
                disabledTextStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.3),
                ),
                selectedDecoration: BoxDecoration(
                  color: primary,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                todayTextStyle: TextStyle(
                  color: theme.colorScheme.secondary,
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
              availableCalendarFormats: const {CalendarFormat.month: '月'},
              daysOfWeekVisible: true,
              locale: 'zh_CN',
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
        color: const Color.fromARGB(255, 248, 247, 255),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                DateFormat('yyyy年MM月dd日').format(_selectedDay),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
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
                            selectedColor: primary,
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
                              selectedColor: primary,
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
                '预约说明',
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
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withOpacity(0.9),
                  height: 1.5,
                ),
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: theme.colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: theme.colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: primary),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                  hintText: '请简要说明会议内容...',
                  hintStyle: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
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
                  child: const Text(
                    '提交预约',
                    style: TextStyle(fontSize: 12),
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
