from django.db.models.signals import post_save, post_delete
from django.dispatch import receiver
from .models import Task
from activityLog.models import ActivityLog

@receiver(post_save, sender=Task)
def create_or_update_task_log(sender,instance,created,**kwargs):
    user= instance.category.user
    
    if created:
        ActivityLog.objects.create(
            user=user,
            task=instance,
            action="created"
        )
        
    else:
        if instance.status == "completed":
            ActivityLog.objects.create(
                user=user,
                task=instance,
                action="completed"
            )
            
        else:
            ActivityLog.objects.create(
                user=user,
                task=instance,
                action="updated"
            )
            
@receiver(post_delete, sender=Task)
def log_task_deleted(sender,instance,**kwargs):
    ActivityLog.objects.create(
        user=instance.category.user,
        task=None,
        action="deleted"
    )