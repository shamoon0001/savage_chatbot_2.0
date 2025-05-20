"""
URL configuration for shana_ai_backend project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
# backend/shana_ai_backend/urls.py

from django.contrib import admin
from django.urls import path, include # Make sure to import include

urlpatterns = [
    path('admin/', admin.site.urls),
    # Include the URLs from our 'api' app, prefixed with 'api/'
    # For example, a URL in api.urls like 'chat/' will become '/api/chat/'
    path('api/', include('api.urls')),
]

