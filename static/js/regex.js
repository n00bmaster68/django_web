function checkAddress(address)
{
    if (address === "")
        return false;
    var addReg = /^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ\s\d\W|_{/}]+$/;
    return addReg.test(address);
}

function checkName(name)
{
    if (name === "")
        return false;
    var nameReg = /^(?=[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ\s\W-|_/]+$)(?!.*[<>'"/;`%?!#$%@'"+-=])/;
    return nameReg.test(name);
}

function checkEmail(email)
{
    if (email === "")
        return false;
    var emailReg = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;
    return emailReg.test(email);
}

function checkPhoneNum(num)
{
    if (num === "")
        return false;
    var numReg = /(0[1-9])+([0-9]{8})\b/
    return numReg.test(num);
}

function checkPassword(pw)
{
    if (pw === "")
        return false;
    var pwReg = /^(?=.*?[A-Z])(?=.*?[0-9]).{1,}$/;
    if (pwReg.test(pw))
        return true;
    
    var pwReg = /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$/;
    return pwReg.test(pw);
}

function isNumeric(str) 
{
    if (typeof str != "string") return false // we only process strings!  
    return !isNaN(str) && // use type coercion to parse the _entirety_ of the string (`parseFloat` alone does not do this)...
           !isNaN(parseFloat(str)) // ...and ensure strings of whitespace fail
}

// export{checkAddress, checkEmail, checkName, checkPhoneNum, checkPassword};

    // console.log("check email", checkEmail(document.getElementById('email').value));
    // console.log("check name", checkName(document.getElementById('user_name1').value));
    // console.log("check password 1", checkPassword(document.getElementById('password1').value));
    // console.log("check password 2", checkPassword(document.getElementById('password2').value));
    // console.log("check phoneNumber", checkPhoneNum(document.getElementById('phoneNumber').value));
    // console.log("check address", checkAddress(document.getElementById('address').value));