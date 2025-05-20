// lib/config/constants.dart

// IMPORTANT:
// If running on Android Emulator and backend is on the same machine (localhost):
const String API_BASE_URL = "http://192.168.159.238:8000/api";

// If running on iOS Simulator or Flutter Web/Desktop and backend is on localhost:
// const String API_BASE_URL = "http://localhost:8000/api";
// const String API_BASE_URL = "http://127.0.0.1:8000/api";

// If your backend is deployed elsewhere, use that URL:
// const String API_BASE_URL = "https://yourdomain.com/api";

// SharedPreferences keys
const String AUTH_TOKEN_KEY = 'auth_token';
const String USER_ID_KEY = 'user_id';
const String USERNAME_KEY = 'username';
