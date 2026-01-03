import 'package:go_router/go_router.dart';

// Import des écrans principaux
import '../screens/login/login_screen.dart';
import '../screens/login/register_screen.dart';
import '../screens/home/home_screen.dart';

// Import des écrans contacts
import '../screens/contacts/contact_list_screen.dart';
import '../screens/contacts/add_contact_screen.dart';
import '../screens/contacts/edit_contact_screen.dart';
import '../models/contact.dart';

// Import des écrans paramètres
import '../screens/settings/settings_screen.dart';
import '../screens/settings/profile_screen.dart';
import '../screens/settings/notifications_screen.dart';
import '../screens/settings/privacy_screen.dart';
import '../screens/settings/theme_screen.dart';
import '../screens/settings/support_screen.dart';
import '../screens/settings/about_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/login',
    routes: [
      /// Login / Register
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      /// Home
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),

      /// Contacts
      GoRoute(
        path: '/contacts',
        builder: (context, state) => const ContactListScreen(),
      ),
      GoRoute(
        path: '/add-contact',
        builder: (context, state) => const AddContactScreen(),
      ),
      GoRoute(
        path: '/edit-contact',
        builder: (context, state) {
          final contact = state.extra as Contact;
          return EditContactScreen(contact: contact);
        },
      ),

      /// Paramètres
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/privacy',
        builder: (context, state) => const PrivacyScreen(),
      ),
      GoRoute(
        path: '/theme',
        builder: (context, state) => const ThemeScreen(),
      ),
      GoRoute(
        path: '/support',
        builder: (context, state) => const SupportScreen(),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutScreen(),
      ),
    ],
  );
}
