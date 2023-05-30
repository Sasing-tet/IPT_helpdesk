from django.db import models
from django.contrib.auth.models import  AbstractBaseUser, PermissionsMixin, BaseUserManager


class UserManager(BaseUserManager):
    def create_user(self, username, password=None, **extra_fields):
        if not username:
            raise ValueError('The Username field must be set')
        user = self.model(username=username, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, username, password, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        return self.create_user(username, password, **extra_fields)
    
class User(AbstractBaseUser, PermissionsMixin):
    userId = models.CharField(max_length=100, primary_key=True)
    username = models.CharField(max_length=100, unique=True)
    password = models.CharField(max_length=100,)
    firstName = models.CharField(max_length=100)
    lastName = models.CharField(max_length=100)
    role = models.CharField(max_length=100)
    is_superuser = models.BooleanField(default=False)

    USERNAME_FIELD = 'username'
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)

    objects = UserManager()

    class Meta:
        db_table = "user"
    
    @property
    def is_anonymous(self):
       return False
    
    @property
    def is_authenticated(self):
        return True

class Category(models.Model):
    catId = models.CharField(max_length=100, primary_key=True)
    userId = models.ForeignKey(User, on_delete=models.CASCADE, null=True, blank=True)
    categoryName = models.CharField(max_length=100); 

    def create_initial_category(sender, **kwargs):
        if sender.name == 'api':
            Category.objects.get_or_create(
                catId='your_category_id',
                categoryName='all'
            )

    class Meta:
        db_table = "category"

class Report(models.Model):
    repId = models.CharField(max_length=100, primary_key=True)
    title = models.CharField(max_length=200)
    description = models.TextField()
    catId = models.ForeignKey(Category, on_delete=models.CASCADE, null=True, blank=True)
    userId = models.ForeignKey(User, on_delete=models.CASCADE, null=True, blank=True)
    updated = models.DateTimeField(auto_now=True)
    created = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.title
    
    class Meta:
        ordering = ['-updated']

class Comment(models.Model):
    commentId = models.CharField(max_length=100, primary_key=True)
    repId = models.ForeignKey(Report, on_delete=models.CASCADE, null=True, blank=True)
    userId = models.ForeignKey(User, on_delete=models.CASCADE, null=True, blank=True)
    showReply = models.BooleanField(default=False)
    content = models.CharField(max_length=1000)
    created = models.DateTimeField(auto_now_add=True)

    def save(self, *args, **kwargs):
        super(Comment, self).save(*args, **kwargs)
        self.repId.save()

    class Meta:
        db_table = "comment"

class Reply(models.Model):
    replyId = models.CharField(max_length=100, primary_key=True)
    commentId = models.ForeignKey(Comment, on_delete=models.CASCADE, null=True, blank=True)
    replyContent = models.CharField(max_length=1000)
    userId = models.ForeignKey(User, on_delete=models.CASCADE, null=True, blank=True)
    created = models.DateTimeField(auto_now_add=True)

    def save(self, *args, **kwargs):
        super(Reply, self).save(*args, **kwargs)
        self.commentId.save()
        self.commentId.repId.save()

    class Meta:
        db_table = "reply"