from django.urls import path
from . import views
from .views_api import TaskListCreateAPI, TaskDetailAPI

urlpatterns = [
    # website urls
    path("", views.task_list, name="task_list"),
    path("create/", views.task_create, name="task_create"),
    path("<int:id>/update/", views.task_update, name="task_update"),
    path("<int:id>/complete/", views.task_complete, name="task_complete"),
    path("<int:id>/delete/", views.task_delete, name="task_delete"),
    
    # API urls
    path("api/", TaskListCreateAPI.as_view(), name="task-list-create-api"),
    path("api/<int:id>/", TaskDetailAPI.as_view(), name="task-update-delete-api"),
]
