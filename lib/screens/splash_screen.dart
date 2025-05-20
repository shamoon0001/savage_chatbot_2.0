// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import './auth/login_screen.dart';
import './chat/chat_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Listener for auth status changes
  void _authStatusListener() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!mounted) return;

    if (authProvider.status == AuthStatus.authenticated) {
      Navigator.of(context).pushReplacementNamed(ChatScreen.routeName);
      authProvider.removeListener(_authStatusListener); // Clean up listener
    } else if (authProvider.status == AuthStatus.unauthenticated || authProvider.status == AuthStatus.error) {
      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
      authProvider.removeListener(_authStatusListener); // Clean up listener
    }
    // If still authenticating, the listener remains active
  }

  @override
  void initState() {
    super.initState();
    // The AuthProvider's constructor already calls _initializeAuth.
    // We listen to status changes to navigate.
    // Using addPostFrameCallback to ensure context is available for Provider.of
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Check initial status. If already determined, navigate immediately.
      // Otherwise, add listener.
      if (authProvider.status == AuthStatus.authenticated) {
        Navigator.of(context).pushReplacementNamed(ChatScreen.routeName);
      } else if (authProvider.status == AuthStatus.unauthenticated || authProvider.status == AuthStatus.error) {
        Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
      } else {
        // Status is uninitialized or authenticating, so add the listener.
        authProvider.addListener(_authStatusListener);
      }
    });
  }

  @override
  void dispose() {
    // Ensure listener is removed if the widget is disposed before navigation
    // or if it was added.
    try {
      Provider.of<AuthProvider>(context, listen: false).removeListener(_authStatusListener);
    } catch (e) {
      // print("Error removing listener from AuthProvider in SplashScreen: $e");
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for sizing the logo
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      // backgroundColor: Colors.black, // Optional: if your logo has transparency and you want a black bg
      body: Center(
        child: Image.asset(
          'assets/images/troll.png', // Path to your local PNG logo
          // MAKE SURE THIS PATH IS CORRECT AND THE FILE EXISTS
          // AND IS DECLARED IN PUBSPEC.YAML
          fit: BoxFit.contain, // Adjust fit as needed (cover, contain, fill, etc.)
          width: screenWidth * 0.8, // Example: 60% of screen width, adjust as needed
          height: screenHeight * 0.5, // Example: 30% of screen height, adjust as needed
          // You can omit width/height if you want the logo's original size,
          // but it's good to constrain it for splash screens.
          errorBuilder: (context, error, stackTrace) {
            // Fallback if the logo fails to load
            print("Error loading splash logo: $error");
            return const Center(
                child: Text(
                  'ShanaAI',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white // Or your theme's primary color
                  ),
                )
            );
          },
        ),
      ),
    );
  }
}
