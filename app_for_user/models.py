from django.db import models
from django.core.validators import MaxValueValidator, MinValueValidator, RegexValidator
from Users.models import Account

phone_regex = RegexValidator("^0\d{8,10}$", "your phone number is not valid")
BILL_STATE = (
    ('0', 'Not submitted'),
	('1', 'Processing'),
	('2', 'Delivering'),
    ('3', 'Received'),
    ('4', 'Cancel')
	)
# Create your models here.

### PRODUCT ####
class ProductType(models.Model):
    id = models.AutoField(primary_key=True)
    type_name = models.CharField(max_length=20, unique=True, verbose_name="Type name")

    class Meta:
        verbose_name = 'Product type'

    def __str__(self):
        return f"{self.type_name}"

class Product(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=50, verbose_name="Name", default='')
    price = models.IntegerField(verbose_name='Price', default=0, validators=[MinValueValidator(0),])
    type = models.ForeignKey(ProductType, on_delete=models.CASCADE)
    img = models.ImageField(verbose_name="Image", upload_to="productImg/")
    
    def __str__(self):
        return f"{(self.name).title()}"

class Size(models.Model):
    id = models.AutoField(primary_key=True)
    size = models.CharField(max_length=10, unique=True)

    def __str__(self):
        return (self.size).upper()

class Stock(models.Model):
    id = models.AutoField(primary_key=True)
    product = models.ForeignKey(Product, on_delete=models.PROTECT)
    size = models.ForeignKey(Size, on_delete=models.PROTECT)
    quantity = models.IntegerField(default=0, validators=[MinValueValidator(0),])

    class Meta():
        unique_together = ["product", "size"]

    def __str__(self):
        return str(self.product) + " - " + str(self.size)
    
    def getPrice(self):
        return self.product.price
    
    def setQuantity(self, quantity):
        self.quantity = quantity
        self.save()

### END PRODUCT ###


### VENDOR ###
class Vendor(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=50, verbose_name="Name", unique=True)
    email = models.EmailField(verbose_name='email address', max_length=255,unique=True)
    phone_num = models.CharField(max_length=10, verbose_name="Phone number", validators=[phone_regex], null=True, unique=True)
    address = models.CharField(max_length=100, verbose_name="Address", unique=True)
    
    def __str__(self):
        return f"{self.name}"

class GoodsReceipt(models.Model):
    id = models.AutoField(primary_key=True)
    deliverer = models.CharField(max_length=100, verbose_name="Deliverer name")
    vendor = models.ForeignKey(Vendor, verbose_name="Vendor", default='', on_delete=models.PROTECT)
    total_price = models.IntegerField(verbose_name='Total price', default=0, validators=[MinValueValidator(0),])
    date = models.DateTimeField (verbose_name="Date\Time", auto_now_add=True)

    class Meta:
        verbose_name = 'Goods receipt'

class GoodsReceiptDetail(models.Model):
    id = models.AutoField(primary_key=True)
    goods_receipt = models.ForeignKey(GoodsReceipt, verbose_name="Goods receipt ID", default='', on_delete=models.PROTECT)
    product = models.ForeignKey(Product, verbose_name="Product ID", default='', on_delete=models.PROTECT)
    quantity = models.IntegerField(verbose_name='Quantity', default=1, validators=[MinValueValidator(1),])
    unit_price = models.IntegerField (verbose_name="Unit price", default=0, validators=[MinValueValidator(0),])
    size = models.ForeignKey(Size, verbose_name="Product size", on_delete=models.PROTECT, default='')

    class Meta:
        verbose_name = 'Goods receipt detail'
        unique_together = ['goods_receipt', 'product', 'size']
### END VENDOR ###

### BILL ###
class Bill(models.Model):
    id = models.AutoField(primary_key=True, verbose_name="Bill id")
    customer = models.ForeignKey(Account, on_delete=models.PROTECT, default="", verbose_name="Customer")
    date = models.DateTimeField(verbose_name="Date", auto_now_add=True)
    state = models.CharField(max_length=20, verbose_name="State", choices=BILL_STATE, default="Not submitted")
    address = models.CharField(max_length=150, default="", blank=True)
    total_price = models.IntegerField(verbose_name="Total", default=0, validators=[MinValueValidator(0),])

    def __str__(self):
        return f"{self.id}"

    def getDate(self):
        return str(self.date.day) + "/" + str(self.date.month) + "/" + str(self.date.year)

class BillDetail(models.Model):
    id = models.AutoField(primary_key=True)
    bill = models.ForeignKey(Bill, verbose_name="Bill", on_delete=models.CASCADE, default="")
    product = models.ForeignKey(Stock, verbose_name="Product", on_delete=models.CASCADE, default=2)
    quantity = models.IntegerField(verbose_name="Quantity", default=0, validators=[MinValueValidator(0),])
    unit_price = models.IntegerField(verbose_name="Unit price", default=0, validators=[MinValueValidator(0),])

    class Meta:
        unique_together = ['bill', 'product']
        
### End bill ###