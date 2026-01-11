from django.contrib import admin
from .models import Category

# Register your models here.
# admin.site.register(Category)
@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    list_display = ('id','name','user','created_at','updated_at')
    search_fileds = ('name',)
    list_filter = ('created_at','user')