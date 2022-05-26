from django.contrib import admin
from django.forms.widgets import TextInput
from .models import *
from django.forms import Textarea
from django.db.models.aggregates import Sum

import json
from django.core.serializers.json import DjangoJSONEncoder
from Users.affine_algo import *


class ProductInline(admin.TabularInline):
    model = Product
    fk_name = 'type'
    extra = 0

class ProductTypeAdmin(admin.ModelAdmin):
    list_display = ('id', 'type_name')

    inlines = [
        ProductInline,
    ]

class ProductAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', 'type', 'price')
    list_filter = ('type',)
    search_fields = ('name', )

class GoodsReceiptDetailAdmin(admin.ModelAdmin):
    list_display = ('id', 'getReceiptId', 'product', 'quantity', 'unit_price')
    def getReceiptId(self, obj):
        return obj.goods_receipt.id
    getReceiptId.short_description = 'Receipt ID'

class GoodsReceiptDetailInline(admin.TabularInline):
    model = GoodsReceiptDetail
    fk_name = 'goods_receipt'
    extra = 0

class VendorAdmin(admin.ModelAdmin):
    list_display = ('id', 'getName', 'getEmail', 'getPhoneNum', 'getAddress')
    search_fields = ('name', 'phone_num', )
    
    def getName(self, obj):
        return affine_decoding(obj.name, 7, 3)
    getName.short_description = 'Name'
    
    def getEmail(self, obj):
        return affine_decoding(obj.email, 7, 3)
    getEmail.short_description = 'Email'
    
    def getPhoneNum(self, obj):
        return affine_decoding(obj.phone_num, 7, 3)
    getPhoneNum.short_description = 'Phone Number'
    
    def getAddress(self, obj):
        return affine_decoding(obj.address, 7, 3)
    getAddress.short_description = 'Address'
    
class GoodsReceiptAdmin(admin.ModelAdmin):
    list_display = ("id", "deliverer", "vendor", "total_price", "date")
    readonly_fields = ('total_price', )

    inlines = [
        GoodsReceiptDetailInline,
    ]

    formfield_overrides = {
        models.CharField: {'widget': TextInput(attrs={'size':'30'})},
    }
    def get_form(self, request, obj=None, **kwargs):
        form = super(GoodsReceiptAdmin, self).get_form(request, obj, **kwargs)
        form.base_fields['deliverer'].widget.attrs['style'] = 'width: 15em;'
        form.base_fields['vendor'].widget.attrs['style'] = 'width: 15em;'
        form.base_fields['warehouse'].widget.attrs['style'] = 'width: 15em;'
        return form

class StockAdmin(admin.ModelAdmin):
    list_display = ("id", "getProductId", "product", "size", "quantity")
    search_fields = ("product__name", "id")
    list_filter = ("size",)
    ordering = ('quantity',)

    def getProductId(self, obj):
        return obj.product.id
    getProductId.short_description = 'Product ID'


    def changelist_view(self, request, extra_context=None):
        from datetime import date 
        chart_data = (
            (BillDetail.objects.filter(bill__date__year=date.today().year, bill__date__month=date.today().month).values('stock__product', 'stock__product__name').annotate(total=Sum('quantity')).order_by('-total')[:20])
        )
        as_json = json.dumps(list(chart_data), cls=DjangoJSONEncoder)
        extra_context = {"chart_data": list(chart_data)}
        return super().changelist_view(request, extra_context=extra_context)

class BillDetailInline(admin.TabularInline):
    model = BillDetail
    fk_name = 'bill'
    extra = 0
    readonly_fields = ('unit_price', )
    # exclude = ('',)

class BillAdmin(admin.ModelAdmin):
    list_display = ("customer", "date", "state", "total_price")
    search_fields = ("customer", )
    list_filter = ("state",)
    date_hierarchy = 'date'

    inlines = [
        BillDetailInline,
    ]

    def get_form(self, request, obj=None, **kwargs):
        form = super(BillAdmin, self).get_form(request, obj, **kwargs)
        form.base_fields['state'].widget.attrs['style'] = 'width: 15em;'
        return form

class BillDetailAdmin(admin.ModelAdmin):
    list_display = ("bill", "stock", "quantity", "unit_price", "getStocktId")
    search_fields = ("bill", )
    date_hierarchy = 'bill__date'
    
    def getStocktId(self, obj):
        return obj.stock.id
    getStocktId.short_description = 'Stock ID'

class WarehouseAdmin(admin.ModelAdmin):
    list_display = ("id", "name", "region", "address", "phone_num")
    search_fields = ("name", "region")
    list_filter = ("region", )

# Register your models here.
admin.site.register(ProductType, ProductTypeAdmin)
admin.site.register(Product, ProductAdmin)
admin.site.register(Stock, StockAdmin)
admin.site.register(Size)

admin.site.register(Vendor, VendorAdmin)
admin.site.register(GoodsReceipt, GoodsReceiptAdmin)
admin.site.register(GoodsReceiptDetail, GoodsReceiptDetailAdmin)

admin.site.register(Bill, BillAdmin)
admin.site.register(BillDetail, BillDetailAdmin)

admin.site.register(Warehouse, WarehouseAdmin)