# Generated by Django 3.1.7 on 2021-07-18 09:40

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('app_for_user', '0006_auto_20210718_1243'),
    ]

    operations = [
        migrations.AddField(
            model_name='bill',
            name='address',
            field=models.CharField(default='', max_length=150),
        ),
    ]