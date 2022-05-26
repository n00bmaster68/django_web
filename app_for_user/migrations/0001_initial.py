# Generated by Django 3.1.7 on 2021-11-03 12:41

from django.conf import settings
import django.core.validators
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='Bill',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False, verbose_name='Bill id')),
                ('date', models.DateTimeField(auto_now_add=True, verbose_name='Date')),
                ('state', models.CharField(choices=[('0', 'Not submitted'), ('1', 'Processing'), ('2', 'Delivering'), ('3', 'Received'), ('4', 'Cancel')], default='Not submitted', max_length=20, verbose_name='State')),
                ('address', models.CharField(blank=True, default='', max_length=150)),
                ('total_price', models.IntegerField(default=0, validators=[django.core.validators.MinValueValidator(0)], verbose_name='Total')),
                ('customer', models.ForeignKey(default='', on_delete=django.db.models.deletion.PROTECT, to=settings.AUTH_USER_MODEL, verbose_name='Customer')),
            ],
        ),
        migrations.CreateModel(
            name='GoodsReceipt',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('deliverer', models.CharField(max_length=100, verbose_name='Deliverer name')),
                ('total_price', models.IntegerField(default=0, validators=[django.core.validators.MinValueValidator(0)], verbose_name='Total price')),
                ('date', models.DateTimeField(auto_now_add=True, verbose_name='Date\\Time')),
            ],
            options={
                'verbose_name': 'Goods receipt',
            },
        ),
        migrations.CreateModel(
            name='GoodsReceiptDetail',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('quantity', models.IntegerField(default=1, validators=[django.core.validators.MinValueValidator(1)], verbose_name='Quantity')),
                ('unit_price', models.IntegerField(default=0, validators=[django.core.validators.MinValueValidator(0)], verbose_name='Unit price')),
                ('goods_receipt', models.ForeignKey(default='', on_delete=django.db.models.deletion.PROTECT, to='app_for_user.goodsreceipt', verbose_name='Goods receipt ID')),
            ],
            options={
                'verbose_name': 'Goods receipt detail',
            },
        ),
        migrations.CreateModel(
            name='Product',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('name', models.CharField(default='', max_length=50, verbose_name='Name')),
                ('price', models.IntegerField(default=0, validators=[django.core.validators.MinValueValidator(0)], verbose_name='Price')),
                ('img', models.ImageField(upload_to='productImg/', verbose_name='Image')),
            ],
        ),
        migrations.CreateModel(
            name='ProductType',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('type_name', models.CharField(max_length=20, unique=True, verbose_name='Type name')),
            ],
            options={
                'verbose_name': 'Product type',
            },
        ),
        migrations.CreateModel(
            name='Size',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('size', models.CharField(max_length=10, unique=True)),
            ],
        ),
        migrations.CreateModel(
            name='Vendor',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=50, unique=True, verbose_name='Name')),
                ('email', models.EmailField(max_length=255, unique=True, verbose_name='email address')),
                ('phone_num', models.CharField(max_length=10, null=True, unique=True, validators=[django.core.validators.RegexValidator('^0\\d{8,10}$', 'your phone number is not valid')], verbose_name='Phone number')),
                ('address', models.CharField(max_length=100, unique=True, verbose_name='Address')),
            ],
        ),
        migrations.CreateModel(
            name='Warehouse',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('name', models.CharField(default='', max_length=50, verbose_name='Name')),
                ('region', models.CharField(default='', max_length=50)),
                ('address', models.CharField(max_length=100, unique=True, verbose_name='Address')),
                ('phone_num', models.CharField(max_length=10, null=True, unique=True, validators=[django.core.validators.RegexValidator('^0\\d{8,10}$', 'your phone number is not valid')], verbose_name='Phone number')),
            ],
        ),
        migrations.CreateModel(
            name='Stock',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('quantity', models.IntegerField(default=0, validators=[django.core.validators.MinValueValidator(0)])),
                ('product', models.ForeignKey(on_delete=django.db.models.deletion.PROTECT, to='app_for_user.product')),
                ('receiptDetail', models.ForeignKey(on_delete=django.db.models.deletion.PROTECT, to='app_for_user.goodsreceiptdetail')),
                ('size', models.ForeignKey(on_delete=django.db.models.deletion.PROTECT, to='app_for_user.size')),
            ],
            options={
                'unique_together': {('product', 'size')},
            },
        ),
        migrations.AddField(
            model_name='product',
            name='type',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='app_for_user.producttype'),
        ),
        migrations.AddField(
            model_name='goodsreceiptdetail',
            name='product',
            field=models.ForeignKey(default='', on_delete=django.db.models.deletion.PROTECT, to='app_for_user.product', verbose_name='Product ID'),
        ),
        migrations.AddField(
            model_name='goodsreceiptdetail',
            name='size',
            field=models.ForeignKey(default='', on_delete=django.db.models.deletion.PROTECT, to='app_for_user.size', verbose_name='Product size'),
        ),
        migrations.AddField(
            model_name='goodsreceipt',
            name='vendor',
            field=models.ForeignKey(default='', on_delete=django.db.models.deletion.PROTECT, to='app_for_user.vendor', verbose_name='Vendor'),
        ),
        migrations.AddField(
            model_name='goodsreceipt',
            name='warehouse',
            field=models.ForeignKey(on_delete=django.db.models.deletion.PROTECT, to='app_for_user.warehouse'),
        ),
        migrations.AlterUniqueTogether(
            name='goodsreceiptdetail',
            unique_together={('goods_receipt', 'product', 'size')},
        ),
        migrations.CreateModel(
            name='BillDetail',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('quantity', models.IntegerField(default=0, validators=[django.core.validators.MinValueValidator(0)], verbose_name='Quantity')),
                ('unit_price', models.IntegerField(default=0, validators=[django.core.validators.MinValueValidator(0)], verbose_name='Unit price')),
                ('bill', models.ForeignKey(default='', on_delete=django.db.models.deletion.CASCADE, to='app_for_user.bill', verbose_name='Bill')),
                ('product', models.ForeignKey(default=2, on_delete=django.db.models.deletion.CASCADE, to='app_for_user.stock', verbose_name='Product')),
            ],
            options={
                'unique_together': {('bill', 'product')},
            },
        ),
    ]
