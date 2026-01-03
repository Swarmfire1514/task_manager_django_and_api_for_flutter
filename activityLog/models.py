from django.db import models
from user.models import User
from tasks.models import Task

# Create your models here.
class ActivityLog(models.Model):
    ACTION_CHOICES = (
        ('created','Created'),
        ('updated','Updated'),
        ('completed','Completed')
    )
    
    user = models.ForeignKey(User, on_delete= models.CASCADE,related_name='activity_logs')
    action = models.CharField(max_length=10, choices=ACTION_CHOICES,)
    task = models.ForeignKey(Task, on_delete=models.CASCADE, related_name='activity_logs')
    timestamp = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return f"{self.user.username} {self.action} {self.task.title}"