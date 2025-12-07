import 'package:flutter/material.dart';

import '../screens/admin/admin_assign_rfid_page.dart';
import '../screens/admin/admin_dashboard.dart';
import '../screens/admin/admin_delete_accounts_page.dart';
import '../screens/admin/admin_manage_bus_page.dart';
import '../screens/admin/admin_verify_users_page.dart';
import '../screens/admin/admin_pending_verifications_page.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/owner/owner_bus_list_page.dart';
import '../screens/owner/owner_dashboard.dart';
import '../screens/owner/owner_live_bus_tracking_page.dart';
import '../screens/owner/owner_register_bus_page.dart';
import '../screens/owner/owner_revenue_graphs_page.dart';
import '../screens/passenger/khalti_payment_page.dart';
import '../screens/passenger/passenger_balance_page.dart';
import '../screens/passenger/passenger_dashboard.dart';
import '../screens/passenger/passenger_map_tracking_page.dart';
import '../screens/passenger/passenger_profile_page.dart';
import '../screens/passenger/passenger_transactions_page.dart';
import '../screens/driver/driver_home_screen.dart';
import '../screens/driver/qr_scan_screen.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/auth':
        return MaterialPageRoute(builder: (_) => const AuthScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case '/splash':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/logout':
        // This route is handled in UI by calling AuthController.logout() and then
        // navigating to splash. We still define it to keep navigation explicit.
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/driver-home':
        return MaterialPageRoute(builder: (_) => const DriverHomeScreen());
      case '/driver/qr-scan':
        return MaterialPageRoute(builder: (_) => const QrScanScreen());
      case '/passenger':
        return MaterialPageRoute(builder: (_) => const PassengerDashboard());
      case '/passenger/balance':
        return MaterialPageRoute(builder: (_) => const PassengerBalancePage());
      case '/passenger/transactions':
        return MaterialPageRoute(
            builder: (_) => const PassengerTransactionsPage());
      case '/passenger/profile':
        return MaterialPageRoute(builder: (_) => const PassengerProfilePage());
      case '/passenger/map':
        return MaterialPageRoute(
            builder: (_) => const PassengerMapTrackingPage());
      case '/passenger/khalti':
        return MaterialPageRoute(builder: (_) => const KhaltiPaymentPage());
      case '/owner':
        return MaterialPageRoute(builder: (_) => const OwnerDashboard());
      case '/owner/buses':
        return MaterialPageRoute(builder: (_) => const OwnerBusListPage());
      case '/owner/register-bus':
        return MaterialPageRoute(builder: (_) => const OwnerRegisterBusPage());
      case '/owner/revenue':
        return MaterialPageRoute(
            builder: (_) => const OwnerRevenueGraphsPage());
      case '/owner/live-tracking':
        return MaterialPageRoute(
            builder: (_) => const OwnerLiveBusTrackingPage());
      case '/admin':
        return MaterialPageRoute(builder: (_) => const AdminDashboard());
      case '/admin/pending-passengers':
        return MaterialPageRoute(
            builder: (_) => const AdminPendingVerificationsPage());
      case '/admin/verify':
        return MaterialPageRoute(
            builder: (_) => const AdminVerifyUsersPage());
      case '/admin/rfid':
        return MaterialPageRoute(builder: (_) => const AdminAssignRfidPage());
      case '/admin/buses':
        return MaterialPageRoute(builder: (_) => const AdminManageBusPage());
      case '/admin/delete':
        return MaterialPageRoute(
            builder: (_) => const AdminDeleteAccountsPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Unknown route ${settings.name}')),
          ),
        );
    }
  }
}

