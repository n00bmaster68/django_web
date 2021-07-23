from django.contrib import admin
from .models import *
from django.contrib.auth.admin import UserAdmin
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

admin.site.register(Account, AccountAdmin)