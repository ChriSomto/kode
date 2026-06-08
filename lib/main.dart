import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradclock/screens/splash_screen.dart';
import 'package:gradclock/services/scheduling_service.dart' as scheduling;
import 'package:gradclock/services/notification_service.dart' as notifications;
// import 'package:gradclock/services/audio_service.dart' as audio; // commented out
import 'package:gradclock/widgets/home_widget_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await updateHomeWidget();
    return true;
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  await notifications.initNotifications();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());

  // Fire after UI is up
  notifications.requestPermissions();
  // audio.initAudioService(); // commented out — audio disabled for now

  try {
    final prefs = await SharedPreferences.getInstance();
    final alreadyScheduled = prefs.getBool('notifications_scheduled') ?? false;
    if (!alreadyScheduled) {
      await scheduling.scheduleAllNotifications();
      await prefs.setBool('notifications_scheduled', true);
    }
  } catch (_) {
    await scheduling.scheduleAllNotifications();
  }

  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  Workmanager().registerPeriodicTask(
    'widget_refresh',
    'widgetRefreshTask',
    frequency: const Duration(minutes: 15),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: notifications.navigatorKey,
      title: 'gradclock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: const SplashScreen(),
    );
  }
}