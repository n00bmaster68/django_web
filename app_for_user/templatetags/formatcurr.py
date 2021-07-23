from django import template
import locale

register = template.Library()

def currency(num):
    locale.setlocale( locale.LC_ALL, 'vi' )
    return locale.currency(num, grouping=True).replace(",00", "")

def getRange(num):
    return range(4*num, 4*num + 4)

def getName(name):
    return (name.split(" ")[-1:])[0]

register.filter('currFormat', currency)
register.filter('getRange', getRange)
register.filter('getName', getName)