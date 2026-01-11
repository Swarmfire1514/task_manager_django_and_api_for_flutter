from django.contrib import admin
from .models import ActivityLog

# Register your models here.
@admin.register(ActivityLog)
class ActivityLogAdmin(admin.ModelAdmin):
    list_display = ('id','user','task','task_title','action','timestamp')
    search_fields = ('user__username',)
    list_filter = ('user','task')