from django.urls import path
from . import views
from .views_api import ActivityLogListAPI

urlpatterns = [
    # Website URLs
    path("", views.activity_log_list, name="activity_log_list"),

    # API URLs
    path("api/", ActivityLogListAPI.as_view(), name="activitylog-list-api"),
]
