from rest_framework import serializers
from .models import ActivityLog
from rest_framework.views import APIView

class ActivityLogSerialier(APIView):
    username = serializers.CharField(source="user.username", read_only=True)
    
    class Meta:
        model = ActivityLog
        fields = [
            "id",
            "user",
            "action",
            "task",
            "task_title",
            "category",
            "category_title",
            "timestamp",
        ]