# Sahaj Yatra — Digital Bus Fare Management System

Flutter implementation of the *Sahaj Yatra* project described in the major project report
(`Major-Project-Report (1).pdf`). The app mirrors the modules highlighted in chapters 5 and 6:

- RFID based passenger experience with balance, transactions, Khalti top-ups, and GPS bus
  tracking.
- Bus owner portal for revenue analytics, fleet management, and live tracking.
- Admin console for verifying users, assigning RFID tags, managing buses, and deleting
  accounts.

## Project structure

```
lib/
  models/           # JSON models for Passenger, BusOwner, Bus, Location, Transaction
  services/         # ApiService wrapping endpoints from the report
  providers/        # Riverpod state (auth, passenger, bus data)
  screens/          # Auth, passenger, owner, and admin UI modules
  utils/            # Validators, routing, map helpers
  widgets/          # Shared cards/components
```

## Getting started

1. **Install prerequisites**
   - Flutter 3.10+
   - Android/iOS toolchains and emulators

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment variables**
   Create a `.env` file in the project root:
   ```
   API_BASE_URL=https://sahaj-yatra-api.onrender.com/api/v1
   ```

4. **Generate model code**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

6. **Analyze & test**
   ```bash
   flutter analyze
   flutter test
   ```

## Key dependencies

- `flutter_riverpod` — state management for auth, passenger, owner, and admin flows.
- `dio` — HTTP client for all REST interactions described in the report.
- `json_serializable` — code generation for API models.
- `google_maps_flutter` — real-time bus tracking (chapter 5 GPS scope).
- `fl_chart` — owner revenue analytics visuals compatible with Flutter 3.10+.
- `flutter_secure_storage` — encrypted persistence for auth tokens.

> **Khalti note:** The report’s payment flow (figure 5.9) is implemented as a
> manual reference-entry screen because the legacy `khalti_flutter` plugin is
> incompatible with Flutter 3.10+. The UI still records Khalti tokens via the
> backend endpoint so the admin workflow remains intact.

## API configuration

`lib/services/api_service.dart` centralizes every endpoint from the report (auth, passenger
profile, RFID assignment, etc.). Update `.env` with your deployment URLs or mock servers.

## Testing

- `test/widget_test.dart` ensures the Sahaj Yatra shell renders correctly.
- `test/auth_provider_test.dart` validates the auth controller logic with in-memory fakes.

## Further reading

See `Major-Project-Report (1).pdf` for the full scope, flowcharts, database schema, and
feature breakdown that guided this implementation. Use the report as the source of truth
when extending the mobile app.
