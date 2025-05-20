// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './app_theme.dart';
import './providers/auth_provider.dart';
import './providers/chat_provider.dart';

import './screens/splash_screen.dart';
import './screens/auth/login_screen.dart';
import './screens/auth/signup_screen.dart';
import './screens/chat/chat_screen.dart';
import './screens/chat/chat_history_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ShanaAIApp());
}

class ShanaAIApp extends StatelessWidget {
  const ShanaAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ChatProvider>(
          create: (ctx) => ChatProvider(Provider.of<AuthProvider>(ctx, listen: false)),
          update: (ctx, auth, previousChatProvider) {
            return previousChatProvider ?? ChatProvider(auth);
          },
        ),
      ],
      child: MaterialApp(
        title: 'ShanaAI',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,

        home: const SplashScreen(),

        routes: {
          SplashScreen.routeName: (ctx) => const SplashScreen(),
          LoginScreen.routeName: (ctx) => const LoginScreen(),
          SignupScreen.routeName: (ctx) => const SignupScreen(),
          ChatScreen.routeName: (ctx) => const ChatScreen(),
          ChatHistoryScreen.routeName: (ctx) => const ChatHistoryScreen(),
        },

        onUnknownRoute: (settings) {
          return MaterialPageRoute(builder: (ctx) => const SplashScreen());
        },
      ),
    );
  }
}
