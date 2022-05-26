from django.db.models.aggregates import Sum
from django.http.response import HttpResponse, HttpResponseRedirect, JsonResponse
from django.urls.base import reverse
from app_for_user.models import BillDetail  
import xlwt

# Create your views here.
def chartData(request):
    if request.is_ajax() and request.method == "GET":
        if request.user.is_staff:
            data = BillDetail.objects.filter(bill__date__year=request.GET.get('year'), bill__date__month=request.GET.get('month')).values('stock__product', 'stock__product__name').annotate(total=Sum('quantity')).order_by('-total')[:20]
            return JsonResponse({"data": list(data), "status": 200}, status=200)
        return JsonResponse({"data": None, "status": 400}, status=200)
    return HttpResponseRedirect(reverse("app_for_user:index"))

def formatDate(d, m, y):
    return str(d) + "/" + str(m) + "/" + str(y)

def exportStock(request):

    print("\n\n\n\n\n\n", request.GET["month_year"]);
    if request.user.is_staff:
        response = HttpResponse(content_type='application/ms-excel')
        response['Content-Disposition'] = f'attachment; filename="sale_report{request.GET["month_year"]}.xls"'

        wb = xlwt.Workbook(encoding='utf-8')
        ws = wb.add_sheet('Bill detail')

        # Sheet header, first row
        row_num = 0

        font_style = xlwt.XFStyle()
        font_style.font.bold = True

        columns = ['Bill id', 'Date', 'Stock', 'Size', 'Quantity', 'Unit price']

        for col_num in range(len(columns)):
            ws.write(row_num, col_num, columns[col_num], font_style) # at 0 row 0 column 

        # Sheet body, remaining rows
        font_style = xlwt.XFStyle()

        monthYear = (str(request.GET["month_year"])).split('-')
        rows = []
        data = BillDetail.objects.filter(bill__date__month=int(monthYear[1]), bill__date__year=int(monthYear[0])).values_list('bill__id','bill__date__day','bill__date__month', 'bill__date__year','stock__product', 'stock__size', 'quantity', 'unit_price')
        for d in data:
            rows.append((d[0], formatDate(d[1], d[2], d[3]), d[4], d[5], d[6], d[7]))

        for row in rows:
            row_num += 1
            for col_num in range(len(row)):
                ws.write(row_num, col_num, row[col_num], font_style)

        wb.save(response)

        return response
    
def exportBill(request):
    if request.user.is_staff:
        response = HttpResponse(content_type='application/ms-excel')
        response['Content-Disposition'] = f'attachment; filename="sale_report{request.GET["month_year"]}.xls"'

        wb = xlwt.Workbook(encoding='utf-8')
        ws = wb.add_sheet('Bill detail')

        # Sheet header, first row
        row_num = 0

        font_style = xlwt.XFStyle()
        font_style.font.bold = True

        columns = ['BILL', 'CUSTOMER', 'ADDRESS', 'DATE', 'TOTAL', 'COST PRICE', 'PROFIT']

        for col_num in range(len(columns)):
            ws.write(row_num, col_num, columns[col_num], font_style) # at 0 row 0 column 

        # Sheet body, remaining rows
        font_style = xlwt.XFStyle()

        monthYear = (str(request.GET["month_year"])).split('-')
        rows = []
        from django.db import connection
        with connection.cursor() as cursor:
            query = "SELECT bill.id BILL, bill.customer_id CUSTOMER, bill.address ADDRESS, to_char(bill.date, 'YYYY-MM-DD') DATE, bill.total_price TOTAL, SUM(rede.unit_price*billde.quantity) COST_PRICE, SUM((billde.unit_price-rede.unit_price)*billde.quantity) PROFIT FROM app_for_user_bill bill, app_for_user_billdetail billde, app_for_user_goodsreceiptdetail rede, app_for_user_stock stock  WHERE EXTRACT(YEAR FROM bill.date)=" + monthYear[0] + " AND EXTRACT(MONTH FROM bill.date)= " + monthYear[1] + "AND bill.state='2' AND bill.id = billde.bill_id AND billde.stock_id = stock.id AND stock.receipt_detail_id = rede.id GROUP BY bill.id, bill.total_price"
            cursor.execute(query)
            data = cursor.fetchall()

        for d in data:
            rows.append((d[0], d[1], d[2], d[3], d[4], d[5], d[6]))

        for row in rows:
            row_num += 1
            for col_num in range(len(row)):
                ws.write(row_num, col_num, row[col_num], font_style)

        wb.save(response)

        return response
    
def exportBillDetail(request):
    if request.user.is_staff:
        response = HttpResponse(content_type='application/ms-excel')
        response['Content-Disposition'] = f'attachment; filename="Bill_Detail{request.GET["month_year"]}.xls"'

        wb = xlwt.Workbook(encoding='utf-8')
        ws = wb.add_sheet('Bill detail')

        # Sheet header, first row
        row_num = 0

        font_style = xlwt.XFStyle()
        font_style.font.bold = True

        columns = ['BILL', 'STOCK', 'PRICE', 'COST PRICE', 'QUANTITY', 'PROFIT']

        for col_num in range(len(columns)):
            ws.write(row_num, col_num, columns[col_num], font_style) # at 0 row 0 column 

        # Sheet body, remaining rows
        font_style = xlwt.XFStyle()

        monthYear = (str(request.GET["month_year"])).split('-')
        rows = []
        from django.db import connection
        with connection.cursor() as cursor:
            query = "SELECT bill.id BILL, billde.stock_id STOCK, billde.unit_price PRICE, rede.unit_price COST_PRICE, billde.quantity QUANTITY, (billde.unit_price-rede.unit_price)*billde.quantity PROFIT FROM app_for_user_bill bill, app_for_user_billdetail billde, app_for_user_goodsreceiptdetail rede, app_for_user_stock stock WHERE EXTRACT(YEAR FROM bill.date)=" + monthYear[0] + " AND EXTRACT(MONTH FROM bill.date)= " + monthYear[1] + " AND bill.state='2' AND bill.id = billde.bill_id AND billde.stock_id = stock.id AND stock.receipt_detail_id = rede.id GROUP BY bill.id, billde.stock_id, billde.unit_price, billde.quantity, rede.unit_price;"
            cursor.execute(query)
            data = cursor.fetchall()

        for d in data:
            rows.append((d[0], d[1], d[2], d[3], d[4], d[5]))

        for row in rows:
            row_num += 1
            for col_num in range(len(row)):
                ws.write(row_num, col_num, row[col_num], font_style)

        wb.save(response)

        return response