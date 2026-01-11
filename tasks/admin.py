from django.contrib import admin
from .models import Task

# Register your models here.
@admin.register(Task)
class TaskAdmin(admin.ModelAdmin):
    list_display = ('id','title','description','status','priority','due_date','category','created_at','updated_at')
    search_fields = ('category__user__username','category')
    list_filter = ('category__user','title','priority','category','status')