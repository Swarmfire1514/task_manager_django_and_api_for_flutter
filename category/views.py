from django.shortcuts import render, redirect, get_object_or_404
from django.core.paginator import Paginator
from django.contrib.auth.decorators import login_required
from .models import Category
from .forms import CategoryForm

# Create your views here.
@login_required
def category_list(request):
    categories_qs= Category.objects.filter(user=request.user)
    
    paginator = Paginator(categories_qs, 10)
    page_number = request.GET.get('page')
    categories = paginator.get_page(page_number)
    return render (request, 'category.html', {"categories":categories})

@login_required
def category_create(request):
    if request.method == "POST":
        form = CategoryForm(request.POST)
        if form.is_valid():
            category = form.save(commit=False)
            category.user = request.user
            category.save()
            return redirect("category_list")
    else:
        form = CategoryForm()
    return render(request,"create/category_form.html", {"form":form})

@login_required
def category_update(request, pk):
    category = get_object_or_404(Category, pk=pk, user=request.user)
    form = CategoryForm(request.POST or None, instance=category)
    if form.is_valid():
        form.save()
        return redirect("category_list")
    return render(request, "create/category_form.html",{"form":form})

@login_required
def category_delete(request, pk):
    category = get_object_or_404(Category, pk=pk, user=request.user)
    category.delete()
    return redirect("category_list")