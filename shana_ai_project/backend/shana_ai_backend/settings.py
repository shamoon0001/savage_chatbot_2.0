# backend/shana_ai_backend/settings.py

from pathlib import Path
import os

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/4.2/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = 'django-insecure-=!your_secret_key_here!#change_me_later#sdg345gfh' # IMPORTANT: Change this in a real app

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True # Set to False for production

ALLOWED_HOSTS = ['localhost', '127.0.0.1','192.168.159.238'] # Add your Flutter app's host if needed, or '*' for all during dev


# Application definition

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'rest_framework',         # Django REST framework
    'rest_framework.authtoken', # For token-based authentication (optional, but good for APIs)
    'corsheaders',            # For Cross-Origin Resource Sharing
    'api',                    # Our new app
]

MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware', # CORS middleware - place it high, especially before CommonMiddleware
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware', # Important for web forms, can be managed for APIs
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'shana_ai_backend.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'shana_ai_backend.wsgi.application'


# Database
# https://docs.djangoproject.com/en/4.2/ref/settings/#databases

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3', # This will create db.sqlite3 in the `backend` directory
    }
}


# Password validation
# https://docs.djangoproject.com/en/4.2/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]


# Internationalization
# https://docs.djangoproject.com/en/4.2/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC' # You can change this to your local timezone, e.g., 'Asia/Kolkata'

USE_I18N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/4.2/howto/static-files/

STATIC_URL = 'static/'

# Default primary key field type
# https://docs.djangoproject.com/en/4.2/ref/settings/#default-auto-field

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

# Django REST framework settings
REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': [
        # Using SessionAuthentication for simplicity with web browsers during development.
        # For Flutter apps, TokenAuthentication is generally preferred.
        'rest_framework.authentication.SessionAuthentication',
        'rest_framework.authentication.TokenAuthentication',
    ],
    'DEFAULT_PERMISSION_CLASSES': [
        'rest_framework.permissions.IsAuthenticatedOrReadOnly', # Or IsAuthenticated for stricter APIs
    ]
}

# CORS settings
CORS_ALLOWED_ORIGINS = [
    "http://localhost:8000",
    "http://192.168.159.238:8000"# Django development server
    # Add the port your Flutter app runs on during development, e.g.:
    # "http://localhost:5000", (if flutter runs on 5000, check your flutter run output)
    # You might need to find the exact port Flutter web uses, or use CORS_ALLOW_ALL_ORIGINS = True for local dev
]
# For local development, allowing all origins can be easier:
CORS_ALLOW_ALL_ORIGINS = True # Set to False in production and specify origins

# CSRF settings for API development
# If you are using TokenAuthentication and not relying on session cookies for auth,
# you might not need CSRF protection for your API endpoints.
# However, if SessionAuthentication is active, CSRF is important.
# For APIs typically consumed by non-browser clients, you might want to exempt them or use different auth.
# For now, we'll keep it, as SessionAuth is enabled.
# If you face CSRF issues with Flutter, ensure Flutter sends the CSRF token or use TokenAuth primarily.

# Custom User Model (Optional, but good practice for future expansion)
# AUTH_USER_MODEL = 'api.CustomUser' # If you create a custom user model in api/models.py
