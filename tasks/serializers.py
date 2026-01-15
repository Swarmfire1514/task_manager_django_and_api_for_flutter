from rest_framework import serializers
from .models import Task

class TaskSerializer(serializers.ModelSerializer):
    category_name = serializers.CharField(source="category.name", read_only=True)
    
    class Meta:
        model = Task
        fields = [
            "id",
            "title",
            "description",
            "status",
            "priority",
            "due_date",
            "category",
            "category_name"
            "created_at",
            "updated_at",
        ]