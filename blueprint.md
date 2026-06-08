# gradclock - Flutter App Blueprint

## Overview

A one-time-use personal graduation celebration app for Angela from her boyfriend, Femi. The app features a countdown to her graduation, two scheduled celebration moments with messages and a song, and a home screen widget.

## Style, Design, and Features

### Version 1.0

*   **App Name:** gradclock
*   **Package:** com.example.gradclock
*   **Color Palette:** Warm cloudy pink-to-yellow gradient (soft coral blush to warm golden yellow).
*   **Typography:**
    *   Titles/Headlines: Playfair Display (from `google_fonts`)
    *   Body/UI Text: Nunito (from `google_fonts`)
*   **Screens:**
    *   **Splash Screen:** 4-second animated screen with affirmations.
    *   **Widget Setup Screen:** One-time instruction screen for adding the home screen widget.
    *   **Countdown Screen:** The main app screen showing a live countdown to graduation.
    *   **Message Screen:** Displays special messages at scheduled times.
*   **Celebration Moments:**
    *   **Moment 1 (June 9, 2026, 12:00 AM PHT):** Notification, full-screen message, and automatic song playback.
    *   **Moment 2 (June 9, 2026, 5:00 PM PHT):** Notification and full-screen message.
*   **Home Screen Widget:**
    *   A 4x2 widget that displays the countdown or a celebration message.
    *   Updates periodically in the background.
*   **Audio:**
    *   Plays a song automatically for Moment 1.
    *   Supports background audio.
*   **Notifications:**
    *   Schedules two local notifications for the celebration moments.
*   **Test Mode:**
    *   A `testMode` flag to switch between test and production configurations for notification scheduling.

## Current Plan

### Initial Setup

1.  **Update Android Build Configuration:** Modify `android/app/build.gradle.kts` as per the prompt.
2.  **Update `pubspec.yaml`:** Add all the required dependencies (`flutter_local_notifications`, `timezone`, `flutter_timezone`, `just_audio`, `home_widget`, `workmanager`, `shared_preferences`, `confetti`, `google_fonts`, `flutter_lints`).
3.  **Update `AndroidManifest.xml`:** Add permissions for notifications, foreground service, and register the widget receiver.
4.  **Create Project File Structure:** Create the necessary directories and empty files for screens, services, and widgets.
5.  **Main Function Setup:** Initialize services and settings in `lib/main.dart`.
6.  **Create Android Widget Layout:** Create `gradclock_widget.xml` and `gradclock_widget_info.xml`.
7.  **Create Widget Provider:** Create the `GradclockWidgetProvider.kt` file.
8.  **Implement Splash Screen:** Build the UI and logic for the splash screen.
9.  **Implement Widget Setup Screen:** Build the UI and logic for the widget setup screen.
10. **Implement Countdown Screen:** Build the UI and logic for the countdown screen.
11. **Implement Message Screen:** Build the UI and logic for the message screen.
12. **Implement Notification Service:** Set up notification scheduling.
13. **Implement Audio Service:** Set up audio playback.
14. **Implement Scheduling Service:** Implement the `testMode` logic.
15. **Implement Home Screen Widget Logic:** Connect the widget to the Flutter app using `home_widget` and `workmanager`.
16. **Final Polish & Testing:** Ensure all parts work together as expected.
