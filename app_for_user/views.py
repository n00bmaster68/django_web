from django.db.models.aggregates import Sum
from django.http.response import JsonResponse
from django.shortcuts import render

from .models import *
from Users.models import Account

from django.http import HttpResponseRedirect
from django.urls import reverse

from django.contrib.auth import authenticate, login as dj_login, logout as dj_logout

from django.conf import settings

import math

# Create your views here.
def index(request):
    return render(request, "Product/home.html", {
		"best_sellers": Product.objects.filter(id__in=getBestSeller()),
		"new_arrivals": Product.objects.order_by('id')[:4]
		})

def getBestSeller():
	stock_list = Stock.objects.values('product__id').annotate(total_num=Sum('quantity')).order_by('total_num')[:4]
	ids = []
	for stock in stock_list:
		ids.append(stock['product__id'])
	return ids

def getBestSeller():
    stock_list = Stock.objects.values('product__id').annotate(total_num=Sum('quantity')).order_by('total_num')[:4]
    ids = []
    for stock in stock_list:
        ids.append(stock['product__id'])
    return ids	

def pants(request):
	return HttpResponseRedirect(reverse("app_for_user:pants_page", args=(1,)))

def pants_page(request, page_num):
	if page_num > 0 and type(page_num).__name__ == 'int':
		page_num = page_num - 1
		pants = Product.objects.filter(type__id = "2")[12*page_num:12*page_num+12]
		return  render(request, "Product/page.html", {
		"clothes": pants,
		"name": "Pants",
		"num_page": page_num + 1,
		"page_num": range(1, 1 + math.ceil(len(Product.objects.filter(type__id = "2"))/12)),
		"type": 2
	})

def t_shirts(request):
    return HttpResponseRedirect(reverse("app_for_user:shirts_page", args=(1,)))

def shirts_page(request, page_num):
	if page_num > 0 and type(page_num).__name__ == 'int':
		page_num = page_num - 1
		shirts = Product.objects.filter(type__id = "1")[12*page_num:12*page_num+12]
		return  render(request, "Product/page.html", {
		"clothes": shirts,
		"name": "T-Shirts",
		"num_page": page_num + 1,
		"page_num": range(1, 1 + math.ceil(len(Product.objects.filter(type__id = "1"))/12)),
		"type": 1
	})

def products(request):
    return HttpResponseRedirect(reverse("app_for_user:products_page", args=(1,)))

def products_page(request, page_num):
	if page_num > 0 and type(page_num).__name__ == 'int':
		page_num = page_num - 1
		clothes = Product.objects.all()[12*page_num:12*page_num+12]
		return  render(request, "Product/page.html", {
		"clothes": clothes,
		"name": "All",
		"num_page": page_num + 1,
		"page_num": range(1, 1 + math.ceil(len(Product.objects.all())/12)),
		"type": 0
	})

def productDetail(request, product_id):
	product = Product.objects.get(id = product_id)
	available_sizes = Stock.objects.filter(product__id = product_id, quantity__gt = 0).values('size__size', 'id').distinct('size__size')
	return render(request, "Product/productDetail.html", {
		"product": product,
		"available_sizes": available_sizes
	})

def currency(num):
    import locale
    locale.setlocale( locale.LC_ALL, 'vi' )
    return locale.currency(num, grouping=True).replace(",00", "")

def signInOrUp(request):
	return render(request, "Product/signin.html")

def register(request):
	if request.is_ajax() and request.method == "POST":
		email = (request.POST.get("email")).strip()
		name = (request.POST.get("name")).strip()
		password = request.POST.get("password")
		address = request.POST.get("address")
		phone = (request.POST.get("phone_num")).strip()
		sex = request.POST.get("sex")

		error_msg = []
		if len(Account.object.filter(email=email)):
			error_msg.append("<li>This email is already taken</li>")
		if len(Account.object.filter(phone_num=phone)):
			error_msg.append("<li>This phone number is already taken</li>")

		if len(error_msg) > 0:
			return JsonResponse({"result": error_msg, "status": 400}, status = 200)

		Account.object.create_user(email=email, username=name, password=password)
		new_user = Account.object.get(email=email)
		new_user.phone_num=phone 
		new_user.address=address 
		new_user.sex=sex
		new_user.save()
		return JsonResponse({"result": "succesfully create account", "status": 200}, status = 200)

