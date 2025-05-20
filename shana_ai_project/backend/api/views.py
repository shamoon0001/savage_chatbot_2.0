# backend/api/views.py

from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login, logout
from django.db import transaction # For atomic operations

from rest_framework import status, views, permissions
from rest_framework.response import Response
from rest_framework.authtoken.models import Token
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated, AllowAny

from .models import ChatMessage
from .serializers import UserSerializer, ChatMessageSerializer

import random

# --- Helper: Witty Roast Logic ---

HUMOROUS_ROASTS = [
    "I've seen better comebacks from a screen door in a hurricane.",
    "Are you always this stupid, or is today a special occasion?",
    "I'd agree with you, but then we'd both be wrong.",
    "Somewhere out there, a tree is tirelessly producing oxygen for you. You owe it an apology.",
    "You're the reason we have warning labels.",
    "I'm not saying I hate you, but I would unplug your life support to charge my phone.",
    "If ignorance is bliss, you must be the happiest person on earth.",
    "I'd call you a tool, but even they serve a purpose.",
    "Your village called, they want their idiot back.",
    "Do you ever wonder what life would be like if you'd gotten enough oxygen at birth?",
    "If laughter is the best medicine, your face must be curing the world!",
    "You're the reason the gene pool needs a lifeguard.",
    "I'd call you a genius, but I'm a terrible liar.",
    "Are you a magician? Because whenever I look at you, everyone else disappears... from laughter.",
    "You have a unique way of lighting up a room... by leaving it.",
    "I bet your brain feels as good as new, seeing that you never use it.",
    "If you were any more inbred, you'd be a sandwich.",
    "I'm jealous of people who don't know you.",
    "You're like a software update. Every time I see you, I immediately think 'Not now.'",
    "You're not the sharpest tool in the shed, are you? More like a spoon in a knife fight.",
    "I'd explain it to you, but I don't have any crayons with me.",
    "Were you born on the highway? Because that's where most accidents happen.",
    "Beauty is only skin deep, but ugly goes clean to the bone, and you're marrow-deep.",
    "I don't have the time or the crayons to explain this to you.",
    "You're the human equivalent of a participation trophy."
]

NON_HUMOROUS_ROASTS = [ # More direct, less overtly jokey
    "Your contributions are noted, though not necessarily valued.",
    "That was an... attempt.",
    "I've heard more compelling arguments from a toddler.",
    "Is that your final thought, or are you still buffering?",
    "Some people are like clouds. When they disappear, it's a brighter day.",
    "You're not the dumbest person in the world, but you better hope they don't die.",
    "I'm not ignoring you, I'm just prioritizing.",
    "I would challenge you to a battle of wits, but I see you are unarmed.",
    "I'm busy right now, can I ignore you some other time?",
    "You possess a unique set of skills, none of which seem to be applicable here.",
    "Frankly, I expected better.",
    "That's an interesting perspective. Wrong, but interesting.",
    "Let's move on, shall we? This isn't productive.",
    "I'm struggling to see your point.",
    "Perhaps we should agree to disagree, primarily because you're wrong.",
    "Your logic is... creative.",
    "I'm sure that made sense in your head.",
    "Are you done, or are there more non-sequiturs to come?",
    "I'll take that under advisement. Very, very far under.",
    "That's certainly one way to look at it. Not the right way, but one way."
]

def get_shana_reply(user_message_text, roast_type="humorous"): # Default to humorous
    """Generates a witty roast reply from ShanaAI based on the requested type."""
    print(f"Generating reply for type: {roast_type}") # For debugging
    if roast_type == "non-humorous":
        if NON_HUMOROUS_ROASTS:
            return random.choice(NON_HUMOROUS_ROASTS)
        return "I'm out of direct remarks for now." # Fallback

    # Default to humorous if type is not recognized or is "humorous"
    if HUMOROUS_ROASTS:
        return random.choice(HUMOROUS_ROASTS)
    return "I'm all out of jokes!" # Fallback

# --- API Views ---

class SignUpView(views.APIView):
    """
    API view for user registration.
    """
    permission_classes = [AllowAny]

    @transaction.atomic
    def post(self, request):
        username = request.data.get('username')
        password = request.data.get('password')
        email = request.data.get('email', '')

        if not username or not password:
            return Response(
                {"error": "Username and password are required."},
                status=status.HTTP_400_BAD_REQUEST
            )
        if User.objects.filter(username=username).exists():
            return Response(
                {"error": "Username already taken."},
                status=status.HTTP_400_BAD_REQUEST
            )

        try:
            user = User.objects.create_user(username=username, password=password, email=email)
            token, created = Token.objects.get_or_create(user=user)
            return Response(
                {
                    "message": "User created successfully.",
                    "user_id": user.id,
                    "username": user.username,
                    "token": token.key
                },
                status=status.HTTP_201_CREATED
            )
        except Exception as e:
            return Response(
                {"error": f"An error occurred: {str(e)}"},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )


class LoginView(views.APIView):
    """
    API view for user login.
    Returns a token for the user to use for subsequent authenticated requests.
    """
    permission_classes = [AllowAny]

    def post(self, request):
        username = request.data.get('username')
        password = request.data.get('password')

        if not username or not password:
            return Response(
                {"error": "Username and password are required."},
                status=status.HTTP_400_BAD_REQUEST
            )

        user = authenticate(request, username=username, password=password)

        if user is not None:
            login(request, user)
            token, created = Token.objects.get_or_create(user=user)
            return Response(
                {
                    "message": "Login successful.",
                    "user_id": user.id,
                    "username": user.username,
                    "token": token.key
                },
                status=status.HTTP_200_OK
            )
        else:
            return Response(
                {"error": "Invalid credentials."},
                status=status.HTTP_401_UNAUTHORIZED
            )


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def logout_view(request):
    """
    API view for user logout.
    """
    try:
        if hasattr(request.user, 'auth_token') and request.user.auth_token:
            request.user.auth_token.delete()
        logout(request)
        return Response({"message": "Logout successful."}, status=status.HTTP_200_OK)
    except Exception as e:
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class ChatView(views.APIView):
    """
    API view for handling chat messages.
    Receives a message from the user, generates a bot reply, and saves both.
    """
    permission_classes = [IsAuthenticated]

    @transaction.atomic
    def post(self, request):
        user_message_text = request.data.get('message', "Roast me!") # Default message if none provided by client
        roast_type_requested = request.data.get('roast_type', 'humorous') # Get type, default to humorous

        if not user_message_text: # Should not happen due to default
            user_message_text = "Roast me!"

        user = request.user

        try:
            # 1. Save the user's message
            user_chat_message = ChatMessage.objects.create(
                user=user,
                sender_type=ChatMessage.SENDER_USER,
                message_text=user_message_text
            )

            # 2. Generate ShanaAI's reply
            shana_reply_text = get_shana_reply(user_message_text, roast_type_requested)

            # 3. Save ShanaAI's reply
            bot_chat_message = ChatMessage.objects.create(
                user=user,
                sender_type=ChatMessage.SENDER_BOT,
                message_text=shana_reply_text
            )

            serializer = ChatMessageSerializer(bot_chat_message)
            return Response(serializer.data, status=status.HTTP_201_CREATED)

        except Exception as e:
            return Response(
                {"error": f"An error occurred during chat processing: {str(e)}"},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )


class ChatHistoryView(views.APIView):
    """
    API view to retrieve the chat history for the authenticated user.
    """
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user
        messages = ChatMessage.objects.filter(user=user).order_by('timestamp')
        serializer = ChatMessageSerializer(messages, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
