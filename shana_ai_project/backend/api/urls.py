# backend/api/urls.py

from django.urls import path
from .views import SignUpView, LoginView, logout_view, ChatView, ChatHistoryView
# from rest_framework.authtoken.views import obtain_auth_token # Alternative way to get token

urlpatterns = [
    path('signup/', SignUpView.as_view(), name='signup'),
    path('login/', LoginView.as_view(), name='login'),
    # path('api-token-auth/', obtain_auth_token, name='api_token_auth'), # If you prefer DRF's built-in token view
    path('logout/', logout_view, name='logout'),
    path('chat/', ChatView.as_view(), name='chat'),
    path('chat/history/', ChatHistoryView.as_view(), name='chat-history'),
]
