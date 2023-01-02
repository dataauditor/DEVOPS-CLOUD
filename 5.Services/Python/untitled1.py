# Temel

print('Hi')
type(9)
type(9.2)



# Sayilar

type("123")
'a' + 'b'
'a' 'b'
'a' '  b'
'a'*3
type(100)                      # int
type(10.2)                     # float
type(1+2j)                     # complex



# Variables
gel_yaz = ("gelecegi yazanlar")
len("gelecegi yazanlar")
len('1 a')
a = "gelecegi yazanlar"

b = 9
c = 10
c*b
# del a



# len()

len(gel_yaz)



# String Metodlari

gel_yaz.upper()
gel_yaz.capitalize()           # ilk harfi buyuk yapar.
gel_yaz.lower()
gel_yaz.islower()              # harfler kucuk mu true/false doner.
gel_yaz.isupper()

e = gel_yaz.upper()
e.islower()
e.isupper()

gel_yaz.replace('e', 'a')      # degisiklik kalici degil kaydetmelisin.
A = gel_yaz.replace('e', 'a')  # degisikligi kaydetmek istersek atariz. 
gel_yaz.replace('a',"i")

a = '  uykum geldi   '
a.strip()                      # bosluklari siler
b = "***uykum geldi*  "
b.strip('*')                   # *'lari siler. Sag tarafta *'dan once bosluk var. *'i silemez.
c="lgelecek umarimll"
c.strip("l")



# Metodlara Genel Bakis

dir(gel_yaz)                   # elimizdeki veriye yonelik uygulanabilecek metodlari gosterir.
gel_yaz.title()                # "." kullanilabilecek metodlari gosterir.



# Substring

gel_yaz[0]
gel_yaz[1]
gel_yaz[-1]                    # son indexi verir.
gel_yaz[0:3]                   # ilk 3 index
gel_yaz[3:7]



# Variables
 
a = 2
b = 3
a+b
c=a+b
d="hadi gidelim"
a/b
 


# Type Donusumu, input() 

     # Kullanicidan alinan degerler on tanimli olarak string olarak gelir.

birinci_sayi=input()           # kullanicidan deger alir. 3
ikinci_sayi = input()          # iki sayiyi girmemizi bekler ekrandan. 4

type(birinci_sayi)             # str 

birinci_sayi + ikinci_sayi     # 34.Sayilari string gibi yanyana getirdi, toplamadi.
int(birinci_sayi) + int(ikinci_sayi) # 7

int(11.3)                      # 11
float(12)                      # 12.0
type(str(12))                  # str




# print() 

print("hello ai era")
print("gelecegi","yazanlar")   # gelecegi yazanlar
print("ilk","adim", sep="_")   # "ilk_adim"  sep argumani ile baska ara deger tanimlanabilir.

print()

"10" + 2                       # hata verir.




# Veri Yapilari
  # Liste
  # Tuple
  # Dictionary
  # Set
  
  
  
  
# Liste
  # Degistirilebilir.
  # Farkli type verileri bir arada tutabilir. Kapsayicidir.
  # Siralidir. Index islemi yapilabilir.

  # Iki usulle liste olusturulabilir: []  veya list()

evler = ["ankara", "istanbul"]  
notlar = [90, 80, 40, 70]
type(notlar)                 # list

liste = ["a",19.4,90,notlar]
len(liste)                   # 4
type(liste[0])               # str
type(liste[1])               # float
type(liste[3])               # list
birlesik = [liste, evler] 
del birlesik

liste = [10,20, 30,40, 50]
liste[1]
liste[1:3]
liste[:3]
liste[2:]
liste2 = ["a",10,[20,30,40,50]]
liste2[2]
liste2[1:3]                  # [10, [20, 30, 40, 50]]
liste2[2][1]                 # 30

liste3 = ["ali", "veli", "berkcan", "ayse"]
liste3[1] = "kemal"          # degisiklik yaptik.
print(liste3)

liste3[:3] = "alinin_babasi", "velinin_babasi", "mertcanin_babasi"
                             # coklu degisiklik.
liste3 + ["umit"]            # ekleme (gecici)  ['alinin_babasi', 'velinin_babasi', 'mertcanin_babasi', 'ayse', 'umit']
liste3 = liste3 + ["umit"]
liste3

del liste3[2]                # index silme

dir(liste3)

