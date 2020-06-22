PRZYGOTOWALI: 
-ANNA GNOIŃSKA 303106
-MICHAŁ PIENIĄDZ 306486 



Program ma na celu symulacje prostego automatu z produktami.

Automat przyjmuje 4 rodzaje monet:
	M50GR - "Moneta 50 Groszy"
	M1PLN - "Moneta 1 Złoty"
	M2PLN - "Moneta 2 Złote"
	M5PLN - "Moneta 5 Złoty"

Automat posługuje się konwersją na grosze więc wprowadzane ceny prodktów są w groszach.
Automat startuje z:
	-zawartością kasetki: 3x 50gr, 3x 1PLN, 3x 2PLN
	-produkatami: 3x po 50gr, 3x po 1 PLN, 3x po 1,50PLN, 3x po 2PLN.
Automat przyporządkowywuje produktom odpowiednio kolejne litery alfabetu (A,B,C...) np pierwszy wprowadzony produkt dostaje literkę "A", drugi "B" itd.

Funkcje automatu:
1. Przyjmowanie monet np. "M50GR" wkłada do depozytu 50gr
2. "KUP-" - komenda służąca do zakupu pojedynczego produktu (np. "KUP-B")
3. "ZWROC" - komenda zwracająca włożone pieniądze z depozytu
4. "SERWIS" - komenda przekierowująca do menu serwisowego:
	"SERWIS STAN" - informacje o zawartości automatu (stan kasetki, depozyt, stan produktów)
	"SERWIS OPROZNIJ" - wydaje zawartosc kasetki automatu
	"SERWIS UZUPELNIJ" - uzupełnianie automatu (np: "SERWIS UZUPELNIJ 2 3 50 1 100" oznacza wprowadzenie dwóch typów produktów, pierwszy w liczbie 3 sztuk i cenie 50 gr, drugi w liczbie 1 sztuki i wartości 100gr)



PRZYKŁADOWA OBSŁUGA ( na prawo od znaku "#" wyjaśnienie działania):
runMachine 			# uruchamiamy automat, startujący z domyślną zawartością (linia 124)
SERWIS STAN			# sprawdzenie stanu automatu
M50GR				# wrzucamy do automatu 50 Groszy
M1PLN				# wrzucamy do automatu 1 Złoty
KUP-B				# kupujemy 2 produkt (B), automat zwraca zakupiony produkt i resztę
KUP-D				# kupujemy 4 produkt o wartości 2zł, automat zwraca "BLAD - BRAK FUNDUSZY", ponieważ nie umieściliśmy wymaganej sumy w depozycie
KUP-S				# automat zwróci "ZLY KOD PRODUKTU", ponieważ nie ma takiego artykułu
SERWIS OPROZNIJ 		# automat zwraca zawartość kasetki, tzn zarobek za sprzedane produkty
SERWIS UZUPELNIJ 1 4 250 	# włożenie do automatu jednego produktu, w liczbie 4 sztuk i cenie 2,50 PLN
M5PLN				# wrzucamy 5 Złoty
ZWROC				# zwraca wartosc depozytu tj 5 Złoty	
 




 