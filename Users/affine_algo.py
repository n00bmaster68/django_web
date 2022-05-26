def gcd(a, b):
    while b != 0:
        a, b = b, a % b
    return a

def is_a_reversable(a, n = 10):
    if gcd(a, n) == 1:
        return True
    return False

def get_reverse_value(a, n = 10):
    for i in range(n):
        if (a * i) % n == 1:
            return i
    return None

def affine_number_encoding(plaintext, a = 7, b = 3, n = 10):
    if is_a_reversable(a):
        ciphertext = ""
        for i in plaintext:
            ciphertext += str((int(i)*a + b) % n)
        return ciphertext
    else:
        print("a is not reversable")
        return None

def affine_number_decoding(ciphertext, a = 7, b = 3, n = 10):
    plaintext = ""
    reverse_a = get_reverse_value(a)
    for i in ciphertext:
        plaintext += str((int(i) - b) * reverse_a % n)
    return plaintext

def affine_char_encoding(plaintext, a = 7, b = 3):
    if is_a_reversable(a, 26):
        ciphertext = ""
        for i in plaintext:
            if i.isalpha():
                if i.isupper():
                    ciphertext += chr(((ord(i) - 65) * a + b) % 26 + 65)
                else:
                    ciphertext += chr(((ord(i) - 97) * a + b) % 26 + 97)
            else:
                ciphertext += i
        return ciphertext
    else:
        print("a is not reversable")
        return None
    
def affine_char_decoding(ciphertext, a = 7, b = 3):
    plaintext = ""
    reverse_a = get_reverse_value(a, 26)
    for i in ciphertext:
        if i.isalpha():
            if i.isupper():
                plaintext += chr(((ord(i) - 65 - b) * reverse_a) % 26 + 65)
            else:
                plaintext += chr(((ord(i) - 97 - b) * reverse_a) % 26 + 97)
        else:
            plaintext += i
    return plaintext

def affine_encoding(plaintext, a = 7, b = 3):
    ciphertext = ""
    for i in plaintext:
        if i.isalpha():
            ciphertext += affine_char_encoding(i, a, b)
        elif i.isdigit():
            ciphertext += affine_number_encoding(i, a, b)
        else:
            ciphertext += i
    return ciphertext

def affine_decoding(ciphertext, a = 7, b = 3):
    plaintext = ""
    for i in ciphertext:
        if i.isalpha():
            plaintext += affine_char_decoding(i, a, b)
        elif i.isdigit():
            plaintext += affine_number_decoding(i, a, b)
        else:
            plaintext += i
    return plaintext