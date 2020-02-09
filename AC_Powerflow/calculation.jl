using SparseArrays

function SparseTeta(a,b)
#gdje su a=Y bez referentnog cvora,a b=P bez referentnog cvora
#temp13=factorize(a)
temp14=a\b
s1=size(temp14,1)
for i=1:s1
    temp14[i,1]=round(temp14[i,1],digits=5)
end
return temp14
end

function Zasumi(a,b,c,d)
noise=sqrt(a).*randn(b)
c=(c+noise)*d
return c
end

# function SpBusPower(a,b)
# # Y bez referentne sabirnice, i Theta
#     c=a*b*100
# return c
# end

# function TokoviSnaga(a,b)
# FromBus=trunc.(Int,a[:,1])
# ToBus=trunc.(Int,a[:,2])
# Admitanse=a[:,3]
# s1=size(FromBus,1)
# b=[0;b]
# temp11=zeros(s1)
# for i = 1 : s1
# temp11[i]=(b[FromBus[i]]-b[ToBus[i]])/Admitanse[i]
# end
# return temp11
# end
