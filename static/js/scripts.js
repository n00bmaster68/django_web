var mybutton = document.getElementById("BtnTop");
window.onscroll = function() {scrollFunction()};

function scrollFunction() 
{
	if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20)
	{
		mybutton.style.display = "block";
	} 
	else 
	{
		mybutton.style.display = "none";
	}
}

function topFunction() 
{
		document.body.scrollTop = 0;
		document.documentElement.scrollTop = 0;
}

var login = document.getElementById("login");
var register = document.getElementById("register");
var indicator = document.getElementById("indicator");
var form = document.getElementsByClassName("form-container");

function Register()
{
	register.style.transform = "translate(0px)";
	login.style.transform = "translate(0px)";
	indicator.style.transform = "translate(110px)";
	form[0].style.height = "510px";
}

function Login()
{
	register.style.transform = "translate(298px)";
	login.style.transform = "translate(298px)";
	indicator.style.transform = "translate(0px)";
	form[0].style.height = "285px";
}

var MenuItems = document.getElementById("MenuItems");
MenuItems.style.maxHeight = "0px";

function menutoggle()
{
	if  (MenuItems.style.maxHeight == "0px")
	{
		MenuItems.style.maxHeight = "430px";
		// MenuItems.style.height = "430px";
	}

	else
	{
		console.log("dmm la sao ba");
		MenuItems.style.maxHeight = "0px";
	}
}

function quantitydown()
{
	if(document.getElementById('quantity').value > 1)
	   	document.getElementById('quantity').value--;
}

function quantityup()
{
	document.getElementById('quantity').value++;
}

function hideAlert()
{
	document.getElementById("error").hidden = true;
}

function showAlert(msg)
{
	document.getElementById("error").innerHTML = msg;
	document.getElementById("error").hidden = false;
}

function showSuccess(msg)
{
	document.getElementById("success").hidden = false;
	document.getElementById("success").innerHTML = msg;
	setTimeout(() => {document.getElementById("success").hidden = true;}, 20000);
}

function hideSuccess()
{
	document.getElementById("success").hidden = true;
}

function showUser()
{
	document.getElementById("hidden").hidden = false;
	setTimeout(() => {document.getElementById("hidden").hidden = true;}, 10000);
}

function openSearchForm() 
{
	document.getElementById("search").style.width = "100%";
}

function closeSearchForm() 
{
	document.getElementById("search").style.width = "0%";
}

function openCart()
{
	menutoggle();
	document.getElementById('cart').style.top = "0%";
}

function closeCart()
{
	document.getElementById('cart').style.top = "-600%";
}

function yourOrder()
{
	menutoggle()
	document.getElementById('order').style.top = "0%";
}

function closeOrder()
{
	document.getElementById('order').style.top = "-600%";
}

function closeBillDetail()
{
	document.getElementById('order_detail').hidden = true;
}