import 'package:home_widget/home_widget.dart';
import 'package:gradclock/services/scheduling_service.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

/// Called by workmanager in background to refresh the widget
Future<void> updateHomeWidget() async {
  tzData.initializeTimeZones();

  final location = tz.getLocation(testMode ? 'Africa/Lagos' : 'Asia/Manila');
  final now = tz.TZDateTime.now(location);

  // Target times matching scheduling_service.dart
  final moment1 = testMode
      ? tz.TZDateTime(location, 2026, 6, 8, 3, 40)
      : tz.TZDateTime(location, 2026, 6, 9, 0, 0);
  final moment2 = testMode
      ? tz.TZDateTime(location, 2026, 6, 8, 3, 45)
      : tz.TZDateTime(location, 2026, 6, 9, 17, 0);

  String widgetText;

  if (now.isBefore(moment1)) {
    // Before first moment — show countdown
    final diff = moment1.difference(now);
    final d = diff.inDays;
    final h = diff.inHours.remainder(24);
    final m = diff.inMinutes.remainder(60);
    widgetText = d > 0 ? '$d days $h hrs $m min' : '$h hrs $m min';
  } else if (now.isBefore(moment2)) {
    // After midnight, before 5PM
    widgetText = "It's your day, Angela!";
  } else {
    // After 5PM
    widgetText = "So proud of you";
  }

  await HomeWidget.saveWidgetData<String>('countdown', widgetText);
  await HomeWidget.updateWidget(androidName: 'GradclockWidgetProvider');
}

@pragma('vm:entry-point')
Future<void> backgroundCallback(Uri? uri) async {
  await updateHomeWidget();
}