from django.db import models
from category.models import Category

# Create your models here.
class Task(models.Model):
    STATUS_CHOICES = (
        ('pending', 'Pending'),
        ('completed', 'Completed'),
    )

    PRIORITY_CHOICES = (
        ('low', 'Low'),
        ('medium', 'Medium'),
        ('high', 'High'),
    )
    
    title = models.CharField(max_length=50)
    description = models.TextField(blank=True, null=True)
    status = models.CharField(max_length=10, choices=STATUS_CHOICES, default = 'pending')
    priority = models.CharField(max_length=10, choices=PRIORITY_CHOICES, default= 'low')
    due_date = models.DateField
    category = models.ForeignKey(Category, related_name='tasks', on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return self.title