from django.db import models
from django.contrib.auth.models import User

# Create your models here.
# user auth Q4
class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='profile')
    address_line1 = models.CharField(max_length=255, blank=True)
    address_line2 = models.CharField(max_length=255, blank=True, null=True)
    phone_number = models.CharField(max_length=20, blank=True)

    def __str__(self):
        return self.user.username
