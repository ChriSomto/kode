# Gradclock App Blueprint

## Overview

`gradclock` is a simple, one-time-use Flutter mobile app for Android, designed as a personal graduation gift from Femi (in West Africa) to Angela (in the Philippines). The app celebrates Angela's *cum laude* graduation on **June 9, 2026**. It features a beautiful countdown, two scheduled celebration moments with personalized messages and a song, and a home screen widget. The app is designed to be self-contained with all data hardcoded.

## Style, Design, and Features (Current Version)

*   **App Name:** gradclock
*   **Package ID:** com.example.gradclock
*   **Platform:** Android only
*   **Color Palette:** A warm, glowing gradient from a soft coral blush to a warm golden yellow, simulating a sunrise.
*   **Typography:**
    *   **Primary/Headings:** Playfair Display (via `google_fonts`)
    *   **Body/Secondary:** Nunito (via `google_fonts`)
*   **UI Components:**
    *   Frosted glass-style rounded cards for countdown elements.
    *   Pill-shaped buttons for actions.
    *   Full-screen, immersive views with animated gradients.

### Core Features Implemented:

*   **Project Scaffolding:** Initial file structure created for screens, services, widgets, and Android-specific resources.
*   **Dependencies:** All necessary Flutter packages (`flutter_local_notifications`, `timezone`, `flutter_timezone`, `just_audio`, `home_widget`, `workmanager`, `shared_preferences`, `confetti`, `google_fonts`) have been added to `pubspec.yaml`.
*   **Android Configuration:** `android/app/build.gradle` has been configured for the project, including Kotlin support and Java 8 compatibility.
*   **Android Home Screen Widget:**
    *   `gradclock_widget.xml`: Basic layout for the widget created in `android/app/src/main/res/layout/`.
    *   `gradclock_widget_info.xml`: Widget provider configuration created in `android/app/src/main/res/xml/`.
    *   `GradclockWidgetProvider.kt`: A basic `AppWidgetProvider` class created in `android/app/src/main/java/com/example/gradclock/` to handle widget updates.

## Plan for Current Request

**Objective:** Continue building the `gradclock` application based on the user's detailed prompt.

**Action Steps:**

1.  **Configure `AndroidManifest.xml`:**
    *   Add the `<receiver>` for the `GradclockWidgetProvider`.
    *   Add necessary permissions: `POST_NOTIFICATIONS`, `SCHEDULE_EXACT_ALARM`, and `FOREGROUND_SERVICE`.

2.  **Implement `main.dart`:**
    *   Set up the main entry point for the app.
    *   Initialize necessary services and packages (`timezone`, `workmanager`).
    *   Lock screen orientation to portrait mode.
    *   Define the root `MaterialApp` and basic theme.
    *   Implement the initial navigation logic (Splash -> Widget Setup -> Countdown).

3.  **Build the Splash Screen (`lib/screens/splash_screen.dart`):**
    *   Create a full-screen, immersive UI with the sunrise gradient.
    *   Implement the pulsing gradient background animation.
    *   Use `AnimatedSwitcher` to fade between the affirmation words: "brilliant", "loved", "unstoppable", "cherished", "celebrated".
    *   Automatically navigate to the next screen after a 4-second delay.

4.  **Build the Scheduling Service (`lib/services/scheduling_service.dart`):**
    *   Implement the `testMode` flag.
    *   Define the logic to determine the correct timezones (`Africa/Lagos` vs. `Asia/Manila`).
    *   Define the target dates and times for both celebration moments based on `testMode`.
    *   Expose functions to schedule the notifications using the `flutter_local_notifications` package.

5.  **Build the Notification Service (`lib/services/notification_service.dart`):**
    *   Initialize `flutter_local_notifications`.
    *   Request necessary permissions (`POST_NOTIFICATIONS`, `SCHEDULE_EXACT_ALARM`).
    *   Configure the notification channels.
    *   Set up the callback handler (`onDidReceiveNotificationResponse`) to navigate to the `MessageScreen` with the correct payload.

6.  **Develop Remaining Screens and Services:**
    *   `AudioService`: Manage audio playback with `just_audio`.
    *   `WidgetSetupScreen`: Create the one-time instruction screen.
    *   `CountdownScreen`: Build the main countdown UI with confetti.
    *   `MessageScreen`: Display the celebration messages.
    *   `WorkManager` Task: Implement the background task to update the home screen widget periodically.
