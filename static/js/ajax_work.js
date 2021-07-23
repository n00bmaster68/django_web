function include(file) { 
  
    var script  = document.createElement('script'); 
    script.src  = file; 
    script.type = 'text/javascript'; 
    script.defer = true; 
    
    document.getElementsByTagName('head').item(0).appendChild(script); 
    
} 
include("/static/js/regex.js");
include("/static/js/scripts.js");

$("#resBtn").click(function (e) {
    let email = document.getElementById('email').value;
    let name = document.getElementById('user_name1').value;
    let pw1 = document.getElementById('password1').value;
    let pw2 = document.getElementById('password2').value;
    let phoneNum = document.getElementById('phoneNumber').value;
    let address = document.getElementById('address').value;
    let sex = document.getElementById('sex').options[document.getElementById('sex').selectedIndex].value;
    let msg = "", flag = true;
    if (!checkEmail(email))
        msg += ("<li>Email must have character '@', '.', normal ones</li>");
    if (!checkName(name))
        msg += ("<li>Name only contains word characters</li>");
    if (!checkPassword(pw1))
        msg += ("<li>Password must have lower, upper character, number, special characters, the length at least 8 chars</li>"); 
    if (!(pw1 === pw2))
        msg += ("<li>Password 2 is not as same as password 1</li>");
    if (!checkAddress(address))
        msg += ("<li>Address only contains word characters, number, /</li>");
    if (!checkPhoneNum(phoneNum))
        msg += ("<li>Phone number only contains numeric characters and the first character must be '0'</li>")
    if (msg === "")
    {
        var data_inp = {
            "email": email,
            "name": name,
            "password": pw1,
            "address": address,
            "phone_num": phoneNum,
            "sex": sex,
            csrfmiddlewaretoken: $("#resBtn").data('csrf')
        }

        e.preventDefault();
        $.ajax({
            type: 'POST',
            url: $("#resBtn").data('url'),
            data: data_inp,
            success: function (response) {
                if (response['status'] == 400)
                {
                    let msg = "";
                    for (let i = 0; i < response['result'].length; i++)
                        msg += response['result'][i];
                    showAlert("<ul style='margin-bottom: -5px;'>"+ "<li class='closeX'><i class='fas fa-times' onclick='hideAlert()'></i></li>" + msg + "</ul");
                }
                else 
                    showSuccess("<ul><li class='closeX'><i class='fas fa-times' onclick='hideSuccess()'></i></li><li>Account created successfully, please login</li></ul>");
            },
            error: function (response) {
                console.log(response);
            }
        })
    }
    else 
    {
        showAlert("<ul style='margin-bottom: -5px;'>"+ "<li class='closeX'><i class='fas fa-times' onclick='hideAlert()'></i></li>" + msg + "</ul");
        setTimeout(() => {hideAlert();}, 30000);
    }
})

$("#logBtn").click(function (e) {
    let email = document.getElementById('email1').value;
    let pw1 = document.getElementById('password').value;
    let msg = "";

    if (!checkEmail(email))
        msg += ("<li>Email must have character '@', '.', normal ones</li>");
    if (!checkPassword(pw1))
        msg += ("<li>Password must have lower, upper character, number, special characters, the length at least 8 chars</li>"); 
    
    if (msg === "")
    {
        var data_inp = {
            "email": email,
            "password": pw1,
            csrfmiddlewaretoken: $("#logBtn").data('csrf')
        }
        
        e.preventDefault();
        $.ajax({
            type: 'POST',
            url: $("#logBtn").data('url'),
            data: data_inp,
            success: function (response) {
                if (response['status'] == 200)
                {
                    window.location.href = "/";
                }
                else 
                {
                    showAlert("<ul style='margin-bottom: -5px;'>"+ "<li class='closeX'><i class='fas fa-times' onclick='hideAlert()'></i></li>" + response['msg'] + "</ul");
                    setTimeout(() => {hideAlert();}, 30000);
                }
            },
            error: function (response) {
                console.log(response)
            }
        })
    }
    else 
    {
        showAlert("<ul style='margin-bottom: -5px;'>"+ "<li class='closeX'><i class='fas fa-times' onclick='hideAlert()'></i></li>" + msg + "</ul");
        setTimeout(() => {hideAlert();}, 30000);
    }
})

