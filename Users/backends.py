from django.contrib.auth.backends import ModelBackend
from django.db.models import Q
from django.contrib.auth import get_user_model

User = get_user_model()

class AuthenticationBackend(ModelBackend):
    def authenticate(self, request ,username=None, password=None, **kwargs):
        try:
            user = User.object.get(Q(email__iexact=username))
            if user.check_password(password):
                return user 
            return None
        except User.DoesNotExist:
            return None

    def get_user(self,user_id):
        try:
            return User.object.get(pk=user_id)
        except User.DoesNotExist:
            return None