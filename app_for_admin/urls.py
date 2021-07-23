from django.urls  import path
from . import views

app_name = "app_for_admin"

urlpatterns = [
	path("chartData", views.chartData, name="chartData"),
	path("exportUsersXls", views.exportUsersXls, name="exportUsersXls"),
]
