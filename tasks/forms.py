from django import forms
from .models import Task
from category.models import Category

class TaskForm(forms.ModelForm):
    class Meta:
        model = Task
        fields = [
            "title",
            "description",
            "priority",
            "due_date",
            "category",
        ]
        
    def __init__(self, *args, **kwargs):
        user = kwargs.pop("user")
        super().__init__ (*args,**kwargs)
        
        self.fields["category"].queryset = Category.objects.filter(user = user)