import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;


Future<void> initializeNotifications() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  tzdata.initializeTimeZones();
}


class ReminderScreen extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final TextEditingController _orderController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _scheduleReminder() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    // Retrieve the values from the text fields
    String orderDetails = _orderController.text;

    // Get the local timezone
    final String timeZoneName = tz.local.name;

    // Calculate the scheduled time
    tz.TZDateTime scheduledTime = tz.TZDateTime(
      tz.getLocation(timeZoneName),
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    // Schedule the reminder
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Home Order Reminder',
      'Don\'t forget: $orderDetails',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'mechanic',
          'channel name',
            importance: Importance.max,
          priority: Priority.high
        ),
        iOS: DarwinNotificationDetails()
      ),
       uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _orderController,
              decoration: const InputDecoration(labelText: 'Order Details'),
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Text('Selected Date: ${_selectedDate.toLocal()}'),
                const SizedBox(width: 20.0),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Select Date'),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Text('Selected Time: ${_selectedTime.format(context)}'),
                const SizedBox(width: 20.0),
                ElevatedButton(
                  onPressed: () => _selectTime(context),
                  child: const Text('Select Time'),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _scheduleReminder();
              },
              child: const Text('Set Reminder'),
            ),
          ],
        ),
      ),
    );
  }
}
