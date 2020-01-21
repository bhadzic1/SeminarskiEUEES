function DajMaks(a)
s1=size(a,1);
maks = 0;
for i = 1:s1
    for j=1:2
        if a[i,j] > maks
            maks = a[i,j]
        end
    end
end
return maks
end
function DajAbsMaks(a)
s1=size(a,1);
maks = 0;
for i = 1:s1
        if abs(a[i]) > maks
            maks = a[i]
        end
end
return maks
end

function IzbaciRefSnagu(a,r)
a = a[1:end .!= r, :]
return a
end

function DajKolonu(a,r)
a = a[:, r]
return a
end

function PolUTrig(a,b)
c=zeros(ComplexF64,size(a,1),1)
for i=1:size(a,1)
    c[i]=a[i]*(cos(b[i])+im*sin(b[i]))
end
return c
end