def login(request):
	if request.is_ajax() and request.method == 'POST':
		email = (request.POST.get("email")).strip()
		password = request.POST.get("password")

		user = authenticate(request, username=email, password=password)

		if user is not None:
			dj_login(request, user)
			return JsonResponse({"status": 200}, status = 200)
		else:
			return JsonResponse({"msg": "Email and/or password are not valid" ,"status": 400}, status = 200)

	return HttpResponseRedirect(reverse("app_for_user:signInOrUp"))

def logout(request):
	dj_logout(request)
	return HttpResponseRedirect(reverse("app_for_user:index"))

def profile(request):
	if request.user.id:
		return render(request, "Product/profile.html")
	return HttpResponseRedirect(reverse("app_for_user:index"))

def updateProfile(request):
	if request.method == 'POST':
		# if request.POST.get('flag') == '0':
		flag = 1
		msg = []
		user = Account.object.get(pk=request.user.id)
		if user.check_password(request.POST.get('password')):
			user.address = request.POST.get('address').strip()
			user.sex = request.POST.get('sex').strip()
			user.username = request.POST.get('name').strip()

			if request.POST.get('email').strip().lower() != request.user.email: 
				if Account.object.get(email__iexact=request.POST.get('email').strip().lower()):
					msg.append("<li>This email is taken</li>")
					flag = 0
				else:
					user.email = request.POST.get('email').strip().lower()
    					
			if request.POST.get('phone_num').strip() != request.user.phone_num:
				if Account.object.get(phone_num__iexact=request.POST.get('phone_num').strip()):
					msg.append("<li>This phone number is taken</li>")
					flag = 0
				else:
					user.phone_num = request.POST.get('phone_num').strip()
			if request.POST.get('flag') == '1':
				if request.POST.get('new_pw'):
					user.set_password(request.POST.get('new_pw'))
			user.save()
		else:
			msg.append("<li>Your current password is not correct</li>")
			flag = 0

		if msg == []:
			msg.append("<li>Your information is up to date</li>")
		return JsonResponse({"msg": msg, "status": 200, "flag": flag}, status=200)
	return HttpResponseRedirect(reverse("app_for_user:profile"))

def currency(num):
    import locale
    locale.setlocale( locale.LC_ALL, 'vi' )
    return locale.currency(num, grouping=True).replace(",00", "")

def searchProduct(request):
	if request.method == 'GET' and request.GET.get("keyword") != "":
		all = Product.objects.all()
		min = int(request.GET.get("min"))
		max = int(request.GET.get("max"))

		if request.GET.get("type") != "all":
			all = all.filter(type__id=int(request.GET.get("type")))
		if min != 0 or max != 0:
			if max == 0 and min != 0:
				all = all.filter(price__gte=min)
			if min == 0 and max != 0:
				all = all.filter(price__lte=max)
			if min != 0 and max != 0:
				all = all.filter(price__lte=max, price__gte=min)
		all = all.filter(name__icontains=request.GET.get("keyword"))

		data = ''
		for product in all:
			img_url = settings.MEDIA_URL + str(product.img.name)
			data += '<div class="col4"><img src="'+ img_url + '"><h4>' + product.name +'</h4><p style="font-weight: bold; font-size: 20px">'+ currency(product.price) + '</p><a class="DetailBtn" href="/product/' + str(product.id) + '" style="text-decoration: none;">Details</a></div>'
			
		data = '<div class="row2" style="margin-top: 2%;margin-bottom: -12%">' + data + "</div>"
		return JsonResponse({"msg": "ok", "status": 200, "data": data}, status=200)
	return JsonResponse({"msg": "empty", "status": 200}, status=200)

def order(request):
	if request.method == "GET":
		quantity = int(request.GET.get('quantity'))
		stock = Stock.objects.filter(pk=int(request.GET.get('stock_id')))
		unit_price = stock[0].product.price

		if stock[0].quantity >= quantity:
			bill = None
			try:
				bill = Bill.objects.get(state=0, customer=request.user)
				print("\n\n\n\n\n\n run this")
			except:
				bill = Bill(customer=request.user, state=0)

			bill_detail = None
			try:
				bill_detail = BillDetail.objects.get(bill=bill, stock=stock[0])
				bill.total_price -= bill_detail.quantity*bill_detail.unit_price
				bill_detail.quantity = quantity + bill_detail.quantity
				bill_detail.save()
				bill.total_price += bill_detail.quantity*bill_detail.unit_price
			except:
				bill_detail = BillDetail(bill=bill, stock=stock[0], quantity=quantity, unit_price=unit_price)
			
			bill.save()
			bill_detail.save()
			return JsonResponse({"msg": "<li>Successfully, added</li>", "status": 200}, status=200)
		else:
			return JsonResponse({"msg": "<li>This product is out of stock</li>", "status": 400}, status=200)
	return HttpResponseRedirect(reverse("app_for_user:index"))

