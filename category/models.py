from django.db import models
from user.models import User

# Create your models here.
class Category(models.Model):
    name = models.CharField(max_length=20)
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="categories")
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return self.name