liste = ["ali", 1, 2, "mehmet"]
liste
liste.append(11)             # ekleme kalicidir.
liste.remove("ayse2")        # ismen siler.
liste.insert(1, "ayse")      # ekleme kalicidir. Mevcut konumdaki veri saga kayar silinmez.
liste[3] = "mehmet"          # degisiklik yapar ekleme yerine.

liste.insert(len(liste), "beren")  # sona ekleme yapar.

liste.insert(-1, "murat2")    # en sondan bir onceye ekleme yapar.
liste.pop(4)                  # 4. indexi siler.
liste.count("murat")          # 1

liste_yedek = liste.copy()    # ilgili listeyi yedeklemek icin kullanilir.

     # Liste Birlestirme
liste.extend(["a", "b", 10])  # mevcut liste ile verilen listeyi birlestirir.
                              # ["ali", 1, 2, "mehmet", "a", "b", 10]
liste.index("mehmet")         # index numarasi verir.

liste4 = [10,40,5,90]
liste4
liste4.reverse()               # listeyi tersten yazar.

liste4.sort()                  # kucukten buyuge siralar.

liste4.clear()                 # listenin icini siler.




# Tuple
  # Degistirilemez.
  # Farkli type verileri bir arada tutabilir. Kapsayicidir.
  # Siralidir. Index islemi yapilabilir.
  
  # Iki turlu olusturulabilir: () ile veya parantezsiz olarak.
  
t = ("ali", "veli", 1,2,3.2,[1,2,3,4])
t = "ali", "veli", 1,2,3.2,[1,2,3,4]

t = ("eleman")
type(t)                        # tek elemanli tuple'larda icindeki verinin type'ini verir.
t = ("eleman",)
type(t)                        # tuple. Sona virgul koyarak saglanir.

   # Eleman islemleri liste'lerle ayni sekilde gerceklesir.
t = "ali", "veli", 1,2,3.2,[1,2,3,4]
t[1] 
t[:3]




# Sozluk:
  # Degistirilebilir.
  # Kapsayici.
  # Sirasizdir.
  
  # Key ve value seklinde kullanilir. Siralama seklinde index olmaz ama key uzerinden index olur.

sozluk = {"reg": "Regresyon modeli", "Loj": "Lojistik regresyon"}
len(sozluk)                     # 2 

sozluk = {"reg": 10,
          "loj": 20,
          "cart": 30}

sozluk = {"reg": [10,"RMSE"],
          "loj": [20, 40],
          "cart": 30,
          1: 40,
          3: "deneme"}

sozluk["reg"][1]




# SET
  # Kumeler.
  # Degerler essizdir. Dergerler tekrarlamaz.
  # Degistirilebilir.
  # Sirasizdir. Index islemini desteklemez.

t = ("a", "ali")
s = set(t)
ali = " lutfen_ata_bakma_uzaya_git_ali"
type(ali)
set(ali)                        # bosluk dshil hersey tek bir karakter olur.

dir(s)




# Fonksiyon Okuryazaligi:
    
dir(print)
print("a","b","c",sep="_")




# Fonksiyonlar:

def kare_al(x):
    print(x**2)
    
kare_al(3)

def kare_al(x):
    print("Girilen sayinin karesi: " + str(x**2))

kare_al(3)

def kare_al(x):
    print("Girilen sayi: " + 
          str(x) + 
          ",  Karesi: " +
          str(x**2))

kare_al(3)



  # Iki Argumanli Fonksiyonlar:

def carpma(x,y):
    print(x*y)
    
carpma(2,3)




  # On Tanimli Argumanlar:
    
?print

def carpma(x,y = 1):
    print(x*y)
    
carpma(3)
carpma(3,4)


  
  # Argumanlarin Siralamasi:
  
      # Fonksiyonun argumanlarinin sirasini bilmiyorsak ve onemli ise dogrudan argumanlara atama yapariz.
def carpma(x,y = 1):
    print(x*y)
    
carpma(y=3, x=4)




  # Ne Zaman Fonksiyon Yazilir:
      
      # Isi, nem, sarj durumu ihtiyaci varsa sokak lambalarina yonelik.
      
(40+25)/90

def direk_hesap(isi, nem, sarj):
    print((isi + nem)/sarj)
    
direk_hesap(20, 10, 150)

  


  # Fonksiyonun Ciktisini Girdi Olarak Kullanmak:
      
      # Fonksiyon "return" satirinin altina inmez. Bu yuzden en alt satirda return olmali.
      
def direk_hesap(isi, nem, sarj):
    return((isi + nem)/sarj)