def yourCart(request):
	if request.user:
		content = ''
		total_price = 0
		try:
			bill = Bill.objects.get(customer=request.user, state=0)
			bill_details = BillDetail.objects.filter(bill=bill)
			
			i = 0
			for bill_detail in bill_details:
				i += 1
				# print("\n\n\n\n\n",bill_detail.quantity, bill_detail.unit_price, total_price)
				total_price += (bill_detail.quantity*bill_detail.unit_price)
				content += '<tr id="' + str(bill_detail.id) + 'tr"><th scope="row">' + str(i) + '</th><td>' + bill_detail.stock.product.name + '</td><td>' + bill_detail.stock.size.size + '</td><td>' + str(bill_detail.quantity) + '</td><td>' + currency(bill_detail.unit_price) + '</td><td><button type="button" class="btn btn-danger" style="margin-top: auto !important;margin-bottom: auto !important;" id="' + str(bill_detail.id) + '" onclick="deleteDetail(this.id)">Delete</button></td></tr>'
		except:
			content = 'none'
		# print(total_price, request.user.id)
		return JsonResponse({"content": content, "total": currency(total_price), "status": 200}, status=200)
	return HttpResponseRedirect(reverse("app_for_user:index"))

def deleteDetail(request):
	if request.method == "GET" and request.user:
		try:
			bill_detail = BillDetail.objects.get(pk=int(request.GET.get('bill_detail')))
			if bill_detail.bill.customer == request.user:
				total_price = bill_detail.bill.total_price - bill_detail.quantity*bill_detail.unit_price
				bill_detail.delete()
				return JsonResponse({"msg": "<li>Successfully deleted</li>", "total": currency(total_price), "status": 200}, status=200)
			else:
				return JsonResponse({"msg": "<li>This detail is not yours</li>", "status": 400}, status=200)
		except:
			return JsonResponse({"msg": "<li>Error</li>", "status": 400}, status=200)
	return HttpResponseRedirect(reverse("app_for_user:index"))

def submitOrder(request):
	if request.method == "GET" and request.user:
		try:
			if request.GET.get('address') != "":
				Bill.objects.filter(customer=request.user, state=0).update(state=1, address=request.GET.get('address'))
				return JsonResponse({"msg": "<li>Successfully order</li>", "status": 200}, status=200)
			else:
				return JsonResponse({"msg": "<li>Addres must not be empty</li>", "status": 400}, status=200)
		except:
			return JsonResponse({"msg": "<li>Error</li>", "status": 400}, status=200)
	return HttpResponseRedirect(reverse("app_for_user:index"))

def getOrder(request):
	if request.method == "GET" and request.user:
		try:
			bills = Bill.objects.filter(state__gt=0, customer=request.user).order_by('-id')
			content = ''
			for bill in bills:
				date = str(bill.date.day) + '/' + str(bill.date.month) + '/' + str(bill.date.year)
				content += '<li id="' + str(bill.id) + 'dto" onclick="showDetail(this.id)"><p><b>Date: </b>' + date + '</p><p><b>Total: </b>' + currency(bill.total_price) + '</p><p><b>State: </b>' + bill.get_state_display() + '</p></li>'
			print("\n\n\n\n\n co ne")
			return  JsonResponse({"msg": content, "status": 200}, status=200)
		except:
			print("\n\n\n\n\n khong ne")
			return  JsonResponse({"msg": "None", "status": 400}, status=200)
		print("\n\n\n\n\n\n fhe chua")
	return HttpResponseRedirect(reverse("app_for_user:index"))

def getOrderDetails(request):
	if request.method == "GET" and request.user:
		try:
			bill_details = BillDetail.objects.filter(bill__id=int(request.GET.get('bill')))
			content = ''
			i = 1
			for bill_detail in bill_details:
				content += '<tr><th scope="row">' + str(i) + '</th><td>' + bill_detail.stock.product.name + '</td><td>' + bill_detail.stock.size.size + '</td><td>' + str(bill_detail.quantity) + '</td><td>' + currency(bill_detail.unit_price) + '</td></tr>'
				i += 1
			return JsonResponse({"msg": content, "status": 200}, status=200)
		except:
			return JsonResponse({"msg": "None", "status": 400}, status=200)
	return HttpResponseRedirect(reverse("app_for_user:index"))