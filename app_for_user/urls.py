from django.urls  import path
from . import views

app_name = "app_for_user"

urlpatterns = [
	path("", views.index, name="index"),
	path("pants/", views.pants, name="pants"),
	path("pants/<int:page_num>", views.pants_page, name="pants_page"),
	path("t_shirts/", views.t_shirts, name="t_shirts"),
	path("shirts/<int:page_num>", views.shirts_page, name="shirts_page"),
	path("products/", views.products, name="products"),
	path("products/<int:page_num>", views.products_page, name="products_page"),
	path("product/<int:product_id>", views.productDetail, name="productDetail"),

	path("signInOrUp/", views.signInOrUp, name="signInOrUp"),
	path("profile/", views.profile, name="profile"),
	path("register/", views.register, name="register"),
	path("login/", views.login, name="login"),
	path("logout/", views.logout, name="logout"),
	path("updateProfile/", views.updateProfile, name="updateProfile"),
	
	path("searchproduct/", views.searchProduct, name="searchProduct"),
	path("order/", views.order, name="order"),
	path("yourCart/", views.yourCart, name="yourCart"),
	path("deleteDetail/", views.deleteDetail, name="deleteDetail"),
	path("submitOrder/", views.submitOrder, name="submitOrder"),
	path("getOrder/", views.getOrder, name="getOrder"),
	path("getOrderDetails/", views.getOrderDetails, name="getOrderDetails"),
]
