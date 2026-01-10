from django.urls import path
from . import views

urlpatterns = [
    path("", views.category_list, name="category_list"),
    path("create/",views.category_create , name="category_create"),
    path("<int:id>/update/",views.category_update , name="category_update"),
    path("<int:id>/delete",views.category_delete , name="category_delete"),
]