$("#updateBtn").click(function (e) {
    if (document.getElementById('Cpassword').value === "")
    {
        showAlert("<ul style='margin-bottom: -5px;'>"+ "<li class='closeX'><i class='fas fa-times' onclick='hideAlert()'></i></li><li>" + "Please insert your current password before update information" + "</li></ul");
        setTimeout(() => {hideAlert();}, 30000);
    }
    else
    {
        let email = document.getElementById('email3').value;
        let name = document.getElementById('user_name3').value;
        let pw1 = document.getElementById('Cpassword').value;
        let pw2 = document.getElementById('Npassword').value;
        let phoneNum = document.getElementById('phone').value;
        let address = document.getElementById('Caddress').value;
        let sex = document.getElementById('sex2').options[document.getElementById('sex2').selectedIndex].value;
        let msg = "", flag = 0;
        if (!checkEmail(email))
            msg += ("<li>Email must have character '@', '.', normal ones</li>");
        if (!checkName(name))
            msg += ("<li>Name only contains word characters</li>");
        if (!checkPassword(pw1))
            msg += ("<li>Password must have lower, upper character, number, special characters, the length at least 8 chars</li>"); 
        if (pw2 !== "")
        {
            if (!checkPassword(pw2))
                msg += ("<li>New password must have lower, upper character, number, special characters, the length at least 8 chars</li>");
            flag = 1;
        }
        if (!checkAddress(address))
            msg += ("<li>Address only contains word characters, number, /</li>");
        if (!checkPhoneNum(phoneNum))
            msg += ("<li>Phone number only contains numeric characters and the first character must be '0'</li>")
        if (msg === "")
        {
            var data_inp = {
                "email": email,//
                "name": name,
                "password": pw1,//
                "new_pw": pw2,//
                "address": address,
                "phone_num": phoneNum,//
                "sex": sex,
                "flag": flag,
                csrfmiddlewaretoken: $("#updateBtn").data('csrf')
            }

            e.preventDefault();
            $.ajax({
                type: 'POST',
                url: $("#updateBtn").data('url'),
                data: data_inp,
                success: function (response) {
                        if (response['flag'] == 0)
                        {
                            let msg = "";
                            for (let i = 0; i < response['msg'].length; i++)
                                msg += response['msg'][i];
                            showAlert("<ul style='margin-bottom: -5px;'>"+ "<li class='closeX'><i class='fas fa-times' onclick='hideAlert()'></i></li>" + msg + "</ul");
                        }
                    else 
                    {
                        if (flag == 1)
                            response['msg'][0] += "<li>Please login again because you've just update your password</li>"
                        showSuccess("<ul><li class='closeX'><i class='fas fa-times' onclick='hideSuccess()'></i></li>" + response['msg'][0] + "</ul>");
                    }
                    console.log(response);
                },
                error: function (response) {
                    console.log(response);
                }
            })
        }
        else 
        {
            showAlert("<ul style='margin-bottom: -5px;'>"+ "<li class='closeX'><i class='fas fa-times' onclick='hideAlert()'></i></li>" + msg + "</ul");
            setTimeout(() => {hideAlert();}, 30000);
        }
    }
})

var curr_key = "";
var curr_min = 0;
var curr_max = 0;
var curr_type = "";

function search()
{
    if ($('#input').val() !== "" && ($('#input').val() !== curr_key || Number($('#max_value').val()) !== curr_max || Number($('#min_value').val()) !== curr_min || curr_type !== $("#product_type").children("option:selected").val()))
    {
        
        var min = Number($('#min_value').val());
        var max = Number($('#max_value').val());
        var key_word = $('#input').val();
        var type = $("#product_type").children("option:selected").val();

        curr_min = min;
        curr_max = max;
        curr_type = type;
        curr_key = key_word;

        var data = {
            "keyword" : key_word,
            "min": min,
            "max": max,
            "type": type
        };

        if (key_word !== "")
        {
            $.ajax({
            type : 'GET',
            data : data,
            url : $("#input").data('url'),
            success : function (response){
                    // console.log(response);
                    $("#search_result").html(response['data']);
                }
            });
        }
    }
}

$(document).ready(function()
{
    var timeout = null;
    $('#max_value').keyup(function()
    {
        clearTimeout(timeout);
        timeout = setTimeout(search(), 400);
        console.log("max");
    });
});

$(document).ready(function()
{
    var timeout = null;
    $('#min_value').keyup(function()
    {
        clearTimeout(timeout);
        timeout = setTimeout(search(), 400);
        console.log("min");

    });
});

