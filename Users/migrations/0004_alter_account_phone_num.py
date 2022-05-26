# Generated by Django 3.2.13 on 2022-05-08 13:37

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('Users', '0003_alter_account_phone_num'),
    ]

    operations = [
        migrations.AlterField(
            model_name='account',
            name='phone_num',
            field=models.BinaryField(max_length=500, null=True, unique=True, verbose_name='Phone number'),
        ),
    ]