direk_hesap(40, 50,4)*9
cikti = direk_hesap(11, 34, 45)
print(cikti)




  # Local ve Global Degiskenler:
      
x = 10                  # Global
y = 20

def carpma(x,y=5):      # Buradaki degiskenler local, gecici degiskenlerdir.
    return(x*y)

carpma(2)
carpma(2,5)



  # Local Etki Alanindan Global Etki Alanini Degistirmek:
      
      # Localden globaldeki degiskenleri degistiririz.
      # Fonksiyon once local etki alaninda degiskenleri arar bulamazsa Global'de bakar.
      
x = [] 
# del x
def eleman_ekle(y):      # Local degisken
    x.append(y)          # Global degisken
    print(str(y) + " ifadesi eklendi")

eleman_ekle(11)
eleman_ekle("ali")
eleman_ekle("veli")
x




# Karar Kontrol (Kosul) Yapilari


  #True-False Sorgulamalari:
      
sinir = 500
sinir == 4000             # mi) False doner.
sinir == 500              # True

5 == 4 




# IF

sinir = 50000             # Aylik degeri 50000'den az olan magazalari kapatacagiz.
gelir = 60000

if gelir < sinir:
    print("Gelir sinirdan kucuk")

sinir = 50000 
gelir = 345000

if gelir > sinir:
    print("Gelir sinirdan buyuk")
else:
    print("Gelir sinirdan kucuk")



  #else

sinir = 50000 
gelir = 51000

if gelir == sinir:
    print("Gelir sinira esittir")
else:
    print("Gelir sinira esit degildir")



  #elif
  
sinir = 50000 
gelir1 = 60000
gelir2 = 50000
gelir3 = 35000

if gelir3 > sinir:
    print("Tebrikler, hediye kazandiniz.")
elif gelir3 < sinir:
    print("Uyari!")
else:
    print("Takibe devam")




# input ve if

sinir = 50000
magaza_adi = input("Magaza adi nedir? ")     # A_subesi
gelir = int(input("Gelirinizi girin: "))     # 34000   (girdiler her zaman string olur.)

if gelir > sinir:
    print("Tebrikler: " + magaza_adi + " promosyon kazandiniz!")
elif gelir < sinir:
    print("Uyari! Dusuk gelir:" + str(gelir))
else:
    print("Takibe devam")


  

# for - Donguler:
    
ogrenci = ["ali","veli", "isik","berk"]
ogrenci[2]

for i in ogrenci:
    print(i)


maaslar = [1000, 2000,3000,4000, 5000]
for i in maaslar:
    print(i)




# for ve Fonksiyonlari Birlikte Kullanmak:

def kare_al(x):
    print(x**2)

kare_al(11)

maaslar = [1000, 2000,3000,4000, 5000]
for i in maaslar:
    print(i)


  # Maaslara %20 zam yapilacak:

1000*20/100 + 1000
maaslar[0]*20/100 + maaslar[0]
maaslar[1]*20/100 + maaslar[1]

def yeni_maas(x):
    print(x*20/100 + x)
    
for i in maaslar:
    yeni_maas(i)




# if, for ve fonksiyonlarin birlikte kullanimi:
    
  # Maasi 3000TL'den fazla olanlara %10, az olanlara %20 zam yapilacak:

maaslar = [1000, 2000,3000,4000, 5000]      
def maas_ust(x):
    print(x*10/100 + x)
    
def maas_alt(x):
    print(x*20/100 + x)  

for i in maaslar:
    if i >=3000:
        maas_ust(i)
    else:
        maas_alt(i)
        
        


# break & continue

  # Maasi 3000TL'ye kadar olanlarla ilgiliyiz. 3000'e gelince duracak:


maaslar = [8000, 5000, 2000, 1000,3000,7000, 1000]
maaslar.sort()
maaslar

for i in maaslar:
     if i == 3000:
         print("kesildi")
         break                  # ilgili satirdsn once durur. Devamin yapmaz.
     print(i)

for i in maaslar:
     if i == 3000:
         print("kesildi")
         continue               # Yalnizca belirtilen 3000 tl degerindeki degere islem yapilmadan atlanir.
     print(i)





# while
sayi = 1

while sayi < 10:
    sayi += 1
    print(sayi)





# Nesneye Yonelimli Programlama:

    
    # Sinif: Benzer ozellikler tasiyan veriler icin kullanilir.
class VeriBilimci():           # Asagida sinifin ozellikleri tanimlanir.
    bolum = ''
    sql = 'Evet'
    deneyim_yili = 0
    bildigi_diller = []

    
    # Siniflarin Ozellikerine Erismek:
