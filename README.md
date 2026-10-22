# DocDoc

DocDoc is a Flutter doctor-appointment app built as a complete **offline demo**.
It takes a new user from onboarding through sign-up, doctor discovery and
booking, and keeps accounts and appointments on the device.

The original API layer is still in the project for future backend work, but the
app does not require a server to run.

## What is included

- **Splash and onboarding** with first-run routing and a "Skip" option.
- **Local authentication** with sign-up, sign-in, forgot-password reset and a
  persisted session. Passwords are stored as salted SHA-256 hashes, never as
  plain text.
- **Home experience** with a personalised greeting, doctor search, specialty
  filters, a featured banner and responsive doctor cards.
- **Doctor details** with rating, experience, patients, location, about,
  working days and time slots.
- **Booking flow** with available dates generated from the doctor's schedule,
  future-only time slots, an optional visit reason and duplicate-slot
  protection.
- **Appointments** screen with upcoming, completed and cancelled states, plus
  cancellation with confirmation.
- **Profile** with local account info, editable display name, appointment
  count, about dialog and logout.
- **Persistence** through `shared_preferences`: accounts, the active session,
  onboarding state and appointments survive app restarts.
- **Tested flows** covering auth storage, repositories, cubits and the main UI.
- **Responsive layouts** for phones, tablets and wide windows: capped content
  widths, multi-column doctor grids, a navigation rail on large screens and
  clamped text scaling.
- **Mobile platform setup** for Android and iOS: portrait-first orientation,
  styled system bars, native splash screens and "DocDoc" app labels.

## Getting started

```bash
flutter pub get
dart run build_runner build
flutter run
```

The generated Freezed files are checked in, so `build_runner` only needs to be
run again after changing a `@freezed` state class.

To run on a phone or emulator:

```bash
flutter devices
flutter run -d <device-id>
```

To produce an installable debug APK:

```bash
flutter build apk --debug
```

The APK is written to `build/app/outputs/flutter-apk/app-debug.apk`.

For a smaller installable artifact:

```bash
flutter build apk --release
flutter build apk --release --split-per-abi  # one APK per CPU architecture
```

Release builds are currently signed with the debug keystore, so configure a
real signing key before publishing (see Notes and limitations).

### Using the demo

There are no seeded accounts. On first launch:

1. Continue through onboarding.
2. Tap **Sign Up** and create an account with a valid email, an Egyptian mobile
   number (for example `01012345678`) and a password such as `Strong1!`.
3. Search or filter for a doctor, open their profile and book an appointment.
4. Open the **Appointments** tab to view or cancel the booking.

Sign out from the **Profile** tab and sign back in with the same credentials at
any time.

## Architecture

The project follows a feature-first structure:

```text
lib/
  core/
    auth/            local accounts, session and password hashing
    di/              GetIt registration
    helpers/         regexes, responsive helpers, spacing and snackbars
    networking/      original Dio/Retrofit layer (ready for a real API)
    routing/         route names, typed arguments and router
    theme/           colours and text styles
    widgets/         shared button, text field and empty state
  features/
    appointments/    appointment model, local repository, cubit and UI
    booking/         booking cubit, date helpers and booking screen
    home/            doctor catalogue, search/filter cubit and screens
    login/           local login repository, cubit and UI
    main/            bottom navigation / navigation rail shell
    onboarding/      onboarding UI
    profile/         profile and account actions
    sign_up/         local sign-up repository, cubit and UI
    splash/          session-aware startup routing
  doc_app.dart
  main.dart
```

State management uses `flutter_bloc` cubits. Immutable states use `freezed`,
dependency injection uses `get_it`, and repositories return `Either` values via
`dartz`. The UI is built with `flutter_screenutil_plus` for responsive sizing.

### Responsive design

Layouts adapt at the Material 3 window-size breakpoints:

- **Compact (`< 600dp`)** — phones: single-column lists, bottom
  `NavigationBar` and full-width padded content.
- **Medium (`600-839dp`)** — tablets and foldables: the same navigation, with
  capped content widths and roomier spacing.
- **Expanded (`>= 840dp`)** — large tablets and desktop windows: a
  `NavigationRail` replaces the bottom bar, and doctor lists use a two-column
  grid when each card has enough room.

Shared helpers live in `lib/core/helpers/responsive.dart`:

- `AppBreakpoints` defines the breakpoints and content caps.
- `ResponsiveCenter` caps and centres page bodies.
- `ResponsiveWidth` caps single elements such as bottom-bar buttons.
- `responsiveFontSize` clamps ScreenUtil text scaling to `0.9-1.3x`, so tablets
  do not render oversized type.

Forms are capped at 480dp, details and lists at 720dp, and the multi-column
home/all-doctors lists at 960dp.

## Data storage

Everything is stored locally with `shared_preferences`:

| Key | Contents |
| --- | --- |
| `docdoc_accounts_v1` | Registered accounts and salted password hashes |
| `docdoc_session_v1` | The active user session |
| `docdoc_onboarding_seen_v1` | First-run onboarding flag |
| `docdoc_appointments_v1_<email>` | Booked appointments for the signed-in account |

Appointments are keyed by account, so signing in as a different user does not
reveal another user's bookings. Uninstalling the app removes all of this data.
This is a demo, not a secure production authentication system.

## Backend integration

The project still contains the original `Dio`/Retrofit service, request/response
models and `DioFactory`. The demo intentionally uses local repositories:

- `lib/features/login/data/repo/login_repo_imp.dart`
- `lib/features/sign_up/data/repo/sign_up_repo_imp.dart`
- `lib/features/appointments/data/repo/local_appointment_repository.dart`

To connect a real backend later, replace those repository implementations with
API-backed versions and update the base URL in
`lib/core/networking/api_constants.dart`. The original demo host
(`vcare.integration25.com`) is no longer reachable, which is why this build runs
entirely offline.

## Quality checks

```bash
flutter analyze
flutter test
```

The test suite covers:

- account creation, duplicate emails, login, logout and password resets;
- password hashing and session persistence;
- doctor search/filtering and home cubit behaviour;
- booking, duplicate-slot protection and cancellation in local storage;
- login/sign-up cubits;
- onboarding, sign-up, login, home and an end-to-end booking UI flow;
- responsive layout at 320, 390, 768 and 1024 logical pixels, including the
  bottom-bar/navigation-rail switch, centred form widths and the multi-column
  doctor grid.

## Notes and limitations

- This is an offline demonstration app. It does not provide medical advice and
  should not be used with real patient data.
- Authentication is local to one device; there is no email verification or
  server-side session validation.
- `intl` is used for date formatting; no additional localisation setup is
  included.
- Phones are locked to portrait. Tablets can rotate and use the wide layout;
  the web and desktop folders remain for convenience, but Android and iOS are
  the target platforms.
- The Android release build is still signed with the debug keystore and uses
  the `com.example.docdoc` application id. Configure a unique id and a release
  keystore before publishing. The launcher icon is still the Flutter default.
