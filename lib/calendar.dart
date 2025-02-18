import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

/// A customizable appointment calendar widget that allows users to select dates,
/// time slots, and add notes for appointments.
///
/// This widget provides a clean and modern interface for scheduling appointments,
/// with support for:
/// * Date selection with a calendar view
/// * Customizable time slots
/// * Disabled dates (weekends and specific dates)
/// * Appointment notes
/// * Responsive layout
///
/// Example:
/// ```dart
/// AppointmentCalendar(
///   name: 'John Doe',
///   title: 'Software Engineer',
///   avatarImg: NetworkImage('https://example.com/avatar.jpg'),
///   description: 'Full-stack developer with 5 years of experience',
///   disabledDays: {DateTime(2024, 12, 25)},
///   timeSlots: const ['09:00 - 10:00', '10:00 - 11:00'],
///   onSubmit: (date, slot, note) {
///     print('Appointment scheduled for $date at slot $slot');
///   },
/// )
/// ```
class AppointmentCalendar extends StatefulWidget {
  /// The name of the person or resource being scheduled
  final String name;

  /// The title or role of the person
  final String title;

  /// The avatar image to display
  final ImageProvider avatarImg;

  /// A brief description or introduction
  final String description;

  /// Set of dates that should be disabled in the calendar
  final Set<DateTime> disabledDays;

  /// List of available time slots
  final List<String> timeSlots;

  /// Callback function when an appointment is submitted
  ///
  /// Parameters:
  /// * [date] - The selected date
  /// * [timeSlot] - Index of the selected time slot
  /// * [note] - Optional note added by the user
  final Function(DateTime date, int timeSlot, String note) onSubmit;

  AppointmentCalendar({
    super.key,
    required this.name,
    required this.title,
    required this.avatarImg,
    required this.description,
    required this.disabledDays,
    required this.timeSlots,
    required this.onSubmit,
  })  : assert(timeSlots.isNotEmpty, 'Time slots cannot be empty'),
        assert(timeSlots.length <= 24, 'Maximum 24 time slots allowed');

  @override
  State<AppointmentCalendar> createState() => _AppointmentCalendarState();
}

class _AppointmentCalendarState extends State<AppointmentCalendar> {
  static const double _kBorderRadius = 8.0;
  static const double _kMobileBreakpoint = 600.0;

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  int _selectedTimeSlot = 0;
  final _noteController = TextEditingController();
  bool isMobile = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  /// Checks if a given date should be disabled
  ///
  /// A date is disabled if it's either:
  /// * A weekend (Saturday or Sunday)
  /// * Listed in the disabledDays set
  bool _isDisabled(DateTime day) {
    // Check if it's a weekend
    final isWeekend =
        day.weekday == DateTime.saturday || day.weekday == DateTime.sunday;

    // Check if it's in the disabled dates list
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
    final size = MediaQuery.of(context).size;
    isMobile = size.width < _kMobileBreakpoint;
    final primary = theme.colorScheme.primary;
    final onPrimary = theme.colorScheme.onPrimary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 820),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_kBorderRadius),
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
