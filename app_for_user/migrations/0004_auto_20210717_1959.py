# Generated by Django 3.1.7 on 2021-07-17 12:59

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('app_for_user', '0003_auto_20210717_1958'),
    ]

    operations = [
        migrations.AlterField(
            model_name='bill',
            name='state',
            field=models.CharField(choices=[('0', 'Not submitted'), ('1', 'Processing'), ('2', 'Delivering'), ('3', 'Received'), ('4', 'Cancel')], default='Not submitted', max_length=10, verbose_name='State'),
        ),
    ]
