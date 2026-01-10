from django.shortcuts import render
from django.core.paginator import Paginator
from django.contrib.auth.decorators import login_required
from .models import ActivityLog

# Create your views here.
@login_required
def activity_log_list(request):
    logs_qs = ActivityLog.objects.filter(user=request.user).order_by("-timestamp")
    
    paginator = Paginator(logs_qs, 10)
    page_number = request.GET.get('page')
    logs = paginator.get_page(page_number)
    return render(request, "activity_log.html", {"logs":logs})