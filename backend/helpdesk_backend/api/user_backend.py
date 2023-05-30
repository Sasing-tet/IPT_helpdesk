from django.contrib.auth.backends import BaseBackend
from .models import User

class UserBackend(BaseBackend):
    def authenticate(self, request, username=None, password=None, **kwargs):
        try:
            user = User.objects.get(username=username)
        except User.DoesNotExist:
            return None

        if user.check_password(password):
            return user
        else:
            return None

    def get_user(self, userId):
        try:
            return User.objects.get(pk=userId)
        except User.DoesNotExist:
            return None