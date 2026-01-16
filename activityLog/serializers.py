from rest_framework import serializers
from .models import ActivityLog

class ActivityLogSerialier(serializers.ModelSerializer):
    username = serializers.CharField(source="user.username", read_only=True)
    
    class Meta:
        model = ActivityLog
        fields = [
            "id",
            "username",
            "action",
            "task",
            "task_title",
            "category",
            "category_title",
            "timestamp",
        ]