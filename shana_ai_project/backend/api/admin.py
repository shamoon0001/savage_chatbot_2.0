# backend/api/admin.py

from django.contrib import admin
from .models import ChatMessage

@admin.register(ChatMessage)
class ChatMessageAdmin(admin.ModelAdmin):
    list_display = ('user', 'sender_type', 'message_text_shortened', 'timestamp')
    list_filter = ('user', 'sender_type', 'timestamp')
    search_fields = ('user__username', 'message_text')

    def message_text_shortened(self, obj):
        return (obj.message_text[:75] + '...') if len(obj.message_text) > 75 else obj.message_text
    message_text_shortened.short_description = 'Message (Shortened)'

# If you had a CustomUser model, you would register it here as well.
# from django.contrib.auth.admin import UserAdmin
# from .models import CustomUser
# admin.site.register(CustomUser, UserAdmin)
