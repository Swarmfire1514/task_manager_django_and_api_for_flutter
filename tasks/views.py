from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from .models import Task
from .forms import TaskForm

# Create your views here.
@login_required
def task_list(request):
    tasks = Task.objects.filter(category__user=request.user)
    return render(request, "task.html",{"tasks":tasks})

@login_required
def task_create(request):
    if request.method == "POST":
        form = TaskForm(request.POST, user=request.user)
        if form.is_valid():
            form.save()
            return redirect("task_list")
        else:
            form=TaskForm(user=request.user)
    return redirect(request, ".html",{"form": form})

@login_required
def task_update(request, pk):
    task = get_object_or_404(Task, pk=pk, category__user=request.user)
    form = TaskForm(request.POST or None, instance = task, user = request.user)
    if form.is_valid():
        form.save()
        return redirect("task_list")
    return redirect(request,".html",{"form":form})

@login_required
def task_complete(request,pk):
    task = get_object_or_404(Task, pk=pk, category__user=request.user)
    task.status = "completed"
    task.save()
    return redirect("task_list")

@login_required
def task_delete(request,pk):
    task = get_object_or_404(Task, pk = pk, category__user=request.user)
    task.delete()
    return redirect("task_list")