VeriBilimci().bolum
VeriBilimci().sql


    # Siniflarin Ozelliklerii Degistirme:
VeriBilimci.sql = "Hayir"
VeriBilimci.sql


    # Sinif Orneklendirmesi (Instantiation):
ali = VeriBilimci()           # Ali, bu class'in bir ornegi, ozelliklerini tasiyor.
ali.sql
ali.deneyim_yili
ali.bildigi_diller.append("java")   # ali'ye ve VeriBilimci'ye eklenir.
ali.bildigi_diller
VeriBilimci.bildigi_diller          # java burada da var.

veli = VeriBilimci()
veli.bildigi_diller                 # java burda da var.


    # Ornek Ozellikleri:
        # Ayni class'ta olan kisilerin farkli ozellikler alabilmesi.
        # "def __init__(self):" satirinin altina yazilir.
class DevOps():
    def __init__(self):  
        self.bildigi_diller = []
        
ali = DevOps()
ali.bildigi_diller

veli = DevOps()
veli.bildigi_diller

ali.bildigi_diller.append('Python')
ali.bildigi_diller

veli.bildigi_diller.append("R")
veli.bildigi_diller                # Yalnizca "R"

DevOps.bildigi_diller              # Hata verir.

class DevOps():
    bolum = ''
    sql = ''
    deneyim_yili = 0
    bildigi_diller = ["Java", "R", "Python"]      # Class ile kisilerin verileri arasinda etkilesim kesildi.
    def __init__(self):  
        self.bildigi_diller = []
        self.bolum = ''

ali = DevOps()
ali.bildigi_diller                 # Bos

veli = DevOps()
veli.bildigi_diller                # Bos         

ali.bildigi_diller.append('Python')
ali.bildigi_diller                 # Yalnizca "Python"

veli.bildigi_diller.append("R")
veli.bildigi_diller                # Yalnizca "R"

DevOps.bildigi_diller              # Yalnizca "Java".
DevOps.bolum                       # Bos
ali.bolum                          # Bos
ali.bolum = "Istatistik"
veli.bolum = "end_muh"
ali.bolum                          # Istatistik
veli.bolum                         # end_muh
DevOps.bolum                       # Bos



######################################################
      # Ornek Metodlari
         # Class'lar uzerinde calisan Fonksiyon yazma.
class VeriBilimci():
    calisanlar = []
    def __init__(self):
        self.bildigi_diller = []
        self.bolum = ''
    def dil_ekle(self, yeni_dil):        # Once self yazilir.
        self.bildigi_diller.append(yeni_dil)

dir(VeriBilimci)
ali = VeriBilimci()
ali.bildigi_diller
ali.bolum

veli = VeriBilimci()
veli.bildigi_diller                # Bos
veli.bolum                         # Bos

VeriBilimci().dil_ekle("R")        # Hata
ali.dil_ekle("R")
veli.dil_ekle("Python")
veli.bildigi_diller                # Python
VeriBilimci.calisanlar.append("kemal")
VeriBilimci.calisanlar



########################################
     # Miras Yapilari (Inheritance):
        # Baska bir class'in ozelliklerini kullanmaya yarar.
class Employees():
    Locations = []
    def __init__(self):
        self.FirstName = ''        # Tek veri girilecek.
        self.LastName = ''
        self.Address = ''
        
class DataScience(Employees):
    Locations = []
    def __init__(self):
        self.Programming = ''        # Tek veri girilecek.

class Marketing(Employees):
    Locations = []
    def __init__(self):
        self.StoryTelling = ''    

veribilimci1 = DataScience()
veribilimci1.Address           # Employees'in ozelliklerini kullanabiliyor.

mar1 = Marketing()




      # Class Yapilarini Fonksiyonel Tanimlama:
class Employee_yeni():
    def __init__(self, FirstName, LastName, Address):
        self.FirstName = FirstName
        self.LastName = LastName
        self.Address = Address
        
ali = Employee_yeni()          # Hata verir. Fonksiyonel tanimli. Argumanlar eksik.
ali = Employee_yeni("ali", "yilmaz", "Istanbul")
ali.Address
ali.LastName









#####################################
#####################################
# Fonksiyonel Programlama:
    # Dilin bastacidir.
    # VBirinci sinif nesnelerdir.
    # Yan etkisiz fonksiyonlar (stateless, girdi-cikti) da vardir.
    # Yuksek seviye fonksiyonlar.
    # Vektorel orerasyonlar.
    

