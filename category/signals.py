from django.db.models.signals import post_save, post_delete
from django.dispatch import receiver
from .models import Category
from activityLog.models import ActivityLog

@receiver(post_save, sender=Category)
def create_or_update_category_log(sender, instance, created, **kwargs):
    if kwargs.get("raw", False):
        return
    
    user = instance.user
    
    if created:
        action="created"
    else:
        action="updated"
        
    ActivityLog.objects.create(
        user=user,
        category=instance,
        category_title=instance.name,
        action=action
    )
        
@receiver(post_delete, sender=Category)
def log_category_deleted(sender, instance, **kwargs):
    ActivityLog.objects.create(
        user=instance.user,
        category=None,
        category_title=instance.name,
        action="deleted"
    )