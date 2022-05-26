from django.urls  import path
from . import views

app_name = "app_for_admin"

urlpatterns = [
	path("chartData", views.chartData, name="chartData"),
	path("exportStock", views.exportStock, name="exportStock"),
	path("exportBill", views.exportBill, name="exportBill"),
	path("exportBillDetail", views.exportBillDetail, name="exportBillDetail"),
]