# Yan Etkisiz Fonksiyonlar (Pure Functions)

A = 9

def impure_sum(b):
    return b + A

def pure_sum(a,b=1):
    return a+ b

impure_sum(6)                    # A degeri degistirildiginde sonuc degisir.
pure_sum(3,4)
pure_sum(5)



    # Olumcul Yan Etkiler:
        # deneme.txt dosyasinin satir sayisini bulacagiz.

        # OOP - Nesneye Yonelik Programlama ile Cozumu:
class LineCounter:
    def __init__(self, filename):
        self.file = open(filename, 'r')
        self.lines = []
    def read(self):
        self.lines = [line for line in self.file]
    def count(self):
        return len(self.lines)


lc = LineCounter('deneme.txt')
print(lc.lines)
print(lc.count())

lc.read()
print(lc.lines)
print(lc.count())

        # Fonksiyonel Programlama ile Cozumu:
            # Degismez.
def read(filename):
    with open(filename, 'r') as f:
        return [line for line in f]
    
def count(lines):
    return len(lines)

example_lines = read('deneme.txt')
lines_count = count(example_lines)
lines_count



    # Isimsiz Fonksiyonlar (Anonymous Functions):
def old_sum(a,b):
    return a+b

old_sum(4,5)




##################################################
# lambda

new_sum = lambda a,b : a+b
new_sum(4, 6)

sirasiz_liste = [('b',3), ('a', 8), ('d',12),('c',1)]
###########################################
sorted(sirasiz_liste, key = lambda x: x[1])             # 1. degere gore siralar.
###########################################



# Vektorel Operasyonlar:
    
    # OOP
a = [1,2,3,4]                   # Tek boyutlu oldugu icin vektordur.
b = [2,3,4,5]

ab = []

for i in range(0,len(a)):       # 2 vektorun karsilikli indexlerini carpma.
    ab.append(a[i]*b[i])

ab

    # FP (Fonksiyonel Programlama): Datascience'ta bu kullanilir, yukardaki gibi donguler degil.

import numpy as np
a = np.array([1,2,3,4])
b = np.array([2,3,4,5])

a*b




# Map & Filter & Reduce

    # Her elemana 10 eklemek:

        # OOP
sayilar = [1,2,3,4,5]        
for i in liste:
    print(i + 10)

    # map: verilen bir nesne (liste) uzerinde tanimlanan fonksiyonun calismasina izin verir. 

list(map(lambda x: x + 10, sayilar))      # list(map(lambda ))  burasi sabit

list(map(lambda x: x ** 10, sayilar))


    # filter
        # 2'ye bolundugunde kalan degerler:
    
sayilar = [1,2,3,4,5,6,7,8,9,10]

list(filter(lambda x: x % 2 == 0, sayilar))     # 2'ye bolup 0'mi kaldi.

cift_sayilar = 


    # reduce
        # indirgeme islemi yapar. Listedeki sayilari toplar.
        
from functools import reduce

liste = [1,2,3,4]

reduce(lambda a,b: a+b, liste)          # 10 degerini verir.

    # lambda: 
        
fun = lambda x: x**2
fun(3)





# Moduller:
    # Modul, kutuphane, paket olarak adlandirilabilir.
    # Belirli amaclari yerine getirmek icin bir arada bulunan fonksiyonlar toplulugudur.

    # HesapModulu.py sismli bir file olusturur ve ilfili fonksiyonlari oraya yazariz.
    
def yeni_maas(x):       # HesapModulu.py file'inda yazan kod.
    return x*1.2

def iki_kati(x):
    print(x*2)


import HesapModulu
HesapMudulu.iki_kati(3)

import HesapModulu as hm
hm.yeni_maas(1000)     # 1200 olarak sonuc verir.

from HesapModulu import yeni_maas 
yeni_maas(4000)

from HesapModulu import iki_kati
iki_kati(10)

import HesapModulu 
HesapModulu.maaslar 




# Hatalar / Istisnalar "try": 
    
    # ZeroDivisionError Hatasi:        
a = 10
b = 0

a/b

try:
    print(a/b)
except ZeroDivisionError:               # Istisna olarak gor yukarda hata veren degeri.
    print("Paydada sifir olmaz")
    
    
    # Tip hatasi:
a = 10
b = "2"        
        
a / b

try:
    print(a/b)
except TypeError:
    print("Sayi ve string problemi")
    








