from django.contrib.auth.models import User
from django.db import models

# Create your models here.
class Profile(models.Model):
    ROLE_CHOICES = (
        ('user','User'),
        ('admin','Admin'),
    )
    
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    role = models.CharField(max_length=10, choices = ROLE_CHOICES, default='user' )
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return f"{self.user.username} - {self.role}"