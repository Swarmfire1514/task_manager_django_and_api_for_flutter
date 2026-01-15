from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from .models import ActivityLog
from rest_framework import status
from django.shortcuts import get_object_or_404
from .serializers import ActivityLogSerialier

def isAdmin(user):
    return hasattr(user, "profile") and user.profile.role == "admin"

class ActivityLogListAPI(APIView):
    permission_class = [IsAuthenticated]
    
    def get(self, request):
        if isAdmin(request.user):
            activitylog = ActivityLog.objects.all()
        else:
            activitylog = ActivityLog.objects.filter(user=request.user)
            
        serializer = ActivityLogSerialier(activitylog, many=True)
        return Response(serializer.data)