from django.urls import path
from rest_framework_simplejwt.views import (TokenObtainPairView, TokenRefreshView)
from . import views
from .views_api import RegisterAPI, ProfileAPI, LogoutAPI

urlpatterns = [
    #Website urls
    path('register/', views.register_view, name='register'),
    path('login/',views.login_view, name="login"),
    path('logout/',views.logout_view, name="logout"),
    path('profile/',views.profile_view, name="profile"),
    
    #API urls
    path("api/register/", RegisterAPI.as_view()),
    path("api/login/", TokenObtainPairView.as_view()),
    path("api/token/refresh/", TokenRefreshView.as_view()),
    path("api/profile/", ProfileAPI.as_view()),
    path("api/logout/", LogoutAPI.as_view())
]
