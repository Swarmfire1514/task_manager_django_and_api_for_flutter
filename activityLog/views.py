from django.shortcuts import render
from django.contrib.auth.decorators import login_required
from .models import ActivityLog

# Create your views here.
@login_required
def activity_log_list(request):
    logs = ActivityLog.objects.filter(user=request.user).order_by("-timestamp")
    return render(request, "acivity_log.html", {"logs":logs})