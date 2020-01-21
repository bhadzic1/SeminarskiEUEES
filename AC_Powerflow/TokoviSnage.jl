function TokoviSnageAC(Ulaz,Line,U,Tau,Bazna,path)

nb = length(Ulaz[:,1])
Sab=Ulaz[:,1]
Y=YBusSparse(Line)
# Y=YBusFull(Line) radi vjerovatno tačnije, ali nije sparse
Um=PolUTrig(U,Tau)
TauS=real.((180/pi).*Tau)
FromBus= Line[:,1]
ToBus = Line[:,2]
nl=length(FromBus)
Pl = Ulaz[:,7]/Bazna
Ql = Ulaz[:,8]/Bazna

Iij = zeros(ComplexF64,nb,nb)
Sij = zeros(ComplexF64,nb,nb)
Si = zeros(ComplexF64,nb,1)

I=Y*Um;
Im=abs.(I)
Iu=angle.(I)

for i = 1:nl
    p = Int(FromBus[i])
    q = Int(ToBus[i])
    Iij[p,q] = -(Um[p] - Um[q])*Y[p,q]
    Iij[q,p] = -Iij[p,q]
end
Iij = sparse(Iij)
Iijm = abs.(Iij)
Iiju = angle.(Iij)

for m = 1:nb
    for n = 1:nb
        if m != n
            Sij[m,n] = Um[m]*conj(Iij[m,n])*Bazna
        end
    end
end

Sij = sparse(Sij)
Pij = real.(Sij)
Qij = imag.(Sij)

Gij = zeros(ComplexF64,nl,1)
for i = 1:nl
    p = Int(FromBus[i])
    q = Int(ToBus[i])
    Gij[i] = Sij[p,q] + Sij[q,p]

end
Gpij = real.(Gij)
Gqij = imag.(Gij)

for i = 1:nb
    for k = 1:nb
        Si[i] = Si[i] + conj(Um[i])* Um[k]*Y[i,k]*Bazna
    end
end
Pi = real.(Si)
Qi = -imag.(Si)
Pg = Pi+Pl;
Qg = Qi+Ql;
Gornj=["---Broj---" "---U----" "----Ugao----" "--AktInjSn--" "--ReakInjSn--" "--AktSnProiz--" "--ReaktSnProiz--" ]
Donji=["Sabirnice-" "---pu---" "---stepeni--" "----MW------" "-----MVAr----" "------MW------" "-------MVAr-----" ]
Rezultati=real.([Sab Um TauS Pi Qi Pg Qg])
Ispis=[Gornj;Donji;Rezultati]
CSV.write(path, DataFrame(Ispis), writeheader=false )
return  Ispis
end