$(document).ready(function()
{
    var timeout = null;
    $('#input').keyup(function()
    {
        clearTimeout(timeout);
        timeout = setTimeout(search(), 400);
        // console.log("tao ne");
    });
});

$('#product_type').change(function()
{
    search();
    console.log("type");
});

$("#order_detail").click(function (e) {
    console.log('dmm chay ne order_detail');
    let stock_id = $("#size").children("option:selected").val();
    let quantity = $("#quantity").val()
    console.log(stock_id, quantity);
    
    var data_inp = {
        "stock_id": stock_id,
        "quantity": quantity
    }
        
    e.preventDefault();
    $.ajax({
        type: 'GET',
        url: $("#order_detail").data('url'),
        data: data_inp,
        success: function (response) {
            if (response['status'] == 200)
            {
                showSuccess("<ul><li class='closeX'><i class='fas fa-times' onclick='hideSuccess()'></i></li>" + response['msg'] + "</ul>");
                console.log("DMM", response);
            }
            else 
            {
                showAlert("<ul style='margin-bottom: -5px;'>"+ "<li class='closeX'><i class='fas fa-times' onclick='hideAlert()'></i></li>" + response['msg'] + "</ul");
                setTimeout(() => {hideAlert();}, 30000);
            }
            console.log("DMM2", response);
        },
        error: function (response) {
            console.log(response)
        }
    })  
})


$("#your_cart").click(function (e) {  
    console.log('your_cart tao chay ne');  
    e.preventDefault();
    $.ajax({
        type: 'GET',
        url: $("#your_cart").data('url'),
        data: {},
        success: function (response) {
            if (response['content'] != 'none')
            {
                $('#content').html(response['content']);
                $('#total').html('Total: ' + response['total']);
                document.getElementById('order_div').hidden = false;
                console.log(response);
            }
            console.log(response);
        },
        error: function (response) {
            console.log(response)
        }
    })  
})

function deleteDetail(id)
{
    console.log("deleteDetail");
    if (confirm("Are you sure?"))
    {
        $.ajax({
            type: 'GET',
            url: '/deleteDetail/',
            data: {"bill_detail": id},
            success: function (response) {
                if (response['status'] == 200)
                {
                    showSuccess("<ul><li class='closeX'><i class='fas fa-times' onclick='hideSuccess()'></i></li>" + response['msg'] + "</ul>");
                    document.getElementById(id + "tr").hidden = true;
                    $('#total').html('Total: ' + response['total']);
                    console.log(response);
                }
                else
                showAlert("<ul style='margin-bottom: -5px;'>"+ "<li class='closeX'><i class='fas fa-times' onclick='hideAlert()'></i></li>" + response['msg'] + "</ul");


            },
            error: function (response) {
                console.log(response)
            }
        })  
    }
}

$("#order_submit").click(function (e) {    
    console.log("order_submit");
    e.preventDefault();
    $.ajax({
        type: 'GET',
        url: $("#order_submit").data('url'),
        data: {'address': $('#address').val()},
        success: function (response) {
            if (response['status'] == 200)
            {
                $('#content').html('');
                showSuccess("<ul><li class='closeX'><i class='fas fa-times' onclick='hideSuccess()'></i></li>" + response['msg'] + "</ul>");
                document.getElementById('order_div').hidden = true;
            }
            else
                showAlert("<ul style='margin-bottom: -5px;'>"+ "<li class='closeX'><i class='fas fa-times' onclick='hideAlert()'></i></li>" + response['msg'] + "</ul");
        },
        error: function (response) {
            console.log(response)
        }
    })  
})

$("#your_order").click(function (e) { 
    console.log("tao co chay order");
    e.preventDefault();
    $.ajax({
        type: 'GET',
        url: $("#your_order").data('url'),
        data: {},
        success: function (response) {
            $('#MyOrder').html(response['msg']);
            console.log($("#your_order").data('url'));
            yourOrder();
        },
        error: function (response) {
            console.log(response)
        }
    })  
})

function showDetail(id)
{
    $.ajax({
        type: 'GET',
        url: '/getOrderDetails/',
        data: {'bill': id.replace("dto", "")},
        success: function (response) {
            $('#content2').html(response['msg']);
            document.getElementById('detail_table').hidden = false;
        },
        error: function (response) {
            console.log(response)
        }
    })
}

$('#closeTable').click(function (e) {  
    document.getElementById('detail_table').hidden = true;
})