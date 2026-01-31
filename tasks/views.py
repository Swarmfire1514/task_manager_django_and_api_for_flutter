from django.shortcuts import render, redirect, get_object_or_404
from django.core.paginator import Paginator
from django.contrib.auth.decorators import login_required
from .models import Task
from .forms import TaskForm
from django.views.decorators.http import require_POST

# Create your views here.
@login_required
def task_list(request):
    #get tasks based on user role
    if request.user.profile.role == "admin":
        tasks_qs = Task.objects.all()
    else:
        tasks_qs = Task.objects.filter(category__user=request.user)
    
    paginator = Paginator(tasks_qs, 10)
    page_number = request.GET.get('page')
    tasks = paginator.get_page(page_number)
    return render(request, "task.html",{"tasks":tasks})

@login_required
def task_create(request):
    if request.method == "POST":
        form = TaskForm(request.POST, user=request.user)
        if form.is_valid():
            form.save()
            return redirect("task_list")
    else:
        form = TaskForm(user=request.user)

    return render(request, "create/form.html", {"form": form, "title": "Task"})


@login_required
def task_update(request, id):
    if request.user.profile.role == "admin":
        task = get_object_or_404(Task, pk =id)
    else:
        task = get_object_or_404(Task, pk=id, category__user=request.user)
    
    if request.method == "POST":
        form = TaskForm(request.POST, instance=task, user=request.user)
        if form.is_valid():
            form.save()
            return redirect("task_list")
    else:
        form = TaskForm(instance=task, user=request.user)

    return render(request,"create/form.html",{"form":form, "title": "Task"})

@login_required
def task_complete(request,id):
    if request.user.profile.role == "admin":
        task = get_object_or_404(Task, pk =id)
    else:
        task = get_object_or_404(Task, pk=id, category__user=request.user)
        
    if task.status == "completed":
        task.status = "pending"
    else:
        task.status = "completed"
    task.save()
    return redirect("task_list")

@login_required
@require_POST
def task_delete(request,id):
    if request.user.profile.role == "admin":
        task = get_object_or_404(Task, pk =id)
    else:
        task = get_object_or_404(Task, pk=id, category__user=request.user)
    task.delete()
    return redirect("task_list")