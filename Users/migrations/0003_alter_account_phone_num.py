# Generated by Django 3.2.13 on 2022-05-08 12:43

import django.core.validators
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('Users', '0002_alter_account_id'),
    ]

    operations = [
        migrations.AlterField(
            model_name='account',
            name='phone_num',
            field=models.CharField(max_length=500, null=True, unique=True, validators=[django.core.validators.RegexValidator('^0\\d{8,10}$', 'your phone number is not valid')], verbose_name='Phone number'),
        ),
    ]