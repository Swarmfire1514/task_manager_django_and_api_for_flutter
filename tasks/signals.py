from django.db.models.signals import post_save, post_delete, pre_save
from django.dispatch import receiver
from .models import Task
from activityLog.models import ActivityLog

@receiver(pre_save, sender=Task)
def task_pre_save(sender, instance, **kwargs):
    if kwargs.get("raw", False):
        return
    
    if instance.pk:
        #Fetch current DB instance before updating
        old_instance = Task.objects.get(pk=instance.pk)
        instance._old_status = old_instance.status
    else:
        instance._old_status = None

@receiver(post_save, sender=Task)
def create_or_update_task_log(sender,instance,created,**kwargs):
    if kwargs.get("raw", False):
        return
    
    user= instance.category.user
    
    if created:
        action = "created"
    else:
        # Use the old status stored in pre_save
        if getattr(instance, "_old_status",None) != instance.status and instance.status=="completed":
            action="completed"
        else:
            action="updated"
    
    ActivityLog.objects.create(
            user=user,
            task=instance,
            task_title=instance.title,
            action=action
        )
    
    #the code block below doesnt update the activity log correctly when one data value is changed
    #if created:
    #    ActivityLog.objects.create(
    #        user=user,
    #        task=instance,
    #        task_title=instance.title,
    #        action="created" if created else ("completed" if instance.status=="completed" else "updated")
    #    )
        
    #else:
    #    if instance.status == "completed":
    #        ActivityLog.objects.create(
    #            user=user,
    #            task=instance,
    #            action="completed"
    #        )
    #        
    #    else:
    #        ActivityLog.objects.create(
    #            user=user,
    #            task=instance,
    #            action="updated"
    #        )
            
@receiver(post_delete, sender=Task)
def log_task_deleted(sender,instance,**kwargs):
    ActivityLog.objects.create(
        user=instance.category.user,
        task=None,
        task_title=instance.title,
        action="deleted"
    )