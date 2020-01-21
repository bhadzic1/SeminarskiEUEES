#=
Ove funkcije ocitavaju amatrice R, X, G, B koje su potrebne kod formiranja matrica Z i Y.
Koriste se u NR metodi.

=#
include("support.jl")

function YBusSparse(Line)

FromBus = Line[:,1]
ToBus = Line[:,2]
r = Line[:,3]
x = Line[:,4]
b = Line[:,5]
tap = Line[:,6]
z = r + im*x
y = 1 ./ z
b = im*b

BusNum =Int(maximum([maximum(FromBus);maximum(ToBus)])) #treba modificirat DajMax da uzima u obzir i deugu kolonu
nl = length(FromBus)
# Y = zeros(BusNum,BusNum)
Val=zeros(ComplexF64,2*nl)
# Val1=zeros(2*nl)
# Val2=zeros(2*nl)
From=zeros(nl)
To=zeros(nl)
 for k = 1:nl
     From[k]=Line[k,1]
     To[k]=Line[k,2]
     Val[k]=  round(real(-y[k]+b[k]),digits=4)+im*(round(imag(-y[k]+b[k]),digits=4))
     Val[k+nl]= round(real(-y[k]+b[k]),digits=4)+im*(round(imag(-y[k]+b[k]),digits=4))
 end
 row=trunc.(Int,[From;To])
 col=trunc.(Int,[To;From])
 row1=trunc.(Int,[From;To])
 col1=trunc.(Int,[From;To])
 temp1=sparse(row1,col1,Val)
 temp2=sparse(row,col,Val)
 temp3=-temp1+temp2
 return temp3
end

function YBusFull(Line)
    FB = Line[:,1]
    TB = Line[:,2]
    FromBus=trunc.(Int,FB)
    ToBus=trunc.(Int,TB)
    r = Line[:,3]
    x = Line[:,4]
    b = Line[:,5]
    tap = Line[:,6]
    z = r + im*x
    y = 1 ./ z
    b = im*b

    BusNum =Int(maximum([maximum(FromBus);maximum(ToBus)]))
    nl = length(FromBus)
    Y = zeros(ComplexF64,BusNum,BusNum)

    for k = 1:nl
        Y[FromBus[k],ToBus[k]] = Y[FromBus[k],ToBus[k]] - y[k]/tap[k];
        Y[ToBus[k],FromBus[k]] = Y[FromBus[k],ToBus[k]]
    end
    for m = 1:BusNum
        for n = 1:nl
            if FromBus[n] == m
                Y[m,m] = Y[m,m] + y[n]/(tap[n]^2) + b[n];
            elseif ToBus[n] == m
                Y[m,m] = Y[m,m] + y[n] + b[n];
            end
        end
    end
return sparse(Y)
end

#ispod treba jos prekontrolisat

function SparseR(a)
s1=size(a,1)
s2=Int64(DajMaks(a))
From=zeros(s1)
To=zeros(s1)
Val=zeros(2*s1)
Bus=collect(1:s2)
for i = 1 : s1
    From[i]=a[i,1]
    To[i]=a[i,2]
    Val[i]=a[i,3]
    Val[i+s1]=a[i,3]
end
row=trunc.(Int,[From;To])
col=trunc.(Int,[To;From])
row1=trunc.(Int,[From;To])
col1=trunc.(Int,[From;To])
temp1=sparse(row1,col1,Val)
temp2=sparse(row,col,Val)
temp3=temp1-temp2
return temp3
end

function SparseG(a)
s1=size(a,1)
s2=Int64(DajMaks(a))
From=zeros(s1)
To=zeros(s1)
Val=zeros(2*s1)
Bus=collect(1:s2)
for i = 1 : s1
    From[i]=a[i,1]
    To[i]=a[i,2]
    Val[i]=(1/a[i,3])
    Val[i+s1]=(1/a[i,3])
end
row=trunc.(Int,[From;To])
col=trunc.(Int,[To;From])
row1=trunc.(Int,[From;To])
col1=trunc.(Int,[From;To])
temp4=sparse(row1,col1,Val)
temp5=sparse(row,col,Val)
temp6=-temp5+temp4
return temp6
end


function SparseX(a)
s1=size(a,1)
s2=Int64(DajMaks(a))
From=zeros(s1)
To=zeros(s1)
Val=zeros(2*s1)
Bus=collect(1:s2)
for i = 1 : s1
    From[i]=a[i,1]
    To[i]=a[i,2]
    Val[i]=a[i,4]
    Val[i+s1]=a[i,4]
end
row=trunc.(Int,[From;To])
col=trunc.(Int,[To;From])
row1=trunc.(Int,[From;To])
col1=trunc.(Int,[From;To])
temp8=sparse(row1,col1,Val)
temp7=sparse(row,col,Val)
temp9=temp8-temp7
return temp9
end
function SparseB(a)
s1=size(a,1)
s2=Int64(DajMaks(a))
From=zeros(s1)
To=zeros(s1)
Val=zeros(2*s1)
Bus=collect(1:s2)
for i = 1 : s1
    From[i]=a[i,1]
    To[i]=a[i,2]
    Val[i]=(1/a[i,4])+a[i,5]
    Val[i+s1]=(1/a[i,4])+a[i,5]
end
row=trunc.(Int,[From;To])
col=trunc.(Int,[To;From])
row1=trunc.(Int,[From;To])
col1=trunc.(Int,[From;To])
temp11=sparse(row1,col1,Val)
temp10=sparse(row,col,Val)
temp12=temp11-temp10
return temp12
end

function SpBusPow(a,b)
    c=a*b*100
return c
end

function FindReference(a)
for i = 2 : size(a,1)
    if a[i,2]==1
        return i
    end
end
end

function InitialPowerA(A)
InPowA=zeros(size(A,1),1)
InPowA=A[1:end, 4]-A[1:end, 6]
end
function InitialPowerQ(A)
InPowQ=zeros(size(A,1),1)
InPowQ=A[1:end, 5]-A[1:end, 7]
end
