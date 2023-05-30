from django.contrib import admin

# Register your models here.
from .models import Category, Report, Comment, Reply, User
admin.site.register(Report)
admin.site.register(Category)
admin.site.register(Comment)
admin.site.register(User)
admin.site.register(Reply)
