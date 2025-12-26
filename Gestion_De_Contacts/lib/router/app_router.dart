import 'package:go_router/go_router.dart';
import '../screens/login/login_screen.dart';
import '../screens/login/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/contacts/contact_list_screen.dart';
import '../screens/contacts/add_contact_screen.dart';
import '../screens/contacts/edit_contact_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../models/contact.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
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
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}