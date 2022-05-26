from django.contrib import admin
from .models import *
from django.contrib.auth.admin import UserAdmin
import rsa
import os
from django.conf import settings
from .affine_algo import *

# Register your models here.

class AccountAdmin(UserAdmin):
	list_display = ("email", "username", "phone_num", "address", "sex", "last_login", "is_staff", "password")
	search_fields = ("email", "username", )
	readonly_fields = ("date_joined", "last_login")

	filter_horizontal = ("groups", )
	list_filter = ("groups", "is_active", "sex")
	fieldsets = ()

	fieldsets = (
        ('Personal Information', {'fields': ('email', 'username', 'sex', 'phone_num', 'address', 'password')}),
        ('Permissions', {'fields': ('is_staff', 'is_active', 'is_admin')}),
		('Roles', {'fields':('groups',)}),
    )
	
	add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('email', 'username', 'phone_num', 'sex', 'address', 'password1', 'password2', 'is_active', 'is_staff', 'is_admin')}
         ),
    )
	
 
	# def phone_num(self, obj):
	# 	if obj.phone_num is not None and obj.phone_num[0] != '0' and obj.phone_num[0].isalpha() == False:
	# 		print(affine_decoding(obj.address, 7, 3))
	# 		return affine_decoding(obj.phone_num, 7, 3)
	# 	return obj.phone_num
	# phone_num.short_description = 'Phone Number'
 
	# def address(self, obj):
	# 	if obj.address is not None:
	# 		return(affine_decoding(obj.address, 7, 3))
	# address.short_description = 'Address'
 

admin.site.register(Account, AccountAdmin)