# backend/api/serializers.py

from rest_framework import serializers
from django.contrib.auth.models import User
from .models import ChatMessage

class UserSerializer(serializers.ModelSerializer):
    """
    Serializer for the User model.
    Used for user registration to specify which fields are needed.
    """
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'password'] # Specify fields
        extra_kwargs = {'password': {'write_only': True}} # Password should not be readable

    def create(self, validated_data):
        # Override create to use Django's create_user method for proper password hashing
        user = User.objects.create_user(
            username=validated_data['username'],
            email=validated_data.get('email', ''), # Handle optional email
            password=validated_data['password']
        )
        return user

class ChatMessageSerializer(serializers.ModelSerializer):
    """
    Serializer for the ChatMessage model.
    """
    # To display username instead of user_id in the API response (optional, but nice)
    # username = serializers.CharField(source='user.username', read_only=True)

    class Meta:
        model = ChatMessage
        fields = ['id', 'user', 'sender_type', 'message_text', 'timestamp']
        read_only_fields = ['user', 'timestamp'] # User and timestamp are set by the server

    def create(self, validated_data):
        # The 'user' will be set in the view based on the authenticated request.user
        # So, we don't expect 'user' in the input data for creation here.
        # It's already handled in the ChatView.
        return ChatMessage.objects.create(**validated_data)

