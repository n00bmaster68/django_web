# Generated by Django 3.1.7 on 2021-11-08 08:03

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('app_for_user', '0003_auto_20211103_2009'),
    ]

    operations = [
        migrations.AddField(
            model_name='billdetail',
            name='stock',
            field=models.ForeignKey(default=2, on_delete=django.db.models.deletion.CASCADE, to='app_for_user.stock', verbose_name='Stock'),
        ),
        migrations.AlterUniqueTogether(
            name='billdetail',
            unique_together={('bill', 'stock')},
        ),
        migrations.RemoveField(
            model_name='billdetail',
            name='product',
        ),
    ]
