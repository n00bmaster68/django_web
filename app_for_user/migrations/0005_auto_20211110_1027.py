# Generated by Django 3.1.7 on 2021-11-10 03:27

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('app_for_user', '0004_auto_20211108_1503'),
    ]

    operations = [
        migrations.AlterUniqueTogether(
            name='stock',
            unique_together=set(),
        ),
    ]