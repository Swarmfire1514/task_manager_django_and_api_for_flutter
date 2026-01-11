from django.db import models
from user.models import User
from tasks.models import Task
from category.models import Category

# Create your models here.
class ActivityLog(models.Model):
    ACTION_CHOICES = (
        ('created','Created'),
        ('updated','Updated'),
        ('completed','Completed'),
        ('deleted','Deleted')
    )
    
    user = models.ForeignKey(User, on_delete= models.CASCADE,related_name='activity_logs')
    action = models.CharField(max_length=10, choices=ACTION_CHOICES,)
    task = models.ForeignKey(Task, on_delete=models.SET_NULL, null=True, blank=True)
    task_title=models.CharField(max_length=150,blank=True,null=True)
    timestamp = models.DateTimeField(auto_now_add=True)
    
    category = models.ForeignKey(Category, on_delete=models.SET_NULL, null=True, blank=True)
    category_title=models.CharField(max_length=150, blank=True, null=True)
    
    def __str__(self):
        return f"{self.user.username} {self.action} {self.task_title} {self.category_title}"