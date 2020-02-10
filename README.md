# SeminarskiEUEES
Seminarski rad iz predmeta EUEES (ETFEEM2) 

Ovaj kod je koristen za estimaciju stanja sistema na osnovu Newton-Raphson postupka.  

U folderu Data mogu se naći tri primejra IEEE5, IEEE14 i IEEE30. Proizvodnja i opterećenje po sabirnici, početni podaci se nalaze u .csv datoteci BusData.csv, dok se podaci o pojedinim trasama nalaze u datoteci LineData.csv. 

U folderu AC_Powerflow nalaze se sve . jl datoteke u kojima su definirane sve funkcije korištene u ovom problemu. Datoteka support.jl sadrži neke manje funkcije potrebne za proračune, dok datoteka calculations.jl ima neke osnovne funkcije od kojih je vjerovatno najznačajnija funkcija Zasumi() koja rezultate proracuna napona, uglova napona, aktivne i reaktivne snage superponira sa Gussovim šumom i time stvara vještačko mjerenje. 

Datoteke inputs.jl i YBusFormiranje.jl se bave formiranjem Y Bus matrice na nekoliko načina, dok TokoviSnaga.jl sadrži funkcije koje računaju upravo tokove snaga prema Newton-Raphson metodi. Implementirana su dva načina. Klasični i razdvojeni Newton-Rhapson. Brzi razdvojeni će biti implementiran. 

U main.jl se pozivaju potrebne funcije i zadaju se potrebne adrese za ispis rezultata u .csv formatu. Ovaj format je odabran jer ga je vrlo jednostavno koristiti sa Microsoft Excel, kao i sa bilo kojim tekst editorom, bez da korisnik mora razumjeti način formiranja rezultata. Kao defaultna izlazna adresa odabrano je "C:/", međutim u main.jl, moguće  je vrlo jednostavno promijeniti path. 

Za sve informacije i pitanja kontakt: bhadzic1@etf.unsa.ba


