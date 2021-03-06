include("support.jl")
function FullNR(Ulaz,Line, Bazna)
#sljedeci korak kod razvoja ovog programa je da
BusSize = length(Ulaz[:,1])
# Y=YBusSparse(Line)
Y=sparse(YBusFull(Line)) #radi vjerovatno tačnije, ali nije sparse
G=real.(Y)
B=imag.(Y)
bus = Ulaz[:,1]
type = Ulaz[:,2]
U = Ulaz[:,3]
Tau = Ulaz[:,4]
Pg = Ulaz[:,5]/Bazna
Qg = Ulaz[:,6]/Bazna
Pl = Ulaz[:,7]/Bazna
Ql = Ulaz[:,8]/Bazna
Qmin = Ulaz[:,9]/Bazna
Qmax = Ulaz[:,10]/Bazna
P = Pg - Pl
Q = Qg - Ql
Psp = P
Qsp = Q
#kod koji nalazi indekse pU i pq sabirnica
pU = findall(type -> type==2 || type==1, type)
pq = findall(type-> type==3, type)
npU = length(pU)
npq = length(pq)
# J=zeros(BusSize-1+npq,BusSize-1+npq )
Eps = 1
Brojac = 1
#kod koji nalazi indekse pU i pq sabirnica
while (Eps > 1e-5)
# while (Brojac < 3)
    P = zeros(BusSize,1)
    Q = zeros(BusSize,1)
    for i = 1:BusSize
        for k = 1:BusSize
            P[i] = P[i] + U[i]* U[k]*(G[i,k]*cos(Tau[i]-Tau[k]) + B[i,k]*sin(Tau[i]-Tau[k]))
            Q[i] = Q[i] + U[i]* U[k]*(G[i,k]*sin(Tau[i]-Tau[k]) - B[i,k]*cos(Tau[i]-Tau[k]))
        end
    end

    if Brojac <= 7 && Brojac > 2
        for n = 2:BusSize
            if type[n] == 2
                QG = Q[n]+Ql[n]
                if QG < Qmin[n]
                    U[n] = U[n] + 0.01
                elseif QG > Qmax[n]
                    U[n] = U[n] - 0.01
                end
            end
         end
    end

    dPa = Psp-P
    dQa = Qsp-Q
    k = 1
    dQ = zeros(npq,1)
    for i = 1:BusSize
        if type[i]== 3
            dQ[k,1]=dQa[i]
            k = k+1
        end
    end
    dP = dPa[2:BusSize,1]
    M = [dP; dQ]

    J1 = zeros(BusSize-1,BusSize-1)
    for i = 1:(BusSize-1)
        m = i+1
        for k = 1:(BusSize-1)
            n = k+1
            if n == m
                for n = 1:BusSize
                    J1[i,k] = J1[i,k] + U[m]* U[n]*(-G[m,n]*sin(Tau[m]-Tau[n]) + B[m,n]*cos(Tau[m]-Tau[n]))
                end
                J1[i,k] = J1[i,k] - U[m]*U[m]*B[m,m]
            else
                J1[i,k] = U[m]*U[n]*(G[m,n]*sin(Tau[m]-Tau[n]) - B[m,n]*cos(Tau[m]-Tau[n]))
            end
        end
    end
    J2 = zeros(BusSize-1,npq)
    for i = 1:(BusSize-1)
        m = i+1
        for k = 1:npq
            n = Int(pq[k])
            if n == m
                for n = 1:BusSize
                    J2[i,k] = J2[i,k] + U[n]*(G[m,n]*cos(Tau[m]-Tau[n]) + B[m,n]*sin(Tau[m]-Tau[n]))
                end
                J2[i,k] = J2[i,k] + U[m]*G[m,m]
            else
                J2[i,k]= U[m]*(G[m,n]*cos(Tau[m]-Tau[n]) + B[m,n]*sin(Tau[m]-Tau[n]))
            end
        end
    end
    J3 = zeros(npq,BusSize-1)
    for i = 1:npq
        m = Int(pq[i])
        for k = 1:(BusSize-1)
            n = k+1
            if n == m
                for n = 1:BusSize
                    J3[i,k] = J3[i,k] + U[m]* U[n]*(G[m,n]*cos(Tau[m]-Tau[n]) + B[m,n]*sin(Tau[m]-Tau[n]))
                end
                J3[i,k] = J3[i,k] - U[m]*U[m]*G[m,m]
            else
                J3[i,k] = U[m]*U[n]*(-G[m,n]*cos(Tau[m]-Tau[n]) - B[m,n]*sin(Tau[m]-Tau[n]))
            end
        end
    end
    J4 = zeros(npq,npq)
    for i = 1:npq
        m = Int(pq[i])
        for k = 1:npq
            n = pq[k]
            if n == m
                for n = 1:BusSize
                    J4[i,k] = J4[i,k] + U[n]*(G[m,n]*sin(Tau[m]-Tau[n]) - B[m,n]*cos(Tau[m]-Tau[n]))
                end
                    J4[i,k] = J4[i,k] - U[m]*B[m,m]
            else
                J4[i,k] = U[m]*(G[m,n]*sin(Tau[m]-Tau[n]) - B[m,n]*cos(Tau[m]-Tau[n]))
            end
        end
    end
    J = sparse([J1 J2;J3 J4])
    X=J\M
    dTh = X[1:BusSize-1]
    dU = X[BusSize:end]
    Tau[2:BusSize] = dTh .+ Tau[2:BusSize]
    k = 1
    for i = 2:BusSize
        if type[i] == 3
            U[i] = dU[k] + U[i]
            k = k+1
        end
    end

    Brojac = Brojac + 1

    Eps = DajAbsMaks(M)

end
return Tau,U, Brojac #za potrebe testiranja vraca J, inace bi trebalo vratiti

end
