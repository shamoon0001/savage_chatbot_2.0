# backend/api/models.py

from django.db import models
from django.contrib.auth.models import User # Django's built-in User model

class ChatMessage(models.Model):
    """
    Represents a single message in a chat conversation.
    """
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='chat_messages')
    # 'sender' field to distinguish between user and bot messages
    # Choices for the sender field
    SENDER_USER = 'user'
    SENDER_BOT = 'bot'
    SENDER_CHOICES = [
        (SENDER_USER, 'User'),
        (SENDER_BOT, 'Bot'),
    ]
    sender_type = models.CharField(
        max_length=10,
        choices=SENDER_CHOICES,
        default=SENDER_USER,
    )
    message_text = models.TextField()
    timestamp = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.username} ({self.sender_type}): {self.message_text[:50]}"

    class Meta:
        ordering = ['timestamp'] # Order messages by time
