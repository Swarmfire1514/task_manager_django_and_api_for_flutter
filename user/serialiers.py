from rest_framework import serializers
from django.contrib.auth.models import User
from .models import Profile

class ProfileSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source="user.username", read_only=True)
    class Meta:
        model = Profile
        fields = [
            "id",
            "username",
            "role",
            "created_at",
            "updated_at",
        ]

class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, min_length=6)
    
    class Meta:
        model = User
        fields = ["username", "email", "password"]
        
    def create(self, validated_data):
        user = User.objects.create_user(
            username = validated_data["username"],
            email=validated_data.get("email", ""),
            password=validated_data["password"]
        )
        Profile.objects.create(user=user)
        return user