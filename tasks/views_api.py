from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from .models import Task
from rest_framework.response import Response
from rest_framework import status
from .serializers import TaskSerializer
from django.shortcuts import get_object_or_404
from category.models import Category

def isAdmin(user):
    return hasattr(user, "profile") and user.profile.role == "admin"

def getTaskbyID(user, id):
    if isAdmin(user):
        return get_object_or_404(Task, id=id)
    else:
        return get_object_or_404(Task, id=id, category__user=user) 
    
class TaskListCreateAPI(APIView):
    permission_classes = [IsAuthenticated]
    
    def get(self, request):
        if isAdmin(request.user):
            tasks = Task.objects.all()
        else:
            tasks = Task.objects.filter(category__user = request.user)
        serializer = TaskSerializer(tasks, many=True)
        return Response(serializer.data)
        
    def post(self, request):
        category_id = request.data.get("category")
        category = get_object_or_404(Category, id=category_id, user=request.user)

        serializer = TaskSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(category=category)
            return Response(serializer.data, status=status.HTTP_201_CREATED)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
class TaskDetailAPI(APIView):
    permission_classes = [IsAuthenticated]
    
    def patch(self, request, id):
        task = getTaskbyID(request.user, id)
        serializer = TaskSerializer(task, data=request.data,partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, id):
        task = getTaskbyID(request.user, id)
        task.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)