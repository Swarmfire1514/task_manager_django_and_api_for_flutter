from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from .models import ActivityLog
from rest_framework import status
from django.shortcuts import get_object_or_404
from .serializers import ActivityLogSerialier
from rest_framework.pagination import PageNumberPagination

def isAdmin(user):
    return hasattr(user, "profile") and user.profile.role == "admin"

class ActivityLogListAPI(APIView):
    permission_classes = [IsAuthenticated]
    
    def get(self, request):
        if isAdmin(request.user):
            activitylog = ActivityLog.objects.all().order_by('-timestamp')
        else:
            activitylog = ActivityLog.objects.filter(user=request.user).order_by('-timestamp')
        
        paginator = PageNumberPagination()
        paginator.page_size = 10
        result_page = paginator.paginate_queryset(activitylog, request)
            
        serializer = ActivityLogSerialier(result_page, many=True)
        return paginator.get_paginated_response(serializer.data)