# Generated by Django 3.1.7 on 2021-11-03 12:58

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('app_for_user', '0001_initial'),
    ]

    operations = [
        migrations.RenameField(
            model_name='stock',
            old_name='receiptDetail',
            new_name='receipt_detail',
        ),
    ]
