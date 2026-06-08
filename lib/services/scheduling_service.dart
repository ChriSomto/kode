import 'package:gradclock/services/notification_service.dart' as notifications;
import 'package:timezone/timezone.dart' as tz;

// ── FLIP TO true ONLY FOR TESTING, false BEFORE SENDING TO ANGELA ─────────
const bool testMode = false;
// ──────────────────────────────────────────────────────────────────────────

Future<void> scheduleAllNotifications() async {
  // Only real schedule — test mode removed
  await _scheduleRealNotifications();
}

Future<void> _scheduleRealNotifications() async {
  final location = tz.getLocation('Asia/Manila');

  await notifications.scheduleNotification(
    id: 0,
    title: "it's here, angela.",
    body: "open me — femi has something for you",
    scheduledDate: tz.TZDateTime(location, 2026, 6, 9, 0, 0), // 12:00 AM Manila
    payload: '1',
  );

  await notifications.scheduleNotification(
    id: 1,
    title: "hey, graduate.",
    body: "femi's thinking of you right now",
    scheduledDate: tz.TZDateTime(location, 2026, 6, 9, 17, 0), // 5:00 PM Manila
    payload: '2',
  );
}