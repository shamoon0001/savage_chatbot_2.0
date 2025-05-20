# newshana

The user friendly non-vulgar rasting savage ai chatbot

## Getting Started

# Updated ShanaAI 🤖💬

Welcome to Updated ShanaAI, a witty and engaging chatbot application designed to deliver non-vulgar roast replies! This project features a Flutter frontend for a sleek mobile experience and a Python Django backend powering the logic and user data management.

## 🌟 Key Features

* **Witty Roast Replies:** ShanaAI's core feature is its ability to generate clever and amusing roasts.
* **Categorized Humor:**
    * **Humorous Button:** Get overtly funny and lighthearted roasts.
    * **Non-Humorous Button:** Opt for more direct or dryly witty replies.
* **AI-Powered Responses:** Utilizes the OpenAI API (conceptually, via backend integration) to generate dynamic and diverse replies, ensuring a fresh experience.
* **User Authentication:**
    * Secure Signup for new users.
    * Login for existing users.
* **User-Specific Chat History:**
    * Conversations are saved per user.
    * Users can view their past interactions with ShanaAI on a dedicated history screen with a slide-in animation.
* **Sleek User Interface:** A modern, dark-themed UI built with Flutter for a smooth cross-platform experience.
* **Interactive Chat:**
    * Real-time like message display.
    * "ShanaAI is typing..." indicator.
    * Inline send button appears when typing a message.
    * Dedicated buttons for choosing roast styles.
* **Navigation & Session Management:**
    * Splash screen on app open.
    * Logout functionality via a "more" options menu.

## 🛠️ Tech Stack

* **Frontend:**
    * Flutter (SDK Version: 3.29.2 or as per your setup)
    * Dart (SDK Version: 3.7.2 or as per your setup)
    * Key Packages: `provider` (state management), `http` (API calls), `shared_preferences` (local storage), `flutter_spinkit` (loading indicators), `intl` (date formatting).
* **Backend:**
    * Python
    * Django
    * Django REST Framework (for creating APIs)
    * `django-cors-headers` (for handling cross-origin requests)
* **Database:**
    * SQLite3 (for development)
* **AI for Replies (Conceptual Integration):**
    * OpenAI API (for generating roast replies via the backend)

## 🚀 Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

* Git
* Python (3.8+ recommended) & Pip
* Flutter SDK (ensure it's added to your PATH)
* An IDE like Android Studio (with Flutter and Dart plugins) or VS Code (with Flutter and Dart extensions).
* An OpenAI API Key (if you intend to fully implement the AI response generation).

### 1. Clone the Repository

```bash
git clone [https://github.com/YOUR_USERNAME/updated-shana-ai.git](https://github.com/YOUR_USERNAME/updated-shana-ai.git) # Replace with your repo URL
cd updated-shana-ai

2. Backend Setup (Django)
Navigate to the backend directory:

cd backend

Create and activate a virtual environment:

python -m venv venv_backend
# On Windows
venv_backend\Scripts\activate
# On macOS/Linux
source venv_backend/bin/activate

Install dependencies:

pip install django djangorestframework django-cors-headers Pillow # Pillow might be needed for user-uploaded images in future, good to have.
# If you have a requirements.txt: pip install -r requirements.txt

Apply database migrations:

python manage.py makemigrations api
python manage.py migrate

Create a superuser to access the Django admin panel:

python manage.py createsuperuser

(Follow the prompts to set username, email, and password)

(Optional) OpenAI API Key:
If you are implementing the OpenAI API calls, ensure you have your API key. You would typically store this as an environment variable or in a secure configuration file that is not committed to Git (e.g., in an .env file that settings.py reads, and .env is in .gitignore). For the current conceptual use, the backend views.py uses predefined lists.

3. Frontend Setup (Flutter)
Navigate to the frontend directory (from the project root updated-shana-ai):

cd ../frontend # If you are in backend/
# OR from project root:
# cd frontend

Get Flutter packages:

flutter pub get

Configure API Base URL:
Open lib/config/constants.dart and set the API_BASE_URL to point to your Django backend:

If running Flutter on an Android Emulator and Django on the same machine:

const String API_BASE_URL = "[http://10.0.2.2:8000/api](http://10.0.2.2:8000/api)";

If running Flutter on a physical Android device on the same Wi-Fi network as your development machine (where Django is running):
Replace YOUR_COMPUTER_IP_ADDRESS with your computer's actual IP address on the local network.

const String API_BASE_URL = "http://YOUR_COMPUTER_IP_ADDRESS:8000/api";

If running Flutter for web/desktop and Django on the same machine:

const String API_BASE_URL = "[http://127.0.0.1:8000/api](http://127.0.0.1:8000/api)";

🏃 Running the Application
Start the Backend Server:

In your terminal, navigate to the backend directory.

Ensure your virtual environment is activated.

Run the Django development server. To make it accessible from your physical device or emulator:

python manage.py runserver 0.0.0.0:8000

The backend should now be running on http://0.0.0.0:8000/.

Run the Frontend Flutter App:

Open a new terminal or use your IDE (Android Studio/VS Code).

Navigate to the frontend directory.

Ensure you have an emulator running or a physical device connected.

Run the app:

flutter run

The ShanaAI app should now launch on your device/emulator.

📂 Project Structure (Brief Overview)
updated-shana-ai/
├── backend/              # Django backend project
│   ├── api/              # Django app for ShanaAI core logic (models, views, etc.)
│   ├── shana_ai_backend/ # Django project settings & main URLs
│   ├── venv_backend/     # Python virtual environment (ignored by Git)
│   ├── db.sqlite3        # SQLite database (check .gitignore if committed)
│   └── manage.py         # Django management script
├── frontend/             # Flutter frontend project
│   ├── lib/              # Main Dart code
│   │   ├── main.dart
│   │   ├── screens/
│   │   ├── widgets/
│   │   ├── providers/
│   │   ├── services/
│   │   └── models/
│   ├── assets/           # For images, fonts, etc. (e.g., splash screen logo)
│   └── pubspec.yaml      # Flutter project configuration
└── README.md             # This file

✨ Future Enhancements
While "Updated ShanaAI" is packed with fun features, here are some ideas for the future:

Multilingual Support: Allow ShanaAI to roast in different languages!

Group Chats: Let users create groups with friends and have ShanaAI join the roasting fun.

Deeper AI Context: Enhance the AI's memory for even more personalized and context-aware replies.

More Roast Categories: Introduce new styles like "Sarcastic Shana" or "Pun Master Shana."

UI Customization: Allow users to choose different themes for the app.

Basic Offline Mode: Cache some history or pre-defined roasts for when there's no internet.

Voice Input/Output: Speak to ShanaAI and hear its replies!

Social Sharing: Easily share the best roasts with friends.

You can check the screenshots i have attached in this files!

Thank you for checking out Updated And get roasted 😁!!