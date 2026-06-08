import 'package:gradclock/services/notification_service.dart' as notifications;
import 'package:timezone/timezone.dart' as tz;

// ── FLIP THIS TO false WHEN SENDING TO ANGELA ─────────────────────────────
const bool testMode = true;
// ──────────────────────────────────────────────────────────────────────────

Future<void> scheduleAllNotifications() async {
  if (testMode) {
    await _scheduleTestNotifications();
  } else {
    await _scheduleRealNotifications();
  }
}

Future<void> _scheduleTestNotifications() async {
  // Lagos time (WAT, UTC+1) — June 8, 2026
  // Moment 1: 2:50 AM  |  Moment 2: 3:00 AM
  final location = tz.getLocation('Africa/Lagos');

  await notifications.scheduleNotification(
    id: 0,
    title: "It's HERE, Angela!",
    body: "Open me — Femi has something for you!",
    scheduledDate: tz.TZDateTime(location, 2026, 6, 8, 5, 33), // 2:50 AM Lagos
    payload: '1',
  );

  await notifications.scheduleNotification(
    id: 1,
    title: "Hey, graduate",
    body: "Femi's thinking of you right now",
    scheduledDate: tz.TZDateTime(location, 2026, 6, 8, 5, 38), // 3:00 AM Lagos
    payload: '2',
  );
}

Future<void> _scheduleRealNotifications() async {
  // Manila time (PHT, UTC+8) — June 9, 2026
  // Moment 1: 12:00 AM  |  Moment 2: 5:00 PM
  final location = tz.getLocation('Asia/Manila');

  await notifications.scheduleNotification(
    id: 0,
    title: "It's HERE, Angela!",
    body: "Open me — Femi has something for you!",
    scheduledDate: tz.TZDateTime(location, 2026, 6, 9, 0, 0), // 12:00 AM Manila
    payload: '1',
  );

  await notifications.scheduleNotification(
    id: 1,
    title: "Hey, graduate",
    body: "Femi's thinking of you right now",
    scheduledDate: tz.TZDateTime(location, 2026, 6, 9, 17, 0), // 5:00 PM Manila
    payload: '2',
  );
}
