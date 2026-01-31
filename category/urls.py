from django.urls import path
from . import views
from .views_api import CategoryListCreateAPI, CategoryDetailAPI

urlpatterns = [
    # Website urls
    path("", views.category_list, name="category_list"),
    path("create/",views.category_create , name="category_create"),
    path("<int:id>/update/",views.category_update , name="category_update"),
    path("<int:id>/delete/",views.category_delete , name="category_delete"),
    
    # API urls
    path("api/",CategoryListCreateAPI.as_view(), name="category-list-create-api"),
    path("api/<int:id>/", CategoryDetailAPI.as_view(), name="category-update-delete-api")
]
