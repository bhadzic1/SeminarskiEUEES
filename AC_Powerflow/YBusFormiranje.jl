function YBus(Line)

FromBus = Line[:,1]
ToBus = Line[:,2]
r = Line[:,3]
x = Line[:,4]
b = Line[:,5]
a = Line[:,6]
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
     Val[k]= -y[k]+b[k]
     Val[k+nl]= -y[k]+b[k]
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
