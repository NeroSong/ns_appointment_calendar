# NS Appointment Calendar

A beautiful and modern appointment calendar widget built with Flutter. Perfect for scheduling meetings, consultations, or any time-based appointments.

![Light Mode](demo-pic/shot1.png)
![Dark Mode](demo-pic/shot2.png)

Live Demo: [https://ns-appointment-calendar.zeabur.app/](https://ns-appointment-calendar.zeabur.app/)

## Features

- Modern and elegant UI design
- Light/Dark mode support
- Internationalization (English/Chinese)
- Flexible date selection
- Customizable time slots
- Weekend and holiday blocking
- Appointment notes
- Responsive layout (Mobile/Desktop)

## Getting Started

### Dependencies

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  ns_appointment_calendar: ^1.0.0
```

### Usage

```dart
AppointmentCalendar(
  name: 'Sarah Johnson',
  title: 'Senior Product Manager',
  avatarImg: NetworkImage('https://example.com/avatar.jpg'),
  description: 'Product strategy and team management expert',
  disabledDays: {
    DateTime(2024, 12, 25), // Christmas
    DateTime(2025, 1, 1),   // New Year
  },
  timeSlots: const [
    '10:00 - 11:00',
    '11:00 - 12:00',
    '14:00 - 15:00',
    '15:00 - 16:00',
  ],
  onSubmit: (date, timeSlot, note) {
    print('Appointment submitted: $date, $timeSlot, $note');
  },
),
```

## Customization

The widget is highly customizable with theme support. You can customize:

- Colors and styles
- Time slots
- Disabled dates
- Text strings
- Layout and spacing

## Contributing

Contributions are welcome! Feel free to submit issues and pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
