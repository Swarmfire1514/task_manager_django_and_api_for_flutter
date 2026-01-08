from django.shortcuts import render, redirect
from django.contrib.auth.models import User
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.contrib.auth import authenticate, login, logout
from .models import Profile

#View for register handling
def register_view(request):
    if request.method == "POST":
        username = request.POST['username']
        email = request.POST['email']
        password = request.POST['password']
        
        if User.objects.filter(username=username).exists():
            messages.error(request, "Username already exists")
            return redirect('register')
        
        user = User.objects.create_user(
            username=username,
            email=email,
            password=password
        )
        
        Profile.objects.create(user=user)
        messages.success(request, "Account create successfully")
        return redirect('login')
    
    return render(request, 'register.html')

#View for login
def login_view(request):
    if request.method == "POST":
        username = request.POST['username']
        password = request.POST['password']
        
        user = authenticate(request, username=username, password=password)
        
        if user:
            login(request, user)
            return redirect ('home')
        else:
            messages.error(request, "Invalid credentials")
            
    return render(request, 'login.html') 

#View for logout handling.
def logout_view(request):
    logout(request)
    return redirect('login')

@login_required
def profile_view(request):
    return render(request, 'profile.html',{
        'user': request.user,
        'profile': request.user.profile
    })
    
#logged out and logged in state handling.
#def home_redirect(request):
#    if request.user.is_authenticated:
#        return render(request, 'home.html')
#    else:
#        return redirect('login')

#better way
@login_required(login_url='login')
def home_redirect(request):
    return render(request, 'home.html',{
        'user': request.user,
    })