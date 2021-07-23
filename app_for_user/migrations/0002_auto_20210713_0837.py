# Generated by Django 3.1.7 on 2021-07-13 01:37

import django.core.validators
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('app_for_user', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='bill',
            name='total_price',
            field=models.IntegerField(default=0, validators=[django.core.validators.MinValueValidator(0)], verbose_name='Total'),
        ),
        migrations.AlterField(
            model_name='billdetail',
            name='quantity',
            field=models.IntegerField(default=0, validators=[django.core.validators.MinValueValidator(0)], verbose_name='Quantity'),
        ),
        migrations.AlterField(
            model_name='billdetail',
            name='unit_price',
            field=models.IntegerField(default=0, validators=[django.core.validators.MinValueValidator(0)], verbose_name='Unit price'),
        ),
        migrations.AlterField(
            model_name='goodsreceipt',
            name='total_price',
            field=models.IntegerField(default=0, validators=[django.core.validators.MinValueValidator(0)], verbose_name='Total price'),
        ),
        migrations.AlterField(
            model_name='goodsreceiptdetail',
            name='quantity',
            field=models.IntegerField(default=1, validators=[django.core.validators.MinValueValidator(1)], verbose_name='Quantity'),
        ),
        migrations.AlterField(
            model_name='goodsreceiptdetail',
            name='unit_price',
            field=models.IntegerField(default=0, validators=[django.core.validators.MinValueValidator(0)], verbose_name='Unit price'),
        ),
        migrations.AlterField(
            model_name='product',
            name='price',
            field=models.IntegerField(default=0, validators=[django.core.validators.MinValueValidator(0)], verbose_name='Price'),
        ),
        migrations.AlterField(
            model_name='stock',
            name='quantity',
            field=models.IntegerField(default=0, validators=[django.core.validators.MinValueValidator(0)]),
        ),
    ]
