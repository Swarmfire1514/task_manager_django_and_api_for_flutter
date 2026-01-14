from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.permissions import IsAuthenticated
from .serialiers import RegisterSerializer, ProfileSerializer
from .models import Profile
from django.shortcuts import get_object_or_404

class RegisterAPI(APIView):
    def post(self, request):
        serializer = RegisterSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(
            {"message": "User registered Successfully"},
            status=status.HTTP_201_CREATED
        )

class ProfileAPI(APIView):
    permission_classes = [IsAuthenticated]
    
    def get(self, request):
        profile = get_object_or_404(Profile, user=request.user)
        serializer = ProfileSerializer(profile)
        return Response(serializer.data)
    
class LogoutAPI(APIView):
    permission_classes = [IsAuthenticated]
    
    def post(self, request):
        refresh_token= request.data.get("refresh")
        
        if not refresh_token:
            return Response(
                {"error":"Refresh token is required"},
                status = status.HTTP_400_BAD_REQUEST
            )
            
        try:
            token=RefreshToken(refresh_token)
            token.blacklist()
        except Exception:
            return Response(
                {"error":"Invalid or expired token"},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        return Response(
            {"message":"Logged out successully"},
            status=status.HTTP_205_RESET_CONTENT
        )