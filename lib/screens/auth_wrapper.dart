import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';
import 'welcome_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // If authenticated (logged in as regular user or guest), show main application
        if (authProvider.isAuthenticated) {
          return const HomeScreen();
        }

        // If unauthenticated, show WelcomeScreen onboarding experience
        return const WelcomeScreen();
      },
    );
  }